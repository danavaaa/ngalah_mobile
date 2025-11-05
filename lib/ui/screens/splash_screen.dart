import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ngalah_mobile/main.dart';

class SplashScreen extends StatefulWidget {
  // Splash Screen
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // inisialisasi state
    super.initState(); // panggil inisialisasi state dari superclass
    Timer(const Duration(seconds: 2), () {
      // tunggu selama 2 detik
      Navigator.pushReplacement(
        // ganti layar saat ini dengan layar utama
        context, // konteks saat ini
        MaterialPageRoute(
          builder: (context) => const MainNavigation(),
        ), // layar utama
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // bangun tampilan
    final green = const Color(0xFF0C4E1A); // warna hijau khas
    return Scaffold(
      // tampilan dasar
      backgroundColor: Colors.white, // warna latar belakang putih
      body: Center(
        // isi halaman di tengah
        child: Column(
          mainAxisSize: MainAxisSize.min, // ukuran utama kolom minimal
          children: [
            Image.asset(
              'assets/images/logo_ngalah.png',
              width: 140,
            ), // logo aplikasi
            const SizedBox(height: 16), // jarak vertikal
            Text(
              // judul aplikasi
              'Ngalah Mobile',
              style: TextStyle(
                // gaya teks
                fontSize: 28, // ukuran font 28
                fontWeight: FontWeight.w700,
                color: green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
