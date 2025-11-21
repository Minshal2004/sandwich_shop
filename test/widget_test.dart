import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('Counter increments test', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('1'), findsNothing);
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('Counter decrements test', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();

    expect(find.text('2'), findsNothing);
    expect(find.text('1'), findsOneWidget);
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

    expect(find.text('Toasted: No'), findsOneWidget);

    await tester.tap(find.byKey(const Key('toasted_switch')));
    await tester.pump();

    expect(find.text('Toasted: Yes'), findsOneWidget);

    await tester.tap(find.byKey(const Key('toasted_switch')));
    await tester.pump();

    expect(find.text('Toasted: No'), findsOneWidget);
  });
}
