import 'package:flutter/material.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => _favorites;

  void addFavorite(Map<String, dynamic> product) {
    _favorites.add(product);
    notifyListeners();
  }

  void removeFavorite(Map<String, dynamic> product) {
    _favorites.remove(product);
    notifyListeners();
  }
}
