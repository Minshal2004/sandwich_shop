import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('Removing an item updates the UI correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Initially cart is empty
    expect(find.text('Total items: 0'), findsOneWidget);

    // Increase quantity from 1 to 2
    final Finder quantityIncrease = find.byIcon(Icons.add);
    expect(quantityIncrease, findsOneWidget);
    await tester.tap(quantityIncrease);
    await tester.pump();

    // Add to cart (adds 2 items)
    await tester.tap(find.text('Add to Cart'));
    await tester.pumpAndSettle();

    // Verify cart updated
    expect(find.text('Total items: 2'), findsOneWidget);

    // The default sandwich name produced by the app code
    const String itemName = 'Footlong veggieDelight on white bread';
    expect(find.text(itemName), findsOneWidget);

    // Find the ListTile for that cart item and its remove (decrement) button
    final Finder listTileFinder = find.widgetWithText(ListTile, itemName);
    final Finder removeButton = find.descendant(
      of: listTileFinder,
      matching: find.byIcon(Icons.remove),
    );
    expect(removeButton, findsOneWidget);

    // Tap the remove button to decrement quantity by one
    await tester.tap(removeButton);
    await tester.pumpAndSettle();

    // Verify totals updated from 2 -> 1
    expect(find.text('Total items: 1'), findsOneWidget);

    // Item row should still exist (aggregated count decreased)
    expect(find.text(itemName), findsOneWidget);
  });
}
