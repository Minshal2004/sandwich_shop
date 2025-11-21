import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('Quantity increments and decrements correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Initially quantity is 0
    expect(find.byKey(const Key('quantity_display')), findsOneWidget);
    expect(find.textContaining('0 footlong sandwich'), findsOneWidget);

    final Finder addButton = find.widgetWithIcon(ElevatedButton, Icons.add);
    final Finder removeButton =
        find.widgetWithIcon(ElevatedButton, Icons.remove);

    // Increment quantity
    await tester.ensureVisible(addButton);
    await tester.tap(addButton);
    await tester.pump();

    expect(find.textContaining('1 footlong sandwich'), findsOneWidget);

    // Increment again
    await tester.tap(addButton);
    await tester.pump();
    expect(find.textContaining('2 footlong sandwich'), findsOneWidget);

    // Decrement
    await tester.tap(removeButton);
    await tester.pump();
    expect(find.textContaining('1 footlong sandwich'), findsOneWidget);
  });

  testWidgets('Switch toggles between six-inch and footlong',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    final Finder sandwichSwitch = find.byKey(const Key('sandwich_type_switch'));
    expect(sandwichSwitch, findsOneWidget);

    // Initial type is footlong
    expect(find.textContaining('footlong sandwich'), findsOneWidget);

    // Toggle switch
    await tester.tap(sandwichSwitch);
    await tester.pump();

    expect(find.textContaining('six-inch sandwich'), findsOneWidget);
    expect(find.textContaining('footlong sandwich'), findsNothing);

    // Toggle back
    await tester.tap(sandwichSwitch);
    await tester.pump();
    expect(find.textContaining('footlong sandwich'), findsOneWidget);
  });

  testWidgets('Toasted switch toggles correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    final Finder toastedSwitch = find.byKey(const Key('toasted_switch'));
    expect(toastedSwitch, findsOneWidget);

    // Initially No
    expect(find.textContaining('Toasted: No'), findsOneWidget);

    // Toggle
    await tester.tap(toastedSwitch);
    await tester.pump();
    expect(find.textContaining('Toasted: Yes'), findsOneWidget);

    // Toggle back
    await tester.tap(toastedSwitch);
    await tester.pump();
    expect(find.textContaining('Toasted: No'), findsOneWidget);
  });

  testWidgets('Total price updates correctly with quantity and type',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    final Finder addButton = find.widgetWithIcon(ElevatedButton, Icons.add);
    final Finder sandwichSwitch = find.byKey(const Key('sandwich_type_switch'));
    final Finder totalPrice = find.byKey(const Key('total_price_display'));

    // Initially 0 sandwiches, price £0.00
    expect(find.text('Total Price: £0.00'), findsOneWidget);

    // Add one footlong sandwich (footlong = £11)
    await tester.ensureVisible(addButton);
    await tester.tap(addButton);
    await tester.pump();
    expect(find.text('Total Price: £11.00'), findsOneWidget);

    // Add another
    await tester.tap(addButton);
    await tester.pump();
    expect(find.text('Total Price: £22.00'), findsOneWidget);

    // Switch to six-inch (6-inch = £7 each), total = 2*7 = £14
    await tester.tap(sandwichSwitch);
    await tester.pump();
    expect(find.text('Total Price: £14.00'), findsOneWidget);

    // Add one more six-inch sandwich, total = 3*7 = £21
    await tester.tap(addButton);
    await tester.pump();
    expect(find.text('Total Price: £21.00'), findsOneWidget);
  });
}
