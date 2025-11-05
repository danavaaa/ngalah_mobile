import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  // tema aplikasi
  useMaterial3: true,
  primaryColor: const Color(0xFF0C4E1A), // warna hijau utama
  scaffoldBackgroundColor: Colors.white, // warna latar belakang
  fontFamily: 'Poppins', // font default
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF0C4E1A),
  ), // skema warna berdasarkan warna utama
);
