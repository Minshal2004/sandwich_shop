import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('Counter increments test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const App());

    // Verify that the counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that the counter increments to 1.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);

    // Tap the '+' icon again and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that the counter increments to 2.
    expect(find.text('1'), findsNothing);
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('Counter decrements test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const App());

    // Tap the '+' icon twice to increment the counter to 2.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that the counter is at 2.
    expect(find.text('2'), findsOneWidget);

    // Tap the '-' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();

    // Verify that the counter decrements to 1.
    expect(find.text('2'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}