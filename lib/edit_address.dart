import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditAddressPage extends StatefulWidget {
  final String addressId;
  final Map<String, dynamic> addressData;

  const EditAddressPage({
    super.key,
    required this.addressId,
    required this.addressData,
  });

  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _zipcodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _selectedCity;
  String? _selectedArea;

  final Map<String, List<String>> _cityAreas = {
    'Dhaka': ['Dhanmondi', 'Gulshan', 'Mirpur', 'Mohammadpur', 'Bashundhara'],
    'Chittagong': [
      'Agrabad',
      'Bhatiari',
      'Faujdarhat',
      'Pahartali',
      'Chandgoan R/A'
    ],
    'Sylhet': ['Srimangal', 'Jalalabad', 'Khadimpara', 'Mogla'],
  };

  List<String> _areas = [];

  @override
  void initState() {
    super.initState();
    _addressController.text = widget.addressData['address'];
    _zipcodeController.text = widget.addressData['zipCode'];
    _selectedCity = widget.addressData['city'];
    _selectedArea = widget.addressData['deliveryArea'];
    _updateAreas(_selectedCity);
  }

  void _updateAreas(String? city) {
    setState(() {
      _selectedCity = city;
      _selectedArea = null;
      _areas = city != null ? _cityAreas[city]! : [];
    });
  }

  Future<void> _updateAddress() async {
    if (_formKey.currentState!.validate()) {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('addresses')
            .doc(widget.addressId)
            .update({
          'city': _selectedCity,
          'deliveryArea': _selectedArea,
          'address': _addressController.text,
          'zipCode': _zipcodeController.text,
        });
        Navigator.pop(context); // Go back to the previous page
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Address'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('City'),
              DropdownButtonFormField<String>(
                value: _selectedCity,
                onChanged: (String? newValue) {
                  _updateAreas(newValue);
                },
                items: _cityAreas.keys
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a city';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              const Text('Delivery Area'),
              DropdownButtonFormField<String>(
                value: _selectedArea,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedArea = newValue;
                  });
                },
                items: _areas.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a delivery area';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              const Text('Address'),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              const Text('Post/Zip Code'),
              TextFormField(
                controller: _zipcodeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the zip code';
                  }
                  return null;
                },
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _updateAddress,
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      const Size(double.infinity, 50), // Full-width button
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'Update Address',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
