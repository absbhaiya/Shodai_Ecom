class CartItem {
  final String id;
  final String imagePath;
  final String title;
  final String weight;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.weight,
    required this.price,
    this.quantity = 1,
  });
}
