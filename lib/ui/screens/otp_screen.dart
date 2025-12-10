import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/sisda_provider.dart';

// Layar untuk memasukkan kode OTP yang dikirim via WhatsApp
class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

// State untuk OtpScreen
class _OtpScreenState extends State<OtpScreen> {
  static const Color green = Color(0xFF0C4E1A);
  // Controller untuk input OTP
  final TextEditingController _otpController = TextEditingController();

  bool _sending = false; // apakah sedang mengirim OTP
  bool _verifying = false; // apakah sedang memverifikasi OTP

  Timer? _timer; // timer untuk countdown
  int _secondsLeft = 60; // detik tersisa untuk kirim ulang OTP

  String? _inlineError; // pesan error inline
  bool _autoSent = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    // Kirim OTP otomatis saat layar muncul
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_autoSent) return;
      _autoSent = true;
      await _sendOtp(silent: true);
    });
    // Hapus pesan error saat user mulai mengetik ulang OTP
    _otpController.addListener(() {
      if (_inlineError != null && mounted) {
        setState(() => _inlineError = null);
      }
    });
  }

  void _startCountdown() {
    // Mulai countdown untuk kirim ulang OTP
    _timer?.cancel();
    _secondsLeft = 60; //   reset ke 60 detik

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      // setiap detik
      if (!mounted) return;
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() => _secondsLeft = 0); // selesai
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });

    if (mounted) setState(() {});
  }

  // Masking nomor telepon untuk ditampilkan
  String _maskedPhone(String phone) {
    final p = phone.trim();
    if (p.length < 6) return p;
    final start = p.substring(0, 2);
    final end = p.substring(p.length - 2);
    return "$start********$end";
  }

  // Tampilkan snackbar di atas
  void _showTopSnack(String message, {required bool success}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              success ? Icons.check_circle : Icons.error,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: success ? green : Colors.redAccent,
        margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  //   Kirim ulang OTP
  Future<void> _sendOtp({required bool silent}) async {
    if (_sending) return;

    setState(() {
      _sending = true;
      if (!silent) _inlineError = null;
    });
    // Kirim OTP via SisdaProvider
    final ok = await context.read<SisdaProvider>().sendWaOtp();
    if (!mounted) return;

    if (ok) {
      _startCountdown();
      if (!silent) {
        _showTopSnack("Kode OTP telah dikirim ulang.", success: true);
      }
    } else {
      final err = context.read<SisdaProvider>().error ?? "Gagal kirim OTP";
      if (silent) {
        setState(() => _inlineError = err);
      } else {
        _showTopSnack(err, success: false);
      }
    }

    if (mounted) setState(() => _sending = false);
  }

  // Verifikasi kode OTP yang dimasukkan
  Future<void> _verify() async {
    if (_verifying) return;

    final input = _otpController.text.trim(); //  ambil input OTP
    if (input.isEmpty) {
      //  jika kosong
      setState(() => _inlineError = "Isikan kode OTP terlebih dahulu");
      return;
    }

    setState(() {
      _verifying = true;
      _inlineError = null;
    });
    // Verifikasi OTP via SisdaProvider
    final sisda = context.read<SisdaProvider>();
    final ok = sisda.verifyOtpLocal(input);

    if (!mounted) return;

    if (ok) {
      sisda.markOtpSuccess();
      Navigator.pop(context);
      _showTopSnack("Verifikasi berhasil.", success: true);
    } else {
      setState(() => _inlineError = "OTP salah");
    }

    if (mounted) setState(() => _verifying = false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  // UI
  @override
  Widget build(BuildContext context) {
    final sisda = context.watch<SisdaProvider>();
    final phone = (sisda.user?.telepon ?? widget.phoneNumber).trim();
    final masked = _maskedPhone(phone);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: green,
        foregroundColor: Colors.white,
        title: const Text("SISDA"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 18),
              const Text(
                "SISDA",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: green,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Sistem Informasi Santri/Siswa\nYayasan Darut Taqwa",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: green,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 22),

              // CARD OTP
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 360),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 26,
                ),
                decoration: BoxDecoration(
                  color: green.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Masukkan Kode OTP",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Masukkan kode OTP yang telah dikirim ke nomor\n$masked",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Input OTP
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.person, color: green),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _otpController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                hintText: "Masukkan kode OTP",
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 34),
                        ],
                      ),
                    ),

                    if (_inlineError != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        _inlineError!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),

                    // Kirim ulang
                    SizedBox(
                      width: 190,
                      child: ElevatedButton(
                        onPressed:
                            (_secondsLeft == 0 && !_sending)
                                ? () => _sendOtp(silent: false)
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB3A100),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(
                            0xFFB3A100,
                          ).withOpacity(0.6),
                          disabledForegroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          _sending
                              ? "Mengirim..."
                              : (_secondsLeft == 0
                                  ? "Kirim Ulang"
                                  : "Kirim Ulang ($_secondsLeft)"),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),
                    // Tombol Ganti Nomor & Verifikasi
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF4D4D),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Ganti Nomor",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _verifying ? null : _verify,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: green,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: green.withOpacity(0.6),
                              disabledForegroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child:
                                _verifying
                                    ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                    : const Text(
                                      "Verifikasi",
                                      style: TextStyle(
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

              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
