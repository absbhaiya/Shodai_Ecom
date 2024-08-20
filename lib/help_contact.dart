import 'package:ecom/contactus.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpContactPage extends StatelessWidget {
  const HelpContactPage({super.key});

  void _launchCaller(String number) async {
    final Uri callUri = Uri(scheme: 'tel', path: number);
    print(
        'Attempting to call $number with URI: $callUri'); // Debugging information

    if (await canLaunchUrl(callUri)) {
      print('Launching URI: $callUri'); // Debugging information
      await launchUrl(callUri);
    } else {
      print('Could not launch $callUri'); // Debugging information
      throw 'Could not launch $number';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Contact'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('Contact Us'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactUsPage()),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Help Line'),
            trailing: TextButton(
              onPressed: () => _launchCaller('+8801534270937'),
              child: const Text(
                '+88 0153 4270 937',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
