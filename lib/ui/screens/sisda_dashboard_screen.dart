import 'package:flutter/material.dart';

class SisdaDashboardScreen extends StatelessWidget {
  const SisdaDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dashboard Screen
    final green = const Color(0xFF0C4E1A); // Define green color

    return Scaffold(
      appBar: AppBar(
        backgroundColor: green, // warna hijau
        title: const Text(
          // judul appbar
          "Dashboard Sisda",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ), // gaya teks
        ),
        centerTitle: true, // judul di tengah
      ),
      backgroundColor: Colors.white, // warna latar belakang putih
      body: Padding(
        padding: const EdgeInsets.all(20.0), // padding di sekitar konten
        child: Column(
          // kolom untuk menata widget secara vertikal
          crossAxisAlignment: CrossAxisAlignment.start, // rata kiri
          children: [
            const Text(
              // teks selamat datang
              "Selamat Datang di SISDA ",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0C4E1A),
              ),
            ),
            const SizedBox(height: 10), // jarak vertikal
            const Text(
              // teks deskripsi
              "Ini adalah dashboard sederhana.",
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
            const SizedBox(height: 30), // jarak vertikal
          ],
        ),
      ),
    );
  }
}
