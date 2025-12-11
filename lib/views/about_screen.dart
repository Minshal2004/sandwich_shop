import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/widgets/app_shell.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About', style: heading1)),
      drawer: const AppDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: const [
              Text('About', style: heading1),
              SizedBox(height: 8),
              Text('Sandwich Shop app demo.'),
            ],
          ),
        ),
      ),
    );
  }
}
