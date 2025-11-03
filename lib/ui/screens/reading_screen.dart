import 'package:flutter/material.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF0C4E1A);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bacaan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: green,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Halaman Bacaan', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
