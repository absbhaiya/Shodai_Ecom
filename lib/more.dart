import 'package:ecom/about.dart';
import 'package:ecom/blog.dart';
import 'package:ecom/coupons.dart';
import 'package:ecom/help_contact.dart';
import 'package:ecom/manage_address.dart';
import 'package:ecom/my_orders.dart';
import 'package:ecom/signin.dart';
import 'package:ecom/signup.dart';
import 'package:ecom/terms_privacy.dart';
import 'package:ecom/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  User? user;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _loadUserProfileImage();
  }

  void _updateUser(User? newUser) {
    setState(() {
      user = newUser;
      _loadUserProfileImage(); // Reload the profile image when the user changes
    });
  }

  Future<void> _loadUserProfileImage() async {
    if (user != null) {
      try {
        // Assuming the user's profile image is stored with the user's UID as the filename
        String filePath = 'profile_images/${user!.uid}.png';
        String downloadUrl = await FirebaseStorage.instance
            .ref()
            .child(filePath)
            .getDownloadURL();

        setState(() {
          imageUrl = downloadUrl;
        });
      } catch (e) {
        // Handle the case where the image does not exist
        print('Failed to load profile image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildUserProfileSection(),
              const SizedBox(height: 10),
              user != null ? _buildPromoSection() : _buildLoginSection(),
              const SizedBox(height: 10),
              _buildMenuSection(),
              const SizedBox(height: 10),
              if (user != null) _buildLogout(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromoSection() {
    return Container(
      height: 100,
      margin: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        image: const DecorationImage(
          image: AssetImage('assets/images/profile_promo.png'),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildUserProfileSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: imageUrl != null
                ? NetworkImage(imageUrl!)
                : null, // Display the image if available
            child: imageUrl == null
                ? SvgPicture.asset(
                    'assets/icons/user_icon.svg',
                    semanticsLabel: 'User Icon',
                  )
                : null, // Display the default SVG icon if no image is available
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.displayName ?? 'Guest User',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              GestureDetector(
                onTap: user != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ProfilePage(), // Pass the user here
                          ),
                        );
                      }
                    : null,
                child: Text(
                  user != null ? 'View Profile' : 'Sign in to view profile',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.green),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogout() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Logout'),
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Log Out',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Are you sure you want to logout?',
                        style: TextStyle(fontSize: 16, height: 3.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50.0),
                              backgroundColor: Colors.grey,
                            ),
                            child: const Text(
                              'No',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                await FirebaseAuth.instance.signOut();
                                _updateUser(null);
                                Navigator.pop(context);
                              } catch (e) {
                                // Handle error
                              }
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              backgroundColor: Colors.red,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50.0),
                            ),
                            child: const Text(
                              'Yes',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoginSection() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.add_circle_outline),
          title: const Text('Log In'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignInPage()),
            ).then((_) {
              _updateUser(FirebaseAuth.instance.currentUser);
            });
          },
        ),
        _buildDivider(),
        ListTile(
          leading: const Icon(Icons.login_outlined),
          title: const Text('Register'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignUpPage()),
            ).then((_) {
              _updateUser(FirebaseAuth.instance.currentUser);
            });
          },
        ),
      ],
    );
  }

  Widget _buildMenuSection() {
    return Column(
      children: [
        _buildMenuItem(Icons.home_outlined, 'Manage Address', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ManageAddressPage()),
          );
        }),
        _buildMenuItem(Icons.discount_outlined, 'My Coupons', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CouponsPage()),
          );
        }),
        _buildMenuItem(Icons.shopping_bag, 'My Order', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyOrdersPage()),
          );
        }),
        _buildMenuItem(Icons.help_outline, 'Help & Contact', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HelpContactPage()),
          );
        }),
        _buildMenuItem(Icons.info_outline, 'About', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutPage()),
          );
        }),
        _buildMenuItem(Icons.article, 'Blog', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BlogPage()),
          );
        }),
        _buildMenuItem(Icons.local_police_outlined, 'Terms & Privacy Policy',
            () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TermsPrivacyPage()),
          );
        }),
        _buildMenuItem(Icons.sunny, 'Switch Themes', () {
          showModalBottomSheet(
              context: context,
              builder: (context) => Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.light_mode),
                          title: const Text('Light Mode'),
                          onTap: () {
                            Get.changeTheme(ThemeData.light());
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.dark_mode),
                          title: const Text('Dark Mode'),
                          onTap: () {
                            Get.changeTheme(ThemeData.dark());
                          },
                        )
                      ],
                    ),
                  ));
        }),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
        _buildDivider(),
      ],
    );
  }

  Widget _buildDivider() {
    return const Divider(endIndent: 10.0, indent: 10.0);
  }
}
