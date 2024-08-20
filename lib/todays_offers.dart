import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ecom/widgets/productcard.dart';

class OffersPage extends StatelessWidget {
  const OffersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          title: const Text('Today\'s Offers'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              icon: SizedBox(
                width: 30,
                height: 30,
                child: Image.asset('assets/icons/cart2.png'),
              ),
              onPressed: () {
                // Define what happens when the button is pressed
                if (kDebugMode) {
                  // print('Button with image pressed');
                }
              },
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
    );
  }
}
