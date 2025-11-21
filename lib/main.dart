import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/repositories/order_repository.dart';

void main() {
  runApp(const App());
}

enum BreadType { white, wheat, wholemeal }

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sandwich Shop App',
      home: OrderScreen(),
    );
  }
}

class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
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

  List<DropdownMenuEntry<BreadType>> _buildDropdownEntries() {
    List<DropdownMenuEntry<BreadType>> entries = [];
    for (BreadType bread in BreadType.values) {
      entries.add(
        DropdownMenuEntry<BreadType>(
          value: bread,
          label: bread.name,
        ),
      );
    }
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    String sandwichType = _isFootlong ? 'footlong' : 'six-inch';
    String noteForDisplay = _notesController.text.isEmpty
        ? 'No notes added.'
        : _notesController.text;

    return Scaffold(
      appBar: AppBar(
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
              isToasted: _isToasted,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('six-inch', style: normalText),
                Switch(
                  key: const Key('sandwich_type_switch'),
                  value: _isFootlong,
                  onChanged: _onSandwichTypeChanged,
                ),
                const Text('footlong', style: normalText),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('untoasted', style: normalText),
                Switch(
                  key: const Key('toasted_switch'),
                  value: _isToasted,
                  onChanged: (value) {
                    setState(() => _isToasted = value);
                  },
                ),
                const Text('toasted', style: normalText),
              ],
            ),
            const SizedBox(height: 10),
            DropdownMenu<BreadType>(
              textStyle: normalText,
              initialSelection: _selectedBreadType,
              onSelected: _onBreadTypeSelected,
              dropdownMenuEntries: _buildDropdownEntries(),
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
                  onPressed: _getIncreaseCallback(),
                  icon: Icons.add,
                  label: 'Add',
                  color: Colors.green,
                ),
                const SizedBox(width: 8),
                StyledButton(
                  onPressed: _getDecreaseCallback(),
                  icon: Icons.remove,
                  label: 'Remove',
                  color: Colors.red,
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
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const StyledButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed == null ? Colors.grey : color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;
  final BreadType breadType;
  final String orderNote;
  final bool isToasted;

  const OrderItemDisplay({
    super.key,
    required this.quantity,
    required this.itemType,
    required this.breadType,
    required this.orderNote,
    required this.isToasted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$quantity $itemType sandwich(es): ${'🥪' * quantity}',
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          'Bread: ${breadType.name}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Text(
          'Toasted: ${isToasted ? 'Yes' : 'No'}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Text(
          'Note: $orderNote',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
