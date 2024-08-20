import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'About Shodai',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Shodai is a location based food and grocery service. You will find everything healthy and hygienic from our wide range of products category. You are able to order your desired products which will be delivered right to your doorstep.\n\nSometimes it is not possible for you to shop necessary things just for lack of time. Shodai can take responsibility to complete your shopping task so that you can spend your time with your loved ones.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text(
              'Who We Are',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Shodai is an initiative of Monico Technologies Limited, which started its journey in 2009. MTL started their career to provide safety of vehicles. Our service brand name is Finder GPS Tracking service which has already gained confidence by providing the best tracking service for vehicles in Bangladesh. Monico Technologies Limited is the sister concern of Monico Limited which was established in 1986 as a construction company. After providing service in various sectors MTL has started their online grocery platform Shodai. Our Trade License Number is 05-60219.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
