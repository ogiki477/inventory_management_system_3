import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Page'),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 20,
      ),
      body: const Card(
        margin: EdgeInsets.all(30),
        elevation: 20,
        child: Text("Coming Soon!!"),
      ),
    );
  }
}
