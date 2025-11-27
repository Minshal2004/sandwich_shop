import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';

void main() {
  group('Cart', () {
    late Cart cart;

    setUp(() {
      cart = Cart();
    });

    test('Cart should start empty', () {
      expect(cart.isEmpty, true);
      expect(cart.items, isEmpty);
    });

    test('Adding an item increases the cart size', () {
      final item = CartItem(id: '1', name: 'Sandwich', price: 5.0);
      cart.addItem(item);

      expect(cart.isNotEmpty, true);
      expect(cart.items.length, 1);
      expect(cart.items.first, item);
    });

    test('Removing an item decreases the cart size', () {
      final item = CartItem(id: '1', name: 'Sandwich', price: 5.0);
      cart.addItem(item);
      cart.removeItem(item);

      expect(cart.isEmpty, true);
      expect(cart.items, isEmpty);
    });

    test('Total price is calculated correctly', () {
      final item1 = CartItem(id: '1', name: 'Sandwich', price: 5.0);
      final item2 = CartItem(id: '2', name: 'Drink', price: 2.5);
      cart.addItem(item1);
      cart.addItem(item2);

      expect(cart.totalPrice, 7.5);
    });

    test('Clearing the cart removes all items', () {
      final item1 = CartItem(id: '1', name: 'Sandwich', price: 5.0);
      final item2 = CartItem(id: '2', name: 'Drink', price: 2.5);
      cart.addItem(item1);
      cart.addItem(item2);

      cart.clear();

      expect(cart.isEmpty, true);
      expect(cart.items, isEmpty);
    });

    test('Cart should not allow modification of items directly', () {
      final item = CartItem(id: '1', name: 'Sandwich', price: 5.0);
      cart.addItem(item);

      expect(() => cart.items.add(item), throwsUnsupportedError);
    });
  });
}
