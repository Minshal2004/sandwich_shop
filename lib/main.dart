import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/models/cart.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sandwich Shop App',
      home: OrderScreen(maxQuantity: 5),
    );
  }
}

class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final Cart _cart = Cart();
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
        _cart.addItem(cartItem);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandwich Counter', style: heading1),
      ),
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
              // Permanent cart summary
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
                        Text('Total items: ${_cart.items.length}',
                            style: normalText),
                        Text(
                          'Total price: \$${_cart.totalPrice.toStringAsFixed(2)}',
                          style: normalText,
                        ),
                      ],
                    ),
                  ),
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
