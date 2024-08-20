import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class SocialDiscountCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String weight;
  final String originalPrice;
  final String discountedPrice;
  final int progressPercentage;
  final int endTime;
  final VoidCallback onAddToCart;

  const SocialDiscountCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.weight,
    required this.originalPrice,
    required this.discountedPrice,
    required this.progressPercentage,
    required this.endTime,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            flex: 2, // Adjust the flex value to allocate space as needed
            child: Image.asset(imagePath, height: 120, fit: BoxFit.cover),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3, // Adjust the flex value to allocate space as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(weight),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      originalPrice,
                      style: const TextStyle(
                        color: Colors.red,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(discountedPrice),
                  ],
                ),
                const SizedBox(height: 5),
                LinearProgressIndicator(
                  value: progressPercentage / 100.0,
                  backgroundColor: Colors.grey.shade300,
                  color: Colors.green,
                ),
                const SizedBox(height: 5),
                Text(
                  '$progressPercentage% Completed (Left ${100 - progressPercentage} out of 100)',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 5),
                CountdownTimer(
                  endTime: endTime,
                  widgetBuilder: (_, time) {
                    if (time == null) {
                      return const Text('Deal ended');
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTimeCard(time.days ?? 0, 'Day'),
                        _buildTimeCard(time.hours ?? 0, 'Hrs'),
                        _buildTimeCard(time.min ?? 0, 'Min'),
                        _buildTimeCard(time.sec ?? 0, 'Sec'),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(color: Colors.green),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: onAddToCart,
                    child: const Text(
                      'Add to cart',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCard(int time, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(5.0),
          child: Text(time.toString().padLeft(2, '0'),
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
