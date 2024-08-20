import 'package:ecom/cards/popular_cards.dart';
import 'package:ecom/product_description.dart';
import 'package:ecom/shopping_cart.dart';
import 'package:ecom/widgets/sort_btn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'controllers/cart_controller.dart';
import 'models/cart_model.dart';
import 'provider/items_provider.dart';
import 'widgets/productcard.dart';

class PopularPage extends StatelessWidget {
  const PopularPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          title: const Text('Popular'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSortAndFilterSection(context),
            _buildOffersSection(cartController, favoritesProvider),
            const SizedBox(height: 5.0),
          ],
        ),
      ),
    );
  }

  Widget _buildSortAndFilterSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey, // Change this to your desired border color
            width: 2.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => const SortFilterBottomSheet(),
              );
            },
            child: const Text(
              'Sort & Filter',
              style: TextStyle(
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${popularcards.length}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                TextSpan(
                  text: ' items',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOffersSection(
      CartController cartController, FavoritesProvider favoritesProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          _buildOffersList(popularcards, cartController, favoritesProvider),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }

  Widget _buildOffersList(List<Map<String, dynamic>> popularcards,
      CartController cartController, FavoritesProvider favoritesProvider) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: popularcards.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemBuilder: (context, index) {
        final product = popularcards[index];
        final isFavorite = favoritesProvider.favorites.contains(product);

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
    );
  }
}
