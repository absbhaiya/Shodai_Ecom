import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addOrUpdateProductsInFirestore(
    String collectionName, List<Map<String, dynamic>> productList) async {
  CollectionReference productsCollection =
      FirebaseFirestore.instance.collection(collectionName);

  QuerySnapshot querySnapshot = await productsCollection.get();
  Map<String, DocumentSnapshot> existingProducts = {
    for (var doc in querySnapshot.docs) doc['id']: doc
  };

  for (var product in productList) {
    if (existingProducts.containsKey(product['id'])) {
      // Product exists, check if details are different
      var existingProduct = existingProducts[product['id']];
      bool needsUpdate = false;

      // Compare each field (excluding id)
      for (var key in product.keys) {
        if (key != 'id' && existingProduct![key] != product[key]) {
          needsUpdate = true;
          break;
        }
      }

      if (needsUpdate) {
        // Update the product details in Firestore
        await productsCollection
            .doc(existingProduct!.id)
            .update(product)
            .then((value) {
          print("Product Updated: ${existingProduct.id}");
        }).catchError((error) {
          print("Failed to update product: $error");
        });
      } else {
        print("No changes for product: ${product['id']}");
      }
    } else {
      // Add new product to Firestore
      await productsCollection.add(product).then((value) {
        print("Product Added: ${value.id}");
      }).catchError((error) {
        print("Failed to add product: $error");
      });
    }
  }
}
