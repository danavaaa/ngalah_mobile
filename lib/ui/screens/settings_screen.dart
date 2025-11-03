import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF0C4E1A);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: green,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Halaman Pengaturan', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
