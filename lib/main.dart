import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/profile_screen.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/views/about_screen.dart';
import 'package:sandwich_shop/widgets/app_shell.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  App({super.key});

  // Shared cart instance reused across screens
  final Cart sharedCart = Cart();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandwich Shop App',
      initialRoute: '/order',
      routes: {
        '/order': (context) => OrderScreen(cart: sharedCart, maxQuantity: 5),
        '/cart': (context) => CartScreen(cart: sharedCart),
        '/profile': (context) => const ProfileScreen(),
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}

class OrderScreen extends StatefulWidget {
  final int maxQuantity;
  final Cart cart;

  const OrderScreen({super.key, required this.cart, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final TextEditingController _notesController = TextEditingController();

  SandwichType _selectedSandwichType = SandwichType.veggieDelight;
  bool _isFootlong = true;
  BreadType _selectedBreadType = BreadType.white;
  int _quantity = 1;

  String _confirmationMessage = ''; // Display message after adding to cart

  @override
  void initState() {
    super.initState();
    _notesController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _addToCart() {
    if (_quantity > 0) {
      for (int i = 0; i < _quantity; i++) {
        final CartItem cartItem = CartItem(
          id: UniqueKey().toString(),
          name:
              '${_isFootlong ? "Footlong" : "Six-inch"} ${_selectedSandwichType.name} on ${_selectedBreadType.name} bread',
          price: 5.0,
        );
        widget.cart.addItem(cartItem);
      }

      final sizeText = _isFootlong ? 'footlong' : 'six-inch';
      final message =
          'Added $_quantity $sizeText ${_selectedSandwichType.name} sandwich(es) to cart';

      setState(() {
        _confirmationMessage = message;
      });

      debugPrint(message);
    }
  }

  VoidCallback? _getAddToCartCallback() => _quantity > 0 ? _addToCart : null;

  List<DropdownMenuItem<SandwichType>> _buildSandwichTypeEntries() {
    return SandwichType.values
        .map((type) => DropdownMenuItem(
              value: type,
              child: Text(
                  Sandwich(
                          type: type,
                          isFootlong: true,
                          breadType: BreadType.white)
                      .name,
                  style: normalText),
            ))
        .toList();
  }

  List<DropdownMenuItem<BreadType>> _buildBreadTypeEntries() {
    return BreadType.values
        .map((bread) => DropdownMenuItem(
              value: bread,
              child: Text(bread.name, style: normalText),
            ))
        .toList();
  }

  String _getCurrentImagePath() {
    return Sandwich(
      type: _selectedSandwichType,
      isFootlong: _isFootlong,
      breadType: _selectedBreadType,
    ).image;
  }

  void _onSandwichTypeChanged(SandwichType? value) {
    if (value != null) setState(() => _selectedSandwichType = value);
  }

  void _onSizeChanged(bool value) => setState(() => _isFootlong = value);

  void _onBreadTypeChanged(BreadType? value) {
    if (value != null) setState(() => _selectedBreadType = value);
  }

  void _increaseQuantity() {
    if (_quantity < widget.maxQuantity) setState(() => _quantity++);
  }

  void _decreaseQuantity() {
    if (_quantity > 0) setState(() => _quantity--);
  }

  VoidCallback? _getDecreaseCallback() =>
      _quantity > 0 ? _decreaseQuantity : null;

  // Aggregate cart items by name for display (returns list of maps with name, count, price)
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

  // Remove a single instance of the named cart item. If it was the last instance, the row disappears.
  void _decrementCartItem(String name) {
    final int index = widget.cart.items.indexWhere((i) => i.name == name);
    if (index == -1) return;
    final removed = widget.cart.items.removeAt(index);
    setState(() {});
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed one ${removed.name}'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              final insertIndex = index <= widget.cart.items.length
                  ? index
                  : widget.cart.items.length;
              widget.cart.items.insert(insertIndex, removed);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sandwich Counter', style: heading1)),
      drawer: const AppDrawer(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 300,
                child: Image.asset(
                  _getCurrentImagePath(),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(
                      child: Text('Image not found', style: normalText)),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButton<SandwichType>(
                value: _selectedSandwichType,
                onChanged: _onSandwichTypeChanged,
                items: _buildSandwichTypeEntries(),
                isExpanded: true,
                hint: const Text('Sandwich Type', style: normalText),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Six-inch', style: normalText),
                  Switch(value: _isFootlong, onChanged: _onSizeChanged),
                  const Text('Footlong', style: normalText),
                ],
              ),
              const SizedBox(height: 20),
              DropdownButton<BreadType>(
                value: _selectedBreadType,
                onChanged: _onBreadTypeChanged,
                items: _buildBreadTypeEntries(),
                isExpanded: true,
                hint: const Text('Bread Type', style: normalText),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Quantity: ', style: normalText),
                  IconButton(
                      onPressed: _getDecreaseCallback(),
                      icon: const Icon(Icons.remove)),
                  Text('$_quantity', style: heading1),
                  IconButton(
                      onPressed: _increaseQuantity,
                      icon: const Icon(Icons.add)),
                ],
              ),
              const SizedBox(height: 20),
              StyledButton(
                onPressed: _getAddToCartCallback(),
                icon: Icons.add_shopping_cart,
                label: 'Add to Cart',
                backgroundColor: Colors.green,
              ),
              const SizedBox(height: 10),
              // Display confirmation message
              if (_confirmationMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _confirmationMessage,
                    style: normalText.copyWith(color: Colors.green),
                  ),
                ),
              const SizedBox(height: 10),
              // Permanent cart summary (updated to allow decrement/removal)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                          style: normalText,
                        ),
                        const SizedBox(height: 8),
                        if (widget.cart.items.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text('Cart is empty', style: normalText),
                          )
                        else
                          ..._cartAggregates().map((entry) {
                            final String name = entry['name'] as String;
                            final int count = entry['count'] as int;
                            final double price = entry['price'] as double;
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(name, style: normalText),
                              subtitle: Text(
                                  'Unit: \$${price.toStringAsFixed(2)}',
                                  style: normalText),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () => _decrementCartItem(name),
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
              const SizedBox(height: 20),
              // Profile navigation button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/profile');
                  },
                  child: const Text('Profile'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;

  const StyledButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        textStyle: normalText,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;
  final BreadType breadType;
  final String orderNote;

  const OrderItemDisplay({
    super.key,
    required this.quantity,
    required this.itemType,
    required this.breadType,
    required this.orderNote,
  });

  @override
  Widget build(BuildContext context) {
    final String sandwichEmojis = List.filled(quantity, '🥪').join();
    final String displayText =
        '$quantity ${breadType.name} $itemType sandwich(es): $sandwichEmojis';
    return Column(
      children: [
        Text(displayText, style: normalText),
        const SizedBox(height: 8),
        Text('Note: $orderNote', style: normalText),
      ],
    );
  }
}

// No changes required to this file to resolve the pubspec.yaml error.
// Ensure you run `flutter run` from the folder that contains pubspec.yaml (project root).
