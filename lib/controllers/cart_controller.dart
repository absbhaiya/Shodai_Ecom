import 'package:get/get.dart';
import '../models/cart_model.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;

  void addItem(CartItem item) {
    int index = cartItems.indexWhere((cartItem) => cartItem.id == item.id);
    if (index == -1) {
      cartItems.add(item);
    } else {
      cartItems[index].quantity += 1;
      cartItems.refresh();
    }
  }

  void removeItem(CartItem item) {
    int index = cartItems.indexWhere((cartItem) => cartItem.id == item.id);
    if (index != -1) {
      cartItems[index].quantity -= 1;
      if (cartItems[index].quantity == 0) {
        cartItems.removeAt(index);
      }
      cartItems.refresh();
    }
  }

  void clearCart() {
    cartItems.clear();
  }

  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice =>
      cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
}
