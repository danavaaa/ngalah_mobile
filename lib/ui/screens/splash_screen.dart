import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ngalah_mobile/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigation()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF0C4E1A);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo_ngalah.png', width: 140),
            const SizedBox(height: 16),
            Text(
              'Ngalah Mobile',
              style: TextStyle(
                fontSize: 28,
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
