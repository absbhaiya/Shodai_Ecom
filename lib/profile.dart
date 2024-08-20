import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/updatepass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final bool _isPasswordVisible = false;
  File? _image;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      nameController.text = user!.displayName ?? '';
      emailController.text = user!.email ?? '';
      _loadUserProfile();
    }
  }

  Future<void> _loadUserProfile() async {
    if (user != null) {
      DocumentSnapshot userProfile = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (userProfile.exists) {
        phoneController.text = userProfile['phone'] ?? '';
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _uploadImage(); // Upload the selected image to Firebase
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null || user == null) return;

    try {
      String filePath = 'profile_images/${user!.uid}.png';
      await FirebaseStorage.instance.ref().child(filePath).putFile(_image!);

      String downloadUrl =
          await FirebaseStorage.instance.ref().child(filePath).getDownloadURL();

      // Update user's profile in Firebase Auth and Firestore
      await user!.updatePhotoURL(downloadUrl);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'photoURL': downloadUrl});

      // Update the user object
      setState(() {
        user = FirebaseAuth.instance.currentUser;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile image updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    }
  }

  void _updateProfile() async {
    if (user != null) {
      try {
        // Re-authenticate the user before updating email
        await _reAuthenticate();

        // Update display name
        await user!.updateDisplayName(nameController.text);
        await user!.reload();
        user = FirebaseAuth.instance.currentUser;

        // Update email
        await user!.updateEmail(emailController.text);
        await user!.reload();
        user = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({
          'phone': phoneController.text,
        });

        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }
  }

  Future<void> _reAuthenticate() async {
    try {
      String currentPassword = await _showPasswordDialog();
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );
      await user!.reauthenticateWithCredential(credential);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Re-authentication failed: $e')),
      );
    }
  }

  Future<String> _showPasswordDialog() async {
    bool _isPasswordVisible = false;

    return await showDialog<String>(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: const Text('Re-authenticate'),
                  content: TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      labelText: 'Enter Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(_passwordController.text);
                      },
                      child: const Text('Confirm'),
                    ),
                  ],
                );
              },
            );
          },
        ) ??
        '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                child: _image == null && user?.photoURL == null
                    ? const Icon(
                        Icons.person,
                        size: 50,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: _pickImage, // Trigger image selection and upload
                child: const Text('Edit'),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Password'),
              trailing: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChangePasswordPage()),
                  );
                },
                child: const Text('Change Password'),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
