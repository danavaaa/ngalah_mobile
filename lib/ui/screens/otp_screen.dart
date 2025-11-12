import 'dart:async';
import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber; // nomor WA dari halaman login

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController =
      TextEditingController(); // kontrol input OTP
  int _timerCount = 60; // waktu hitung mundur
  late Timer _timer; // timer

  @override
  void initState() {
    super.initState();
    _startTimer(); // mulai timer saat layar dibuka
  }

  @override
  void dispose() {
    _timer.cancel(); // hentikan timer saat keluar
    _otpController.dispose(); // bersihkan controller
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerCount > 0) {
        setState(() => _timerCount--); // kurangi tiap detik
      } else {
        timer.cancel(); // stop timer
      }
    });
  }

  // === UI CARD LOGIN SAJA ===
  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF0C4E1A); // warna hijau khas

    return Scaffold(
      backgroundColor: Colors.white, // warna latar
      appBar: AppBar(
        backgroundColor: green,
        title: const Text('SISDA'),
        centerTitle: false,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // === Judul Aplikasi ===
              const Text(
                'SISDA',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0C4E1A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sistem Informasi Santri/Siswa\nYayasan Darut Taqwa',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0C4E1A),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),

              // === CARD LOGIN ===
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9EED9), // hijau muda
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Masukkan Kode OTP',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Masukkan kode OTP yang telah dikirim ke nomor\n${widget.phoneNumber.replaceRange(2, 10, "********")}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),

                    // === INPUT FIELD ===
                    TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Color(0xFF0C4E1A),
                        ),
                        hintText: "Masukkan kode OTP",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
