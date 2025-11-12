import 'dart:async'; // untuk Timer
import 'package:flutter/material.dart'; //  untuk widget Flutter
import 'sisda_dashboard_screen.dart'; // impor layar dashboard SISDA

class OtpScreen extends StatefulWidget {
  final String phoneNumber; // nomor WA dari halaman login

  const OtpScreen({Key? key, required this.phoneNumber})
    : super(key: key); // konstruktor

  @override
  State<OtpScreen> createState() => _OtpScreenState(); // buat state
}

class _OtpScreenState extends State<OtpScreen> {
  // state layar OTP
  final TextEditingController _otpController =
      TextEditingController(); // kontroler input OTP
  final String _dummyOtp = "123456"; // OTP dummy
  bool _isLoading = false; // status loading
  int _timerCount = 60; //  waktu hitung mundur
  late Timer _timer; // timer

  @override
  void initState() {
    // inisialisasi state
    super.initState(); // panggil inisialisasi state superclass
    _startTimer(); // mulai timer
  }

  @override
  void dispose() {
    _timer.cancel(); // batalkan timer
    _otpController.dispose(); // bersihkan kontroler
    super.dispose(); // panggil dispose superclass
  }

  void _startTimer() {
    // mulai timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // timer setiap detik
      if (_timerCount > 0) {
        // jika waktu masih ada
        setState(() => _timerCount--); // kurangi waktu
      } else {
        // jika waktu habis
        timer.cancel(); //  batalkan timer
      }
    });
  }

  void _resendOtp() {
    // kirim ulang OTP
    setState(() => _timerCount = 60); // atur ulang waktu
    _startTimer(); // mulai timer lagi
    ScaffoldMessenger.of(context).showSnackBar(
      // tampilkan snackbar
      const SnackBar(
        content: Text('Kode OTP telah dikirim ulang.'),
      ), // pesan snackbar
    );
  }

  void _verifyOtp() async {
    // verifikasi OTP
    if (_otpController.text.isEmpty) {
      // jika input kosong
      ScaffoldMessenger.of(context).showSnackBar(
        // tampilkan snackbar
        const SnackBar(
          content: Text('Masukkan kode OTP terlebih dahulu'),
        ), // pesan snackbar
      );
      return; // keluar fungsi
    }

    setState(() => _isLoading = true); // atur status loading
    await Future.delayed(
      const Duration(seconds: 1),
    ); // simulasi delay verifikasi

    if (!mounted) return; // cek apakah widget masih ada

    if (_otpController.text.trim() == _dummyOtp) {
      // jika OTP benar
      Navigator.pushReplacement(
        // pindah ke layar dashboard
        context, // konteks saat ini
        MaterialPageRoute(
          builder: (context) => const SisdaDashboardScreen(),
        ), // layar dashboard SISDA
      );
    } else {
      // jika OTP salah
      _otpController.clear(); // bersihkan input
      showDialog(
        //  tampilkan dialog
        context: context, // konteks saat ini
        builder: // builder dialog
            (context) => AlertDialog(
              // dialog peringatan
              title: const Text("OTP Salah "), // judul dialog
              content: const Text(
                "Kode OTP yang kamu masukkan tidak valid.",
              ), // isi dialog
              actions: [
                // aksi dialog
                TextButton(
                  // tombol coba lagi
                  onPressed: () => Navigator.pop(context), // tutup dialog
                  child: const Text("Coba Lagi"), // teks tombol
                ),
              ],
            ),
      );
    }

    setState(() => _isLoading = false); // atur status loading
  }

  // UI
  @override
  Widget build(BuildContext context) {
    // bangun tampilan
    final green = const Color(0xFF0C4E1A); // warna hijau khas

    return Scaffold(
      // tampilan dasar
      backgroundColor: Colors.white, // warna latar belakang putih
      appBar: AppBar(
        // bilah aplikasi
        backgroundColor: green, // warna latar belakang hijau
        title: const Text('SISDA'), // judul bilah aplikasi
        centerTitle: false, //  judul tidak di tengah
        foregroundColor: Colors.white, // warna teks dan ikon putih
        leading: IconButton(
          // tombol kembali
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), // ikon tombol
          onPressed: () => Navigator.pop(context), // aksi tombol kembali
        ),
      ),
      body: Center(
        // isi halaman di tengah
        child: SingleChildScrollView(
          // gulir tunggal
          padding: const EdgeInsets.all(20), // padding halaman
          child: Column(
            // kolom vertikal
            mainAxisAlignment: MainAxisAlignment.center, // rata tengah
            children: [
              // isi kolom
              const Text(
                // judul aplikasi
                'SISDA',
                style: TextStyle(
                  //  gaya teks
                  fontSize: 36, //
                  fontWeight: FontWeight.w900, // tebal ekstrim
                  color: Color(0xFF0C4E1A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                // subjudul aplikasi
                'Sistem Informasi Santri/Siswa\nYayasan Darut Taqwa',
                textAlign: TextAlign.center, // rata tengah
                style: TextStyle(
                  color: Color(0xFF0C4E1A),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),

              // Card OTP
              Container(
                // wadah kartu OTP
                width: double.infinity, // lebar penuh
                padding: const EdgeInsets.all(24), // padding dalam
                decoration: BoxDecoration(
                  // dekorasi kartu
                  color: const Color(
                    0xFFD9EED9,
                  ), // warna latar belakang hijau muda
                  borderRadius: BorderRadius.circular(16), // sudut melengkung
                  boxShadow: [
                    // bayangan kartu
                    BoxShadow(
                      // bayangan
                      color: Colors.grey.shade300, // warna abu-abu muda
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  // kolom dalam kartu
                  children: [
                    // isi kolom
                    const Text(
                      // judul kartu
                      'Masukkan Kode OTP',
                      style: TextStyle(
                        //  gaya teks
                        fontSize: 20, // ukuran teks
                        fontWeight: FontWeight.bold, // tebal
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      // instruksi kartu
                      'Masukkan kode OTP yang telah dikirim ke nomor\n${widget.phoneNumber.replaceRange(2, 10, "********")}',
                      textAlign: TextAlign.center, // rata tengah
                      style: const TextStyle(fontSize: 14), // gaya teks
                    ),
                    const SizedBox(height: 20), //  jarak vertikal
                    // Input OTP
                    TextField(
                      // input teks
                      controller: _otpController, // kontroler input
                      keyboardType: TextInputType.number, // tipe keyboard angka
                      textAlign: TextAlign.center, // rata tengah
                      decoration: InputDecoration(
                        // dekorasi input
                        prefixIcon: const Icon(
                          //  ikon prefix
                          Icons.person, // ikon orang
                          color: Color(0xFF0C4E1A),
                        ),
                        hintText: "Masukkan kode OTP", // teks petunjuk
                        filled: true, // isi latar belakang
                        fillColor: Colors.white, // warna latar belakang putih
                        contentPadding: const EdgeInsets.symmetric(
                          //  padding dalam
                          horizontal: 20,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          // batas input
                          borderRadius: BorderRadius.circular(
                            40,
                          ), // sudut melengkung
                          borderSide: BorderSide.none, // tanpa batas
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), //  jarak vertikal
                    // Kirim Ulang Button
                    ElevatedButton(
                      // tombol kirim ulang
                      onPressed:
                          _timerCount == 0 ? _resendOtp : null, // aksi tombol
                      style: ElevatedButton.styleFrom(
                        // gaya tombol
                        backgroundColor:
                            Colors.amber[700], // warna latar belakang kuning
                        shape: RoundedRectangleBorder(
                          // bentuk tombol
                          borderRadius: BorderRadius.circular(
                            8,
                          ), // sudut melengkung
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        // teks tombol
                        _timerCount >
                                0 //  jika waktu masih ada
                            ? 'Kirim Ulang (${_timerCount})' // tampilkan waktu
                            : 'Kirim Ulang',
                        style: const TextStyle(
                          // gaya teks
                          fontWeight: FontWeight.bold, // tebal
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15), //  jarak vertikal
                    // Ganti Nomor & Verifikasi Buttons
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // rata spasi
                      children: [
                        // isi baris
                        Expanded(
                          //  tombol ganti nomor
                          child: ElevatedButton(
                            // tombol
                            onPressed:
                                () => Navigator.pop(
                                  context,
                                ), // aksi tombol kembali
                            style: ElevatedButton.styleFrom(
                              // gaya tombol
                              backgroundColor:
                                  Colors
                                      .redAccent, // warna latar belakang merah
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ), // padding dalam
                              shape: RoundedRectangleBorder(
                                // bentuk tombol
                                borderRadius: BorderRadius.circular(
                                  8,
                                ), // sudut melengkung
                              ),
                            ),
                            child: const Text(
                              // teks tombol
                              "Ganti Nomor",
                              style: TextStyle(
                                // gaya teks
                                color: Colors.white, // warna putih
                                fontWeight: FontWeight.bold, // tebal
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12), // jarak horizontal
                        Expanded(
                          // tombol verifikasi
                          child: ElevatedButton(
                            // tombol
                            onPressed:
                                _isLoading ? null : _verifyOtp, // aksi tombol
                            style: ElevatedButton.styleFrom(
                              // gaya tombol
                              backgroundColor:
                                  green, // warna latar belakang hijau
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ), // padding dalam
                              shape: RoundedRectangleBorder(
                                // bentuk tombol
                                borderRadius: BorderRadius.circular(
                                  8,
                                ), // sudut melengkung
                              ),
                            ),
                            child: // isi tombol
                                _isLoading // jika sedang loading
                                    ? const CircularProgressIndicator(
                                      // indikator loading
                                      color: Colors.white, // warna putih
                                      strokeWidth: 2, // ketebalan garis
                                    )
                                    : const Text(
                                      // teks tombol
                                      "Verifikasi",
                                      style: TextStyle(
                                        // gaya teks
                                        color: Colors.white, // warna putih
                                        fontWeight: FontWeight.bold, // tebal
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
