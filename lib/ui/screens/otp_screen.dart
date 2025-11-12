import 'dart:async'; // Untuk Timer
import 'package:flutter/material.dart'; // Flutter framework
import 'sisda_dashboard_screen.dart'; // Impor layar dashboard Sisda

class OtpScreen extends StatefulWidget {
  // Layar OTP
  final String phoneNumber; // Nomor telepon pengguna

  const OtpScreen({super.key, required this.phoneNumber}); // Konstruktor

  @override
  State<OtpScreen> createState() => _OtpScreenState(); // Buat state layar OTP
}

class _OtpScreenState extends State<OtpScreen> {
  // State layar OTP
  final TextEditingController _otpController =
      TextEditingController(); // Kontroler input OTP
  final String _dummyOtp = "123456"; // OTP dummy untuk verifikasi
  bool _isLoading = false; // Status loading
  int _timerCount = 60; // Hitung mundur timer
  late Timer _timer; // Timer untuk hitung mundur

  @override
  void initState() {
    // Inisialisasi state
    super.initState(); // Panggil inisialisasi state superclass
    _startTimer(); // Mulai timer
  }

  @override
  void dispose() {
    // Dispose state
    _timer.cancel(); // Batalkan timer
    _otpController.dispose(); // Dispose kontroler OTP
    super.dispose(); // Panggil dispose superclass
  }

  void _startTimer() {
    // Mulai timer hitung mundur
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Setiap detik
      if (_timerCount > 0) {
        // Jika hitung mundur belum selesai
        setState(() => _timerCount--); // Kurangi hitung mundur
      } else {
        // Jika hitung mundur selesai
        timer.cancel(); // Batalkan timer
      }
    });
  }

  void _resendOtp() {
    // Kirim ulang OTP
    setState(() => _timerCount = 60); // Reset hitung mundur
    _startTimer(); // Mulai ulang timer
    ScaffoldMessenger.of(context).showSnackBar(
      // Tampilkan snackbar
      const SnackBar(
        content: Text('Kode OTP telah dikirim ulang.'),
      ), // Pesan snackbar
    );
  }

  void _verifyOtp() async {
    // Verifikasi OTP
    if (_otpController.text.isEmpty) {
      // Jika input OTP kosong
      ScaffoldMessenger.of(context).showSnackBar(
        // Tampilkan snackbar
        const SnackBar(
          content: Text('Masukkan kode OTP terlebih dahulu'),
        ), // Pesan snackbar
      );
      return; // Kembali
    }

    setState(() => _isLoading = true); // Set status loading
    await Future.delayed(
      const Duration(seconds: 1),
    ); // Simulasi delay verifikasi
    if (!mounted) return; // Cek apakah widget masih terpasang

    if (_otpController.text.trim() == _dummyOtp) {
      // Jika OTP benar
      Navigator.pushReplacement(
        // Navigasi ke layar dashboard Sisda
        context, // Konteks saat ini
        MaterialPageRoute(
          builder: (context) => const SisdaDashboardScreen(),
        ), // Layar dashboard Sisda
      );
    } else {
      // Jika OTP salah
      _otpController.clear(); // Bersihkan input OTP
      showDialog(
        // Tampilkan dialog kesalahan
        context: context, // Konteks saat ini
        builder: // Builder dialog
            (context) => AlertDialog(
              // Dialog alert
              title: const Text("OTP Salah"),
              content: const Text("Kode OTP yang kamu masukkan tidak valid."),
              actions: [
                // Aksi dialog
                TextButton(
                  // Tombol coba lagi
                  onPressed: () => Navigator.pop(context), // Tutup dialog
                  child: const Text("Coba Lagi"), // Teks tombol
                ),
              ],
            ),
      );
    }

    setState(() => _isLoading = false); // Set status loading selesai
  }

  // UI
  @override
  Widget build(BuildContext context) {
    // Bangun tampilan
    return Scaffold(
      // Tampilan dasar
      appBar: AppBar(title: const Text("Halaman OTP")), // Bilah aplikasi
      body: Center(
        // Isi halaman di tengah
        child: Column(
          // Kolom
          mainAxisAlignment: MainAxisAlignment.center, // Rata tengah
          children: [
            TextField(
              // Input OTP
              controller: _otpController, // Kontroler input OTP
              decoration: const InputDecoration(hintText: "Masukkan kode OTP"),
            ),
            const SizedBox(height: 16), // Jarak vertikal
            ElevatedButton(
              // Tombol verifikasi
              onPressed:
                  _isLoading
                      ? null
                      : _verifyOtp, // Nonaktifkan tombol saat loading
              child:
                  _isLoading
                      ? const CircularProgressIndicator(
                        color: Colors.white,
                      ) // Tampilkan indikator loading
                      : const Text("Verifikasi"), // Teks tombol
            ),
            const SizedBox(height: 8), // Jarak vertikal
            ElevatedButton(
              // Tombol kirim ulang OTP
              onPressed: _resendOtp, // Fungsi kirim ulang OTP
              child: Text(
                "Kirim Ulang ($_timerCount)",
              ), // Teks tombol dengan hitung mundur
            ),
          ],
        ),
      ),
    );
  }
}
