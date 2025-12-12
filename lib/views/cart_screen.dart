import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/common_widgets.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/models/cart.dart';

class CartScreen extends StatelessWidget {
  final Cart cart;

  const CartScreen({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    // Aggregate counts by name
    final Map<String, int> counts = {};
    for (final item in cart.items) {
      counts[item.name] = (counts[item.name] ?? 0) + 1;
    }

    return AppScaffold(
      title: 'Cart',
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Cart Screen', style: heading1),
                  const SizedBox(height: 8),
                  if (cart.items.isEmpty)
                    const Text('Cart is empty.')
                  else ...[
                    for (final entry in counts.entries)
                      ListTile(
                        title: Text(entry.key, style: normalText),
                        trailing: Text('x${entry.value}', style: normalText),
                      ),
                    const Divider(),
                    Text('Total items: ${cart.items.length}',
                        style: normalText),
                    Text('Total price: \$${cart.totalPrice.toStringAsFixed(2)}',
                        style: normalText),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
