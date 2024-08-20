import 'package:ecom/cards/deal_cards.dart';
import 'package:ecom/product_description.dart';
import 'package:ecom/widgets/productcard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'controllers/cart_controller.dart';
import 'models/cart_model.dart';
import 'provider/items_provider.dart';
import 'widgets/socialpurchase.dart';

class DealsPage extends StatelessWidget {
  const DealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildOffersSection(cartController, favoritesProvider),
            const SizedBox(height: 5.0),
            _buildSocialDiscountSection(),
            const SizedBox(height: 5.0),
          ],
        ),
      ),
    );
  }
}

Widget _buildOffersSection(
    CartController cartController, FavoritesProvider favoritesProvider) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
    child: Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today\'s Offers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        _buildOffersList(dealcards, cartController, favoritesProvider),
        const SizedBox(
          height: 10.0,
        ),
        SizedBox(
          width: 360,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              side: const BorderSide(color: Colors.green),
              backgroundColor: Colors.white, // Background color
              shape: const StadiumBorder(), // Rounded button
              padding: const EdgeInsets.symmetric(
                  vertical: 12.0, horizontal: 40.0), // Button padding
            ),
            child: const Text(
              'SEE ALL OFFERS',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20.0,
        )
      ],
    ),
  );
}

Widget _buildOffersList(List<Map<String, dynamic>> dealcards,
    CartController cartController, FavoritesProvider favoritesProvider) {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: dealcards.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 0.7,
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 10.0,
    ),
    itemBuilder: (context, index) {
      final product = dealcards[index];
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

Widget _buildSocialDiscountSection() {
  final int endTime = DateTime.now().millisecondsSinceEpoch +
      1000 * 60 * 60 * 24 * 1; // 1 day from now

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Social Purchase',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to the ProductsPage when the button is pressed
              },
              child: const Text(
                'SEE ALL >',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        SocialDiscountCard(
          imagePath: 'assets/images/card11.png',
          title: 'Padmar Elish - Hilsha Fish (900gm - 1KG)',
          weight: '1 Kg',
          originalPrice: '৳260',
          discountedPrice: '৳245',
          progressPercentage: 30,
          endTime: endTime,
          onAddToCart: () {
            // Add to cart action
          },
        ),
        const Divider(height: 5.0),
        SocialDiscountCard(
          imagePath: 'assets/images/card12.png',
          title: 'Orange - কমলা',
          weight: '2 Kg',
          originalPrice: '৳520',
          discountedPrice: '৳400',
          progressPercentage: 40,
          endTime: endTime,
          onAddToCart: () {
            // Add to cart action
          },
        ),
      ],
    ),
  );
}
