class CartItem {
  final String id;
  final String name;
  final double price;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
  });
}

class Cart {
  // In-memory list of cart items (each represents a single unit).
  final List<CartItem> items = [];

  /// Add a cart item (single unit).
  void addItem(CartItem item) {
    items.add(item);
  }

  /// Remove a single CartItem instance matching [name].
  /// Returns the removed CartItem if found, otherwise null.
  CartItem? removeOneItemByName(String name) {
    final int index = items.indexWhere((i) => i.name == name);
    if (index == -1) return null;
    return items.removeAt(index);
  }

  /// Total price computed from stored CartItem.price values.
  double get totalPrice =>
      items.fold(0.0, (double sum, CartItem item) => sum + item.price);

  /// Convenience: clear cart
  void clear() => items.clear();
}
