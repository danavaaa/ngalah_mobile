import 'dart:async';
import 'package:flutter/material.dart';
import 'sisda_dashboard_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final String _dummyOtp = "123456";

  bool _isLoading = false;
  int _timerCount = 60;
  late Timer _timer;

  String? _otpErrorText; // <-- error message state

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerCount > 0) {
        setState(() => _timerCount--);
      } else {
        timer.cancel();
      }
    });
  }

  void _resendOtp() {
    setState(() => _timerCount = 60);
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kode OTP telah dikirim ulang.')),
    );
  }

  void _verifyOtp() async {
    if (_otpController.text.isEmpty) {
      setState(() {
        _otpErrorText = "Isikan kode OTP terlebih dahulu";
      });
      return;
    }

    // HILANGKAN ERROR SAAT USER SUDAH MENGISI OTP
    setState(() {
      _otpErrorText = null;
    });

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    if (_otpController.text.trim() == _dummyOtp) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SisdaDashboardScreen()),
      );
    } else {
      _otpController.clear();
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text("OTP Salah"),
              content: const Text("Kode OTP yang kamu masukkan tidak valid."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Coba Lagi"),
                ),
              ],
            ),
      );
    }

    setState(() => _isLoading = false);
  }

  // ============================
  //             UI
  // ============================
  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF0C4E1A);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: green,
        title: const Text('SISDA'),
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
            children: [
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

              // ============================
              //         CARD OTP
              // ============================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9EED9),
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

                    // ============================
                    //        INPUT OTP
                    // ============================
                    TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (_) {
                        if (_otpErrorText != null) {
                          setState(() => _otpErrorText = null);
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Color(0xFF0C4E1A),
                        ),
                        hintText: "Masukkan kode OTP",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    // ============================
                    //       ERROR TEXT
                    // ============================
                    if (_otpErrorText != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        _otpErrorText!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // ============================
                    //       KIRIM ULANG
                    // ============================
                    ElevatedButton(
                      onPressed: _timerCount == 0 ? _resendOtp : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[700],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _timerCount > 0
                            ? 'Kirim Ulang ($_timerCount)'
                            : 'Kirim Ulang',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // ============================
                    //     BUTTONS BAWAH
                    // ============================
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Ganti Nomor",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _verifyOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: green,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child:
                                _isLoading
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    )
                                    : const Text(
                                      "Verifikasi",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),
                        ),
                      ],
                    ),
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
