import 'package:flutter/material.dart';

/// Lightweight navigation drawer used by screens.
/// Uses named routes: '/order', '/cart', '/profile', '/about'.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Widget _item(BuildContext context, String id, IconData icon, String label,
      String routeName) {
    final ModalRoute<Object?>? route = ModalRoute.of(context);
    final bool selected = route?.settings.name == routeName;
    return ListTile(
      leading: Icon(icon,
          color: selected ? Theme.of(context).colorScheme.primary : null),
      title: Text(label),
      selected: selected,
      onTap: () {
        Navigator.of(context).maybePop(); // close drawer if open
        if (selected) return;
        Navigator.of(context).pushReplacementNamed(routeName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer),
            child: const Text('Navigation', style: TextStyle(fontSize: 20)),
          ),
          _item(context, 'order', Icons.home, 'Order', '/order'),
          _item(context, 'cart', Icons.shopping_cart, 'Cart', '/cart'),
          _item(context, 'profile', Icons.person, 'Profile', '/profile'),
          _item(context, 'about', Icons.info, 'About', '/about'),
        ],
      ),
    );
  }
}
