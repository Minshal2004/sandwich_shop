import 'package:flutter/material.dart';
import 'package:sandwich_shop/repositories/PricingRepository.dart';
import 'package:sandwich_shop/views/app_styles.dart';

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
  late final OrderRepository _orderRepository;
  final TextEditingController _notesController = TextEditingController();
  bool _isFootlong = true;
  bool _isToasted = false;
  BreadType _selectedBreadType = BreadType.white;

  @override
  void initState() {
    super.initState();
    _orderRepository = OrderRepository(maxQuantity: widget.maxQuantity);
    _notesController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  VoidCallback? _getIncreaseCallback() {
    if (_orderRepository.canIncrement) {
      return () => setState(_orderRepository.increment);
    }
    return null;
  }

  VoidCallback? _getDecreaseCallback() {
    if (_orderRepository.canDecrement) {
      return () => setState(_orderRepository.decrement);
    }
    return null;
  }

  void _onSandwichTypeChanged(bool value) {
    setState(() => _isFootlong = value);
  }

  void _onBreadTypeSelected(BreadType? value) {
    if (value != null) {
      setState(() => _selectedBreadType = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pricingRepository = PricingRepository(
      quantity: _orderRepository.quantity,
      isFootlong: _isFootlong,
    );
    final totalPrice = pricingRepository.getTotalPrice();
    String sandwichType = _isFootlong ? 'footlong' : 'six-inch';
    String noteForDisplay = _notesController.text.isEmpty
        ? 'No notes added.'
        : _notesController.text;

    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(
          height: 100,
          child: Image.asset('assets/images/logo.png'),
        ),
        title: const Text(
          'Sandwich Counter',
          style: heading1,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OrderItemDisplay(
              quantity: _orderRepository.quantity,
              itemType: sandwichType,
              breadType: _selectedBreadType,
              orderNote: noteForDisplay,
            ),
            Text('Total Price: £${totalPrice.toStringAsFixed(2)}',
                style: heading1),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('six-inch', style: normalText),
                Switch(
                  key: const Key('sandwichTypeSwitch'),
                  value: _isFootlong,
                  onChanged: _onSandwichTypeChanged,
                ),
                const Text('footlong', style: normalText),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('untoasted', style: normalText),
                Switch(
                  key: const Key('toastedSwitch'),
                  value: _isToasted,
                  onChanged: (value) => setState(() => _isToasted = value),
                ),
                const Text('toasted', style: normalText),
              ],
            ),
            const SizedBox(height: 10),
            DropdownButton<BreadType>(
              value: _selectedBreadType,
              items: BreadType.values.map((bread) {
                return DropdownMenuItem<BreadType>(
                  value: bread,
                  child: Text(bread.name, style: normalText),
                );
              }).toList(),
              onChanged: _onBreadTypeSelected,
              style: normalText,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: TextField(
                key: const Key('notes_textfield'),
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Add a note (e.g., no onions)',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledButton(
                  key: const Key('addButton'),
                  onPressed: _getIncreaseCallback(),
                  icon: Icons.add,
                  label: 'Add',
                  backgroundColor: Colors.green,
                ),
                const SizedBox(width: 8),
                StyledButton(
                  key: const Key('removeButton'),
                  onPressed: _getDecreaseCallback(),
                  icon: Icons.remove,
                  label: 'Remove',
                  backgroundColor: Colors.red,
                ),
              ],
            ),
          ],
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
    String displayText =
        '$quantity ${breadType.name} $itemType sandwich(es): ${'🥪' * quantity}';
    return Column(
      children: [
        Text(displayText, style: normalText),
        const SizedBox(height: 8),
        Text('Note: $orderNote', style: normalText),
      ],
    );
  }
}
