import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  // Settings Screen
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // tampilan dasar
    final green = const Color(0xFF0C4E1A); // warna hijau khas

    return Scaffold(
      // tampilan dasar
      appBar: AppBar(
        // bilah aplikasi
        title: const Text(
          // Judul bilah aplikasi
          'Pengaturan',
          style: TextStyle(fontWeight: FontWeight.bold), // gaya teks tebal
        ),
        backgroundColor: green, // warna latar belakang hijau
        foregroundColor: Colors.white, // warna teks dan ikon putih
      ),
      body: const Center(
        // isi halaman
        child: Text(
          'Halaman Pengaturan',
          style: TextStyle(fontSize: 20),
        ), // teks di tengah halaman
      ),
    );
  }
}
