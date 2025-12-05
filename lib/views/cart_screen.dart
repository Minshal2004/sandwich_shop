import 'package:flutter/material.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/app_styles.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Aggregate helper (same logic as used elsewhere)
  List<Map<String, dynamic>> _cartAggregates() {
    final Map<String, List<CartItem>> groups = {};
    for (final item in widget.cart.items) {
      groups.putIfAbsent(item.name, () => []).add(item);
    }
    return groups.entries
        .map((e) => {
              'name': e.key,
              'count': e.value.length,
              'price': e.value.isNotEmpty ? e.value.first.price : 0.0,
            })
        .toList();
  }

  void _decrementItem(String name) {
    final removed = widget.cart.removeOneItemByName(name);
    if (removed == null) return;
    setState(() {});
    // show undo snack - re-add removed item if undone
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed one $name'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              widget.cart.addItem(removed);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final aggregates = _cartAggregates();
    return Scaffold(
      appBar: AppBar(title: const Text('Cart', style: heading1)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Cart Summary', style: heading1),
                const SizedBox(height: 8),
                Text('Total items: ${widget.cart.items.length}',
                    style: normalText),
                Text(
                    'Total price: \$${widget.cart.totalPrice.toStringAsFixed(2)}',
                    style: normalText),
                const SizedBox(height: 8),
                if (aggregates.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Cart is empty', style: normalText),
                  )
                else
                  ...aggregates.map((entry) {
                    final String name = entry['name'] as String;
                    final int count = entry['count'] as int;
                    final double price = entry['price'] as double;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(name, style: normalText),
                      subtitle: Text('Unit: \$${price.toStringAsFixed(2)}',
                          style: normalText),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Enabled minus button: decreases quantity by one,
                          // removing the item if count reaches zero.
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => _decrementItem(name),
                          ),
                          Text('$count', style: normalText),
                        ],
                      ),
                    );
                  }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
