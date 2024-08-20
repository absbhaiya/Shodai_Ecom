import 'package:ecom/babycare.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionTile(
              leading: Image.asset('assets/images/baby_care.png', width: 40),
              title: const Text('Baby Care'),
              children: <Widget>[
                ListTile(
                  title: const Text('Diapers'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BabyCareScreen()),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Baby Accessories'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BabyCareScreen()),
                    );
                  },
                ),
              ],
            ),
            ExpansionTile(
              leading: Image.asset('assets/images/vegetables.png', width: 40),
              title: const Text('Grocery'),
              children: <Widget>[
                ListTile(
                  title: const Text('Subcategory 1'),
                  onTap: () {
                    // Handle the subcategory tap
                  },
                ),
                ListTile(
                  title: const Text('Subcategory 2'),
                  onTap: () {
                    // Handle the subcategory tap
                  },
                ),
              ],
            ),
            ExpansionTile(
              leading: Image.asset('assets/images/meat.png', width: 40),
              title: const Text('Meat & Fish'),
              children: <Widget>[
                ListTile(
                  title: const Text('Subcategory 1'),
                  onTap: () {
                    // Handle the subcategory tap
                  },
                ),
                ListTile(
                  title: const Text('Subcategory 2'),
                  onTap: () {
                    // Handle the subcategory tap
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: CategoriesPage(),
  ));
}
