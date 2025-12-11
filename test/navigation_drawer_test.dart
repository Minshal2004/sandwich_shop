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

    // Use non-const App() since App has a non-const constructor now.
    await tester.pumpWidget(App());
    await tester.pumpAndSettle();

    // Locate menu button robustly: try icon first, then tooltip.
    Finder menuButton = find.byIcon(Icons.menu);
    if (!tester.any(menuButton)) {
      menuButton = find.byTooltip('Open navigation menu');
    }

    if (tester.any(menuButton)) {
      // If a visible menu button exists, tap it.
      await tester.tap(menuButton);
      await tester.pumpAndSettle();
    } else {
      // Fallback: open the drawer programmatically via the ScaffoldState.
      final Finder scaffoldFinder = find.byType(Scaffold).first;
      final ScaffoldState scaffoldState =
          tester.state<ScaffoldState>(scaffoldFinder);
      scaffoldState.openDrawer();
      await tester.pumpAndSettle();
    }

    // Drawer should show Cart item
    expect(find.text('Cart'), findsOneWidget);

    // Tap Cart and verify navigation to CartScreen
    await tester.tap(find.text('Cart'));
    await tester.pumpAndSettle();

    expect(find.text('Cart Screen'), findsOneWidget);
  });
}
