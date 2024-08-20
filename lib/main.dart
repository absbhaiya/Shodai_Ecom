import 'package:ecom/cards/baby_cards.dart';
import 'package:ecom/cards/deal_cards.dart';
import 'package:ecom/cards/eid_cards.dart';
import 'package:ecom/cards/inspire_cards.dart';
import 'package:ecom/cards/popular_cards.dart';
import 'package:ecom/search.dart';
import 'package:ecom/widgets/product_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'controllers/cart_controller.dart';
import 'firebase_options.dart';
import 'items_page.dart';
import 'categories.dart';
import 'home.dart';
import 'deals.dart';
import 'provider/items_provider.dart';
import 'shopping_cart.dart';
import 'more.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await addOrUpdateProductsInFirestore('popularProducts', popularcards);
  await addOrUpdateProductsInFirestore('eidProducts', eidcards);
  await addOrUpdateProductsInFirestore('inspireProducts', inspirecards);
  await addOrUpdateProductsInFirestore('dealsProducts', dealcards);
  await addOrUpdateProductsInFirestore('babyProducts', babycards);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ECOM Android APP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  final int initialIndex;

  const MainPage({super.key, this.initialIndex = 0});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _selectedIndex;
  User? user;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    user = FirebaseAuth.instance.currentUser;
    _loadUserProfileImage();
  }

  Future<void> _loadUserProfileImage() async {
    if (user != null) {
      try {
        String filePath = 'profile_images/${user!.uid}.png';
        String downloadUrl = await FirebaseStorage.instance
            .ref()
            .child(filePath)
            .getDownloadURL();

        setState(() {
          imageUrl = downloadUrl;
        });
      } catch (e) {
        print('Failed to load profile image: $e');
      }
    }
  }

  void _navigateToCategories() {
    setState(() {
      _selectedIndex = 1; // Categories is at index 1
    });
  }

  static List<Widget> _widgetOptions(VoidCallback navigateToCategories) =>
      <Widget>[
        Home(navigateToCategories: navigateToCategories),
        const CategoriesPage(),
        const DealsPage(),
        const ItemsPage(),
        const MorePage(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 4
          ? null
          : AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(5),
                child: CircleAvatar(
                  // radius: 20,
                  backgroundImage:
                      imageUrl != null ? NetworkImage(imageUrl!) : null,
                  child: imageUrl == null
                      ? SvgPicture.asset(
                          'assets/icons/user_icon.svg',
                          semanticsLabel: 'User Icon',
                        )
                      : null,
                ),
              ),
              title: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: Colors.green),
                    backgroundColor: Colors.white, // Background color
                    shape: const StadiumBorder(), // Rounded button
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 12.0), // Button padding
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'Search Product...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.search,
                      ),
                    ],
                  ),
                ),
              ),
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
              backgroundColor: Colors.green,
              toolbarHeight: 70.0,
            ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions(_navigateToCategories),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/Home.png', width: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/Categories.png', width: 24),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/Deals.png', width: 24),
            label: 'Deals',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/My_Items.png', width: 24),
            label: 'My Items',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/More.png', width: 24),
            label: 'More',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
