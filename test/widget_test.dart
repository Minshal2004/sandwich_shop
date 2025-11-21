import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('Quantity increments correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    expect(find.textContaining('0'), findsOneWidget);
    expect(find.textContaining('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.textContaining('0'), findsNothing);
    expect(find.textContaining('1'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.textContaining('1'), findsNothing);
    expect(find.textContaining('2'), findsOneWidget);
  });

  testWidgets('Quantity decrements correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.textContaining('2'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();

    expect(find.textContaining('2'), findsNothing);
    expect(find.textContaining('1'), findsOneWidget);
  });

  testWidgets('Switch toggles between six-inch and footlong',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    expect(find.text('footlong'), findsOneWidget);
    expect(find.text('six-inch'), findsOneWidget);

    await tester.tap(find.byKey(const Key('sandwich_type_switch')));
    await tester.pump();

    expect(find.text('six-inch'), findsOneWidget);
    expect(find.text('footlong'), findsNothing);

    await tester.tap(find.byKey(const Key('sandwich_type_switch')));
    await tester.pump();

    expect(find.text('footlong'), findsOneWidget);
    expect(find.text('six-inch'), findsOneWidget);
  });

  testWidgets('Toasted switch toggles between toasted and untoasted',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    expect(find.textContaining('Toasted: No'), findsOneWidget);

    await tester.tap(find.byKey(const Key('toasted_switch')));
    await tester.pump();

    expect(find.textContaining('Toasted: Yes'), findsOneWidget);

    await tester.tap(find.byKey(const Key('toasted_switch')));
    await tester.pump();

    expect(find.textContaining('Toasted: No'), findsOneWidget);
  });

  testWidgets('Total price updates correctly with quantity and type',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Initial price should be for 0 footlongs
    expect(find.textContaining('Total Price: £11.00'), findsOneWidget);

    // Tap Add (+)
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Now 1 footlong → £11
    expect(find.textContaining('Total Price: £11.00'), findsOneWidget);

    // Tap Add (+) again → 2 footlongs → £22
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.textContaining('Total Price: £22.00'), findsOneWidget);

    // Toggle to six-inch → price should change
    await tester.tap(find.byKey(const Key('sandwich_type_switch')));
    await tester.pump();

    // 2 six-inch sandwiches → 2 * £7 = £14
    expect(find.textContaining('Total Price: £14.00'), findsOneWidget);
  });
}
