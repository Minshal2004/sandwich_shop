import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    // Verify that our counter starts at 0 by checking the OrderItemDisplay text.
    expect(find.textContaining('0 Footlong'), findsOneWidget);
    expect(find.textContaining('1 Footlong'), findsNothing);

    // Tap the 'Add' button and trigger a frame.
    await tester.tap(find.text('Add'));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.textContaining('0 Footlong'), findsNothing);
    expect(find.textContaining('1 Footlong'), findsOneWidget);
  });

  // This test verifies the functionality of the Switch widget that toggles between 'six-inch' and 'footlong'.
  // Switch widgets are toggled by tapping on them like buttons.
  testWidgets('Switch toggles between six-inch and footlong',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Find the Switch widget by key
    final switchFinder = find.byKey(const Key('sandwichTypeSwitch'));

    // Initially, OrderItemDisplay should show 'footlong'
    expect(find.textContaining('footlong'), findsOneWidget);
    expect(find.textContaining('six-inch'), findsNothing);

    // Tap the Switch to toggle to 'six-inch'
    await tester.tap(switchFinder);
    await tester.pump();

    // Now, OrderItemDisplay should show 'six-inch'
    expect(find.textContaining('six-inch'), findsOneWidget);
    expect(find.textContaining('footlong'), findsNothing);

    // Tap again to toggle back to 'footlong'
    await tester.tap(switchFinder);
    await tester.pump();

    // Should show 'footlong' again
    expect(find.textContaining('footlong'), findsOneWidget);
    expect(find.textContaining('six-inch'), findsNothing);
  });
}
