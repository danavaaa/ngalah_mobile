import 'package:flutter/material.dart';

class PpdbScreen extends StatelessWidget {
  // PPDB Screen
  const PpdbScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF0C4E1A); // warna hijau khas
    return Scaffold(
      // tampilan dasar
      appBar: AppBar(
        // bilah aplikasi
        title: const Text(
          // Judul bilah aplikasi
          'PPDB',
          style: TextStyle(fontWeight: FontWeight.bold), // gaya teks tebal
        ),
        backgroundColor: green,
        foregroundColor: Colors.white, // warna teks dan ikon putih
      ),
      body: const Center(
        // isi halaman
        child: Text(
          'Halaman PPDB',
          style: TextStyle(fontSize: 20),
        ), // teks di tengah halaman
      ),
    );
  }
}
