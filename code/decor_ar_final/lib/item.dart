class Item {
  final String name;
  final int quantity;
  final double price;

  Item({required this.name, required this.quantity, required this.price});
  double get totalCost {
    return price * quantity;
  }
}