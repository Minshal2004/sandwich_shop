import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('Quantity increments correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    final quantityFinder = find.byKey(const Key('quantity_display'));

    expect(quantityFinder, findsOneWidget);
    expect(find.text('0 footlong sandwich(es): '), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('1 footlong sandwich(es): '), findsOneWidget);
  });

  testWidgets('Quantity decrements correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('2 footlong sandwich(es): '), findsOneWidget);

    await tester.tap(find.byIcon(Icons.remove));
    await tester.pumpAndSettle();

    expect(find.text('1 footlong sandwich(es): '), findsOneWidget);
  });

  testWidgets('Switch toggles between six-inch and footlong',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.text('footlong'), findsOneWidget);

    await tester.tap(find.byKey(const Key('sandwich_type_switch')));
    await tester.pumpAndSettle();

    expect(find.text('six-inch'), findsOneWidget);

    await tester.tap(find.byKey(const Key('sandwich_type_switch')));
    await tester.pumpAndSettle();

    expect(find.text('footlong'), findsOneWidget);
  });

  testWidgets('Toasted switch toggles between toasted and untoasted',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.textContaining('Toasted: No'), findsOneWidget);

    await tester.tap(find.byKey(const Key('toasted_switch')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Toasted: Yes'), findsOneWidget);
  });

  testWidgets('Total price updates correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Tap Add to increment quantity
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.textContaining('Total Price: £11.00'), findsOneWidget);

    // Tap Add again → 2 footlongs → £22
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.textContaining('Total Price: £22.00'), findsOneWidget);

    // Toggle to six-inch → price should update 2 * £7 = £14
    await tester.tap(find.byKey(const Key('sandwich_type_switch')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Total Price: £14.00'), findsOneWidget);
  });
}
