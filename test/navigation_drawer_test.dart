import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('Drawer opens and navigates to Cart screen',
      (WidgetTester tester) async {
    // Force narrow viewport so AppBar shows the drawer hamburger icon.
    final binding = tester.binding;
    binding.window.physicalSizeTestValue = const Size(400, 800);
    binding.window.devicePixelRatioTestValue = 1.0;

    addTearDown(() {
      binding.window.clearPhysicalSizeTestValue();
      binding.window.clearDevicePixelRatioTestValue();
    });

    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Open drawer via the AppBar's standard tooltip (works across locales/themes).
    final Finder menuButton = find.byTooltip('Open navigation menu');
    expect(menuButton, findsOneWidget);
    await tester.tap(menuButton);
    await tester.pumpAndSettle();

    // Drawer should show Cart item
    expect(find.text('Cart'), findsOneWidget);

    // Tap Cart and verify navigation to CartScreen
    await tester.tap(find.text('Cart'));
    await tester.pumpAndSettle();

    expect(find.text('Cart Screen'), findsOneWidget);
  });
}
