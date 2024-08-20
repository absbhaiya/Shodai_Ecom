import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  Future<List<Map<String, dynamic>>> _fetchOrders() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .orderBy('orderPlacedDate', descending: true)
          .get();
      return orderSnapshot.docs
          .map((doc) =>
              {'id': doc.id, 'data': doc.data() as Map<String, dynamic>})
          .toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Order'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading orders'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          final orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index]['data'];
              final orderDate =
                  (order['orderPlacedDate'] as Timestamp).toDate();
              final orderNumber = order['orderNumber'];
              final total = order['total'];
              final status = order['status'] ?? 'Pending';

              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(
                    DateFormat('EEE, dd MMM yyyy').format(orderDate),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: _getStatusColor(status),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              status,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            '৳${(total).toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text('#$orderNumber',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsPage(order: order),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Order Completed':
        return Colors.green;
      case 'Order Canceled':
        return Colors.red;
      case 'Order Processing':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class OrderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailsPage({super.key, required this.order});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Order Completed':
        return Colors.green;
      case 'Order Canceled':
        return Colors.red;
      case 'Order Processing':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEE, d MMM yyyy')
        .format((order['orderPlacedDate'] as Timestamp).toDate());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Order #${order['orderNumber']}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      order['status'],
                      style: TextStyle(
                        color: _getStatusColor(order['status']),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(formattedDate),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Method',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text('${order['paymentMethod']}'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Address',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 5),
            Center(child: Text('${order['deliveryAddress']}')),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            // const Text(
            //   'Cart Item Details',
            //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            // ),
            // for (var item in order['items'])
            //   ListTile(
            //     contentPadding: EdgeInsets.zero,
            //     leading: Image.network(item['image']),
            //     title: Text('${item['name']}'),
            //     subtitle: Text('${item['weight']}'),
            //     trailing: Column(
            //       crossAxisAlignment: CrossAxisAlignment.end,
            //       children: [
            //         Text('৳${item['price']}'),
            //         Text('Quantity: ${item['quantity']}'),
            //         Text('৳${item['price'] * item['quantity']}'),
            //       ],
            //     ),
            //   ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Subtotal'),
              trailing: Text('৳${order['subtotal']}'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Delivery Fee'),
              trailing: Text('৳${order['deliveryFee']}'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Vat (Tax)'),
              trailing: Text('৳${order['vat']}'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Discount'),
              trailing: Text('৳${order['discount']}'),
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                '৳${order['total']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
