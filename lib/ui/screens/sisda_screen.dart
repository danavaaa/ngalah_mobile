import 'package:flutter/material.dart';

class SisdaScreen extends StatelessWidget {
  const SisdaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF0C4E1A);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sisda'),
        backgroundColor: green,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Halaman Sisda', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
