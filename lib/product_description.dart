import 'package:ecom/models/cart_model.dart';
import 'package:ecom/shopping_cart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../controllers/cart_controller.dart';

class ProductDescription extends StatefulWidget {
  final String id;
  final String imagePath;
  final String title;
  final String weight;
  final double price;
  final String description;
  final VoidCallback onFavoritePressed;
  final bool isFavorite;

  const ProductDescription({
    super.key,
    required this.id,
    required this.imagePath,
    required this.title,
    required this.weight,
    required this.price,
    required this.description,
    required this.onFavoritePressed,
    required this.isFavorite,
  });

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  late bool isFavorite;

  final CartController cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
    widget.onFavoritePressed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              Share.share('Check out this amazing product!');
            },
            icon: const Icon(Icons.share),
          ),
          Obx(
            () => Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: SizedBox(
                    width: 24,
                    height: 24,
                    child: Image.asset('assets/icons/cart2.png'),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShoppingCartPage(),
                      ),
                    );
                  },
                ),
                if (cartController.totalItems > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${cartController.totalItems}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Center(
                    child: Image.asset(widget.imagePath,
                        height: MediaQuery.of(context).size.height * 0.35,
                        fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 16),

                  // Product Title
                  Center(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Product Weight
                  Text(
                    widget.weight,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),

                  // Product Price
                  Row(
                    children: [
                      Text(
                        "৳ ${widget.price}",
                        style:
                            const TextStyle(fontSize: 19, color: Colors.green),
                      ),
                      const SizedBox(width: 255),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.black,
                        ),
                        onPressed: toggleFavorite,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Product Description
                  ExpansionTile(
                    title: const Text("Product Details"),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.description,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                width: 300,
                child: OutlinedButton(
                  onPressed: () {
                    cartController.addItem(CartItem(
                      id: widget.id,
                      imagePath: widget.imagePath,
                      title: widget.title,
                      weight: widget.weight,
                      price: widget.price,
                      quantity: 1,
                    ));
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.green),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    "Add to Cart",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
