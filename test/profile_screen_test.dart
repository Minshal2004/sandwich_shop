import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('Profile screen opens and shows form fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(App());
    await tester.pumpAndSettle();

    // Scroll until the Profile button is visible, then tap it.
    await tester.scrollUntilVisible(
      find.text('Profile'),
      500.0,
      scrollable: find.byType(SingleChildScrollView),
    );
    expect(find.text('Profile'), findsOneWidget);
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    // Verify form fields and save button are present
    expect(find.byKey(const Key('nameField')), findsOneWidget);
    expect(find.byKey(const Key('emailField')), findsOneWidget);
    expect(find.byKey(const Key('saveButton')), findsOneWidget);
  });
}
