import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CouponsPage extends StatelessWidget {
  const CouponsPage({super.key});

  final List<Map<String, String>> coupons = const [
    {
      'image': 'assets/coupons/300.png',
      'code': 'MEGA300',
    },
    {
      'image': 'assets/coupons/100.png',
      'code': 'DEAL100',
    },
    {
      'image': 'assets/coupons/50.png',
      'code': 'MINI50',
    },
    // Add more coupons as needed
  ];

  void _copyCouponCode(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Coupon code "$code" copied to clipboard!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Coupons'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: coupons.length,
        itemBuilder: (context, index) {
          final coupon = coupons[index];
          return GestureDetector(
            onTap: () => _copyCouponCode(context, coupon['code']!),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0), // Spacing between list items
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  coupon['image']!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      )

    );
  }
}
