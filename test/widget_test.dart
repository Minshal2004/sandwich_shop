import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('Counter increments when Add button is tapped',
      (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const App());

    // Initial state: quantity 0
    expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
    expect(find.text('1 white footlong sandwich(es): 🥪'), findsNothing);

    // Tap the Add button
    final addButton = find.byKey(const Key('addButton'));
    expect(addButton, findsOneWidget);
    await tester.tap(addButton);
    await tester.pump();

    // Verify counter increment
    expect(find.text('0 white footlong sandwich(es): '), findsNothing);
    expect(find.text('1 white footlong sandwich(es): 🥪'), findsOneWidget);
  });

  testWidgets('Switch toggles between six-inch and footlong',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    final switchFinder = find.byKey(const Key('sandwichTypeSwitch'));
    expect(switchFinder, findsOneWidget);

    // Initial state: OrderItemDisplay shows footlong
    expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
    expect(find.text('0 white six-inch sandwich(es): '), findsNothing);

    // Toggle to six-inch
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    expect(find.text('0 white six-inch sandwich(es): '), findsOneWidget);
    expect(find.text('0 white footlong sandwich(es): '), findsNothing);

    // Toggle back to footlong
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
    expect(find.text('0 white six-inch sandwich(es): '), findsNothing);
  });
}
