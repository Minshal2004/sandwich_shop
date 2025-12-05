class Cart {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(CartItem item) {
    _items.add(item);
  }

  void removeItem(CartItem item) {
    _items.remove(item);
  }

  double get totalPrice {
    return _items.fold(0, (sum, item) => sum + item.price);
  }

  void clear() {
    _items.clear();
  }

  bool get isEmpty => _items.isEmpty;

  bool get isNotEmpty => _items.isNotEmpty;

  /// Remove a single CartItem instance matching [name].
  /// Returns the removed CartItem if found, otherwise null.
  CartItem? removeOneItemByName(String name) {
    final int index = _items.indexWhere((i) => i.name == name);
    if (index == -1) return null;
    return _items.removeAt(index);
  }
}

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
