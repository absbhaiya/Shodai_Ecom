import 'package:ecom/babycare.dart';
import 'package:ecom/cards/eid_cards.dart';
import 'package:ecom/cards/inspire_cards.dart';
import 'package:ecom/cards/popular_cards.dart';
import 'package:ecom/controllers/cart_controller.dart';
import 'package:ecom/eidspecial.dart';
import 'package:ecom/inspiredby.dart';
import 'package:ecom/models/cart_model.dart';
import 'package:ecom/product_description.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'popular.dart';
import 'package:ecom/widgets/productcard.dart';
import 'package:ecom/provider/items_provider.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final VoidCallback navigateToCategories;

  const Home({super.key, required this.navigateToCategories});

  @override
  Widget build(BuildContext context) {
    final Popularcards = popularcards.take(3).toList();
    final Eidcards = eidcards.take(3).toList();
    final Inspirecards = inspirecards.take(3).toList();

    final CartController cartController = Get.put(CartController());
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 180.0, // Set the height of the CarouselSlider
              child: CarouselSlider(
                items: [
                  //1st Image of Slider
                  Container(
                    margin: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/slider_img.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/slider_img2.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  //2nd Image of Slider
                ],
                //Slider Container properties
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  autoPlay: false,
                  aspectRatio: 23 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 50),
                  viewportFraction: 0.95,
                ),
              ),
            ),
            Container(
              // color: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PopularPage()),
                      );
                    },
                    child: const Text(
                      'See More >',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 300.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: Popularcards.length,
                itemBuilder: (context, index) {
                  final product = Popularcards[index];
                  final isFavorite =
                      favoritesProvider.favorites.contains(product);
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0), // Reduced padding
                    child: GestureDetector(
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
                        imagePath: product['imagePath']!,
                        title: product['title']!,
                        weight: product['weight']!,
                        price: '৳${product['price']}',
                        buttonText: product['buttonText']!,
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
                    ),
                  );
                },
              ),
            ),
            Container(
              // color: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Eid Special',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EidspecialPage()),
                      );
                    },
                    child: const Text(
                      'See More >',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 300.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: Eidcards.length,
                itemBuilder: (context, index) {
                  final product = Eidcards[index];
                  final isFavorite =
                      favoritesProvider.favorites.contains(product);
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0), // Reduced padding
                    child: GestureDetector(
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
                        imagePath: product['imagePath']!,
                        title: product['title']!,
                        weight: product['weight']!,
                        price: '৳${product['price']}',
                        buttonText: product['buttonText']!,
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
                    ),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
              child: Center(
                child: Text(
                  'Shop by Category',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to the Fruits & Vegetables category page
                          },
                          child: Column(
                            children: [
                              Image.asset('assets/images/vegetables.png',
                                  width: 170, height: 170), // Increased size
                              // const SizedBox(height: 0), // Decreased gap
                              const Text(
                                'Fruits & Vegetables',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BabyCareScreen()),
                            );
                          },
                          child: Column(
                            children: [
                              Image.asset('assets/images/baby_care.png',
                                  width: 170, height: 170), // Increased size
                              // const SizedBox(height: 4), // Decreased gap
                              const Text(
                                'Baby Care',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // Space between the rows
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to the Home & Cleaning category page
                          },
                          child: Column(
                            children: [
                              Image.asset('assets/images/cleaning.png',
                                  width: 170, height: 170), // Increased size
                              // const SizedBox(height: 4), // Decreased gap
                              const Text(
                                'Home & Cleaning',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to the Meat & Fish category page
                          },
                          child: Column(
                            children: [
                              Image.asset('assets/images/meat.png',
                                  width: 170, height: 170), // Increased size
                              // const SizedBox(height: 4), // Decreased gap
                              const Text(
                                'Meat & Fish',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: SizedBox(
                width: 360,
                child: ElevatedButton(
                  onPressed: () {
                    navigateToCategories();
                  },
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: Colors.green),
                    backgroundColor: Colors.white, // Background color
                    shape: const StadiumBorder(), // Rounded button
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 40.0), // Button padding
                  ),
                  child: const Text(
                    'VIEW ALL',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Inspired by your shopping',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InspiredbyPage()),
                      );
                    },
                    child: const Text(
                      'See More >',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 300.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: Inspirecards.length,
                itemBuilder: (context, index) {
                  final product = Inspirecards[index];
                  final isFavorite =
                      favoritesProvider.favorites.contains(product);
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0), // Reduced padding
                    child: GestureDetector(
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
                        imagePath: product['imagePath']!,
                        title: product['title']!,
                        weight: product['weight']!,
                        price: '৳${product['price']}',
                        buttonText: product['buttonText']!,
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
