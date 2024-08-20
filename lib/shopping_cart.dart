import 'package:ecom/checkout_page.dart';
import 'package:ecom/main.dart';
import 'package:ecom/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  final CartController cartController = Get.put(CartController());
  final TextEditingController couponController = TextEditingController();
  final RxString appliedCoupon = ''.obs;
  final RxDouble discount = 0.0.obs;
  final double deliveryFee = 50.0;
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  void applyCoupon() {
    String coupon = couponController.text.trim();
    switch (coupon) {
      case 'MEGA300':
        appliedCoupon.value = 'MEGA300';
        discount.value = 300.0;
        break;
      case 'DEAL100':
        appliedCoupon.value = 'DEAL100';
        discount.value = 100.0;
        break;
      case 'MINI50':
        appliedCoupon.value = 'MINI50';
        discount.value = 50.0;
        break;
      default:
        appliedCoupon.value = '';
        discount.value = 0.0;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          title: const Text('Shopping Cart'),
          toolbarHeight: 70.0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Colors.grey,
              height: 1.0,
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/shopping-cart.png',
                  height: 120,
                  width: 100,
                ),
                const Text(
                  'Empty Cart',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, height: 1.5),
                ),
                const Text(
                  'Looks like you haven\'t shopped yet',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF9B9899),
                      height: 2.0),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Background color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: const Text(
                    'Shop Now',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        } else {
          double subtotal = cartController.totalPrice;
          double deliveryFee = 50.0;
          double total = subtotal + deliveryFee - discount.value;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartController.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartController.cartItems[index];
                      return Dismissible(
                        key: UniqueKey(), // Ensure each item has a unique key
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            // cartController.removeItem(item);
                            cartController.cartItems.removeAt(index);
                          });
                          final removedItem = item;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('Removed from cart'),
                            action: SnackBarAction(
                              label: 'UNDO',
                              onPressed: () {
                                cartController.addItem(removedItem);
                              },
                              textColor: Colors.white,
                            ),
                          ));
                        },
                        background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Text(
                              'REMOVE',
                              style: TextStyle(color: Colors.white),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Card(
                            color: Colors.transparent,
                            elevation: 0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      item.imagePath,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              // color: Colors
                                              //     .black, // Adjust text color
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            item.weight,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              // color: Colors
                                              //     .black, // Adjust text color
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '৳${(item.price).toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              // color: Colors
                                              //     .black, // Adjust text color
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.remove,
                                                  color: Colors
                                                      .white, // Adjust icon color
                                                ),
                                                onPressed: () {
                                                  cartController
                                                      .removeItem(item);
                                                },
                                                style: IconButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                ),
                                              ),
                                              Text('${item.quantity}',
                                                  style: const TextStyle(
                                                      // color: Colors.black,
                                                      fontSize: 18)),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.add,
                                                  color: Colors
                                                      .white, // Adjust icon color
                                                ),
                                                onPressed: () {
                                                  cartController.addItem(item);
                                                },
                                                style: IconButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                ///Subtotal Row///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Subtotal:',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '৳${cartController.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ),

                ///Coupon Code Row///
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: TextFormField(
                          controller: couponController,
                          decoration: const InputDecoration(
                            hintText: 'Enter Coupon Code',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter valid coupon code';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Flexible(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  minimumSize: const Size(double.infinity, 55),
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(5.0))),
                              onPressed: applyCoupon,
                              child: const Text(
                                'Apply',
                                style: TextStyle(color: Colors.white),
                              )))
                    ],
                  ),
                ),

                ///Discount and Delivery Row///
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Discount:',
                            style: TextStyle(fontSize: 17),
                          ),
                          Obx(
                            () => Text(
                              '- ৳${discount.value.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delivery Fee:',
                            style: TextStyle(fontSize: 17),
                          ),
                          Text(
                            '৳50.00',
                            style: TextStyle(fontSize: 17),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),

                ///Total row///
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Obx(() {
                    double subtotal = cartController.totalPrice;
                    double total = subtotal + deliveryFee - discount.value;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '৳$total',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    );
                  }),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onPressed: () {
                      if (user != null) {
                        // Navigate to CheckoutPage if logged in
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutPage(
                              subtotal: subtotal,
                              deliveryFee: deliveryFee,
                              vat: (subtotal * 0.1),
                              discount: discount.value,
                              total: total,
                            ),
                          ),
                        );
                      } else {
                        // Navigate to Login Page if not logged in
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInPage(),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Checkout (${cartController.totalItems})',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
