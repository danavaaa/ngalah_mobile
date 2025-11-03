import 'package:flutter/material.dart';

class PpdbScreen extends StatelessWidget {
  const PpdbScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF0C4E1A);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PPDB',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: green,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Halaman PPDB', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
