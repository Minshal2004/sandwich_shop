import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

Future<void> scrollIntoView(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Quantity increases when + is tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    final plusButton = find.byIcon(Icons.add);

    await scrollIntoView(tester, plusButton);

    // Default quantity is 1
    expect(find.text('1'), findsOneWidget);

    await tester.tap(plusButton);
    await tester.pumpAndSettle();

    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('Quantity decreases when - is tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    final minusButton = find.byIcon(Icons.remove);
    final plusButton = find.byIcon(Icons.add);

    await scrollIntoView(tester, plusButton);
    await tester.tap(plusButton); // increment so we don’t hit 0
    await tester.pumpAndSettle();

    await scrollIntoView(tester, minusButton);
    await tester.tap(minusButton);
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Switch toggles between six-inch and footlong',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    final switchFinder = find.byType(Switch);

    await scrollIntoView(tester, switchFinder);

    // Initial state: ON (footlong)
    Switch s = tester.widget(switchFinder);
    expect(s.value, true);

    // Tap to toggle OFF (six-inch)
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    s = tester.widget(switchFinder);
    expect(s.value, false);

    // Toggle back ON
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    s = tester.widget(switchFinder);
    expect(s.value, true);
  });

  testWidgets('Add to Cart updates summary and shows confirmation',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    final addButton = find.text('Add to Cart');

    await scrollIntoView(tester, addButton);
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // Check confirmation message exists
    expect(find.textContaining('Added'), findsOneWidget);

    // Cart summary should update
    expect(find.textContaining('Total items: 1'), findsOneWidget);

    // Add again
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    expect(find.textContaining('Total items: 2'), findsOneWidget);
  });
}
