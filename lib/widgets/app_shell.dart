import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/about_screen.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/views/profile_screen.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final String current; // 'order', 'cart', 'about', 'profile'
  final String title;

  const AppShell({
    super.key,
    required this.child,
    required this.current,
    required this.title,
  });

  Widget _drawerContents(BuildContext context) {
    Widget item(String id, IconData icon, String label, Widget destination) {
      final selected = id == current;
      return ListTile(
        leading: Icon(icon,
            color: selected ? Theme.of(context).colorScheme.primary : null),
        title: Text(label),
        selected: selected,
        onTap: () {
          Navigator.of(context).pop(); // close drawer on narrow screens
          if (id == current) return;
          // Navigate to destination; use pushReplacement to avoid stacking duplicates
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => destination),
          );
        },
      );
    }

    return ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer),
          child: const Text('Navigation', style: TextStyle(fontSize: 20)),
        ),
        item(
            'order',
            Icons.home,
            'Order',
            Navigator.of(context).widget is WidgetsBinding
                ? Navigator.of(context).widget
                : const SizedBox()),
        item('cart', Icons.shopping_cart, 'Cart', const CartScreen()),
        item('profile', Icons.person, 'Profile', const ProfileScreen()),
        item('about', Icons.info, 'About', const AboutScreen()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const breakpoint = 700.0;
    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth >= breakpoint;
      if (isWide) {
        // Persistent sidebar + content
        return Scaffold(
          appBar: AppBar(title: Text(title)),
          body: Row(
            children: [
              Container(
                width: 250,
                color: Theme.of(context).drawerTheme.backgroundColor ??
                    Theme.of(context).colorScheme.surfaceVariant,
                child: _drawerContents(context),
              ),
              Expanded(child: child),
            ],
          ),
        );
      } else {
        // Drawer overlay behavior
        return Scaffold(
          appBar: AppBar(title: Text(title)),
          drawer: Drawer(child: _drawerContents(context)),
          body: child,
        );
      }
    });
  }
}
