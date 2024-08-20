import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CancelOrderWidget extends StatelessWidget {
  final String orderNumber;

  const CancelOrderWidget({super.key, required this.orderNumber});

  Future<void> _cancelOrder() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .where('orderNumber', isEqualTo: orderNumber)
          .get();
      if (orderSnapshot.docs.isNotEmpty) {
        final DocumentReference orderDoc = orderSnapshot.docs.first.reference;
        await orderDoc.update({'status': 'Order Canceled'});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancel Order'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _cancelOrder();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Order status updated to Canceled')),
            );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: const Text(
            'Confirm Cancel',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
