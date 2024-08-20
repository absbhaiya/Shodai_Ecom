import 'package:ecom/cards/baby_cards.dart';
import 'package:ecom/cards/deal_cards.dart';
import 'package:ecom/cards/eid_cards.dart';
import 'package:ecom/cards/inspire_cards.dart';
import 'package:ecom/cards/popular_cards.dart';
import 'package:ecom/controllers/cart_controller.dart';
import 'package:ecom/models/cart_model.dart';
import 'package:ecom/product_description.dart';
import 'package:ecom/provider/items_provider.dart';
import 'package:ecom/shopping_cart.dart';
import 'package:ecom/widgets/productcard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchText = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    // Combine products from multiple sources
    List<Map<String, dynamic>> allProducts = [
      ...popularcards,
      ...inspirecards,
      ...eidcards,
      ...dealcards,
      ...babycards,
    ];

    // Filter products based on search text
    List<Map<String, dynamic>> filteredProducts = allProducts
        .where((product) =>
            product['title'].toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search Product...',
              suffixIcon: Icon(Icons.search),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(70.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(70.0)),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            ),
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
            )),
        backgroundColor: Colors.green,
        toolbarHeight: 70.0,
        actions: [
          Obx(
            () => Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: SizedBox(
                    width: 24,
                    height: 24,
                    child: Image.asset('assets/icons/cart.png'),
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${cartController.totalItems}',
                        style: const TextStyle(
                          color: Colors.black,
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
      body: filteredProducts.isEmpty
          ? const Center(child: Text('No products found.'))
          : GridView.builder(
              shrinkWrap: true,
              itemCount: filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                final isFavorite =
                    favoritesProvider.favorites.contains(product);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDescription(
                          id: product['id'],
                          imagePath: product['imagePath'],
                          title: product['title'],
                          weight: product['weight'],
                          price: product['price'],
                          description: product['description'],
                          onFavoritePressed: () {
                            if (isFavorite) {
                              favoritesProvider.removeFavorite(product);
                            } else {
                              favoritesProvider.addFavorite(product);
                            }
                          },
                          isFavorite: isFavorite,
                        ),
                      ),
                    );
                  },
                  child: ProductCard(
                    imagePath: product['imagePath'],
                    title: product['title'],
                    weight: product['weight'],
                    price: '৳${product['price']}',
                    buttonText: product['buttonText'],
                    onPressed: () {
                      cartController.addItem(CartItem(
                        id: product['id'],
                        imagePath: product['imagePath'],
                        title: product['title'],
                        weight: product['weight'],
                        price: product['price'],
                      ));
                    },
                    onFavoritePressed: () {
                      if (isFavorite) {
                        favoritesProvider.removeFavorite(product);
                      } else {
                        favoritesProvider.addFavorite(product);
                      }
                    },
                    isFavorite: isFavorite,
                  ),
                );
              },
            ),
    );
  }
}
