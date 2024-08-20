import 'package:ecom/cancel_order.dart';
import 'package:ecom/main.dart';
import 'package:ecom/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderConfirmedPage extends StatelessWidget {
  final String paymentMethod;
  final DateTime orderPlacedDate;
  final String orderNumber;
  final String preferredDeliveryTime;
  final String deliveryAddress;
  final String userName;
  final String userPhoneNumber;
  final double subtotal;
  final double deliveryFee;
  final double vat;
  final double discount;
  final double total;

  const OrderConfirmedPage({
    required this.paymentMethod,
    required this.orderPlacedDate,
    required this.orderNumber,
    required this.preferredDeliveryTime,
    required this.deliveryAddress,
    required this.userName,
    required this.userPhoneNumber,
    required this.subtotal,
    required this.deliveryFee,
    required this.vat,
    required this.discount,
    required this.total,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return WillPopScope(
      onWillPop: () async {
        cartController.clearCart();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(initialIndex: 0), // Set the index you want
          ),
              (Route<dynamic> route) => false,
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Order No. $orderNumber'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              cartController.clearCart();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainPage(initialIndex: 0), // Set the index you want
                ),
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/icons/tick.png',
                        width: 50,
                        height: 65,
                      ),
                      const Text(
                        'Thanks for your order!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Your order was confirmed as ',
                              style: TextStyle(fontSize: 15),
                            ),
                            TextSpan(
                              text: paymentMethod,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const TextSpan(
                              text: '. We’re processing your order, here are the details',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      _buildOrderDetailsSection(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildOrderSummarySection(),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Would you like to cancel this order? \n',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CancelOrderWidget(orderNumber: orderNumber),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      'Cancel Order',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetailsSection() {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOrderDetailRow('Order Placed', dateFormat.format(orderPlacedDate)),
        _buildOrderDetailRow('Order Number', orderNumber),
        _buildOrderDetailRow('Preferred Delivery Time', preferredDeliveryTime),
        _buildOrderDetailRow('Delivery Address', deliveryAddress),
        _buildOrderDetailRow('Name', userName),
        _buildOrderDetailRow('Phone Number', userPhoneNumber),
      ],
    );
  }

  Widget _buildOrderSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(thickness: 1.5),
        const Text(
          'Order Summary',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildOrderDetailRow('Subtotal', '৳${subtotal.toStringAsFixed(2)}'),
        _buildOrderDetailRow('Delivery Fee', '৳${deliveryFee.toStringAsFixed(2)}'),
        _buildOrderDetailRow('VAT', '৳${vat.toStringAsFixed(2)}'),
        _buildOrderDetailRow('Discount', '- ৳${discount.toStringAsFixed(2)}', isDiscount: true),
        const Divider(thickness: 1.5),
        _buildOrderDetailRow('TOTAL', '৳${total.toStringAsFixed(2)}', isBold: true),
      ],
    );
  }

  Widget _buildOrderDetailRow(String label, String value, {bool isBold = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? Colors.red : null,
            ),
          ),
        ],
      ),
    );
  }
}
