import 'package:provider/provider.dart';
import '../../providers/sisda_provider.dart';
import 'package:flutter/material.dart';

class SisdaScreen extends StatefulWidget {
  // Sisda Screen
  const SisdaScreen({Key? key}) : super(key: key);

  @override
  _SisdaScreenState createState() => _SisdaScreenState();
}

class _SisdaScreenState extends State<SisdaScreen> {
  final _formKey = GlobalKey<FormState>(); // kunci form
  final _idController = TextEditingController(); // ID Yayasan
  final _waController = TextEditingController(); // Nomor WhatsApp
  bool _isLoading = false; // status loading

  @override
  void dispose() {
    // metode dispose
    // bersihkan controller saat dispose
    _idController.dispose(); // bersihkan controller ID
    _waController.dispose(); // bersihkan controller WA
    super.dispose();
  }

  void _login() async {
    // metode login
    if (!_formKey.currentState!.validate()) return; // validasi form

    setState(() => _isLoading = true); // mulai loading
    try {
      final sisdaProvider = Provider.of<SisdaProvider>(
        context,
        listen: false,
      ); // akses provider
      final success = sisdaProvider.login(
        // panggil metode login
        _idController.text.trim(), // ID Yayasan
        _waController.text.trim(), // Nomor WhatsApp
      );

      await Future.delayed(const Duration(seconds: 1)); // efek loading kecil

      if (!mounted) return; // pastikan widget masih ada

      if (success) {
        //  login sukses
        showDialog(
          //  Pop-up  sukses
          context: context,
          barrierDismissible: false, // tidak bisa ditutup sembarangan
          builder: (context) {
            // buat dialog
            return Dialog(
              // dialog modern
              shape: RoundedRectangleBorder(
                // bentuk dialog
                borderRadius: BorderRadius.circular(20), // sudut melengkung
              ),
              backgroundColor: Colors.transparent, // latar belakang transparan
              child: Container(
                // wadah isi dialog
                padding: const EdgeInsets.all(20), // padding dalam
                decoration: BoxDecoration(
                  // dekorasi kotak
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20), // sudut melengkung
                  boxShadow: [
                    // bayangan kotak
                    BoxShadow(
                      // bayangan
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8, // ketebalan bayangan
                      offset: const Offset(0, 3), // posisi bayangan
                    ),
                  ],
                ),
                child: Column(
                  // kolom isi dialog
                  mainAxisSize: MainAxisSize.min, // sesuaikan ukuran
                  children: [
                    // isi kolom
                    const Icon(
                      //  ikon sukses
                      Icons.check_circle_rounded, // ikon centang
                      color: Color(0xFF0C4E1A), // warna hijau
                      size: 70,
                    ),
                    const SizedBox(height: 12), // jarak vertikal
                    const Text(
                      // teks sukses
                      "Login Berhasil!",
                      style: TextStyle(
                        //  gaya teks
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0C4E1A),
                      ),
                    ),
                    const SizedBox(height: 10), // jarak vertikal
                    const Text(
                      // deskripsi sukses
                      "Selamat datang di Sistem Informasi Santri/Siswa (Sisda).\nAnda berhasil login menggunakan data dummy.",
                      textAlign: TextAlign.center, // teks di tengah
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 20), // jarak vertikal
                    ElevatedButton(
                      // tombol OK
                      onPressed: () {
                        // tutup dialog
                        Navigator.pop(context);
                        // Navigasi ke halaman dashboard bisa ditaruh di sini
                      },
                      style: ElevatedButton.styleFrom(
                        // gaya tombol
                        backgroundColor: const Color(0xFF0C4E1A), // warna hijau
                        shape: RoundedRectangleBorder(
                          // bentuk tombol
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          // padding tombol
                          horizontal: 40,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        // teks tombol
                        "OK",
                        style: TextStyle(
                          //  gaya teks
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    } finally {
      // selalu jalankan
      if (mounted) setState(() => _isLoading = false); // berhenti loading
    }
  }

  @override
  Widget build(BuildContext context) {
    //  UI
    final green = const Color(0xFF0C4E1A); // warna hijau khas

    return Scaffold(
      // tampilan dasar
      backgroundColor: Colors.white, // latar belakang putih
      appBar: AppBar(
        // bilah aplikasi
        backgroundColor: green, // warna latar belakang hijau
        foregroundColor: Colors.white, // teks dan ikon AppBar jadi putih
        title: const Text(
          // Judul bilah aplikasi
          'Sisda',
          style: TextStyle(
            // gaya teks
            fontWeight: FontWeight.bold,
            color: Colors.white, // teks title putih
          ),
        ),
        leading: IconButton(
          // tombol kembali
          icon: const Icon(
            // ikon panah kembali
            Icons.arrow_back, // ikon panah
            color: Colors.white, // teks putih
          ), // panah putih
          onPressed:
              () => Navigator.pop(context), // kembali ke layar sebelumnya
        ),
        centerTitle: false, // judul tidak di tengah
      ),

      // Body di tengah layar
      body: Center(
        // pusatkan konten
        child: SingleChildScrollView(
          // agar bisa di scroll
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 30,
          ), // padding sekitar
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // vertikal tengah
            crossAxisAlignment: CrossAxisAlignment.center, // horizontal tengah
            children: [
              // Judul
              const Text(
                // judul aplikasi
                'SISDA',
                textAlign: TextAlign.center, // rata tengah

                style: TextStyle(
                  // gaya teks
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0C4E1A),
                ),
              ),
              const SizedBox(height: 8), // jarak vertikal
              const Text(
                // deskripsi aplikasi
                'Sistem Informasi Santri/Siswa\nYayasan Darut Taqwa',
                textAlign: TextAlign.center, // rata tengah
                style: TextStyle(
                  // gaya teks
                  color: Color(0xFF0C4E1A),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              // Card login
              Container(
                // wadah form
                width: double.infinity, // lebar penuh
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  // dekorasi kotak
                  color: green.withOpacity(0.1), // latar belakang hijau muda
                  borderRadius: BorderRadius.circular(16), // sudut melengkung
                  boxShadow: [
                    // bayangan kotak
                    BoxShadow(
                      // bayangan
                      color: Colors.grey.shade300,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Form(
                  // form login
                  key: _formKey,
                  child: Column(
                    // kolom form
                    children: [
                      // isi form
                      Text(
                        'Khusus Wali Santri/Siswa',
                        textAlign: TextAlign.center, // rata tengah
                        style: TextStyle(
                          // gaya teks
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Pastikan Nomor WhatsApp telah terdaftar di sistem kami\n'
                        '(memperoleh tagihan di setiap bulannya)\n\n'
                        'Apabila nomor belum terdaftar, silahkan menghubungi Customer Service kami.',
                        textAlign: TextAlign.center, // teks di tengah
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      SizedBox(height: 25), // Jarak sebelum tombol
                      // ID Yayasan
                      TextFormField(
                        // input ID Yayasan
                        controller: _idController,
                        decoration: InputDecoration(
                          // dekorasi input
                          prefixIcon: const Icon(
                            // ikon di depan
                            Icons.account_circle_rounded, // ikon user
                            color: Colors.white,
                          ),
                          hintText: "ID Yayasan", // teks petunjuk
                          filled: true, // mengisi latar belakang
                          fillColor: Colors.white, // latar belakang putih
                          prefixIconColor: green,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            // border melengkung
                            borderRadius: BorderRadius.circular(
                              40,
                            ), // sudut melengkung
                            borderSide: BorderSide.none, // hilangkan border
                          ),
                        ),
                        validator: (value) {
                          // validasi input
                          if (value == null || value.isEmpty) {
                            // jika kosong
                            return "Masukkan ID Yayasan"; // pesan error " masukkan ID Yayasan"
                          }
                          return null; // validasi lolos
                        },
                      ),
                      const SizedBox(height: 16),

                      // Nomor WhatsApp
                      TextFormField(
                        // input nomor WhatsApp
                        controller: _waController,
                        keyboardType: TextInputType.phone, // tipe input telepon
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            // ikon di depan
                            Icons.phone, // ikon telepon
                            color: Colors.white,
                          ),
                          hintText: "Nomor WhatsApp", // teks petunjuk
                          filled: true, // mengisi latar belakang
                          fillColor: Colors.white, // latar belakang putih
                          prefixIconColor: green, // warna ikon
                          contentPadding: const EdgeInsets.symmetric(
                            // padding dalam input
                            horizontal: 20,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            // border melengkung
                            borderRadius: BorderRadius.circular(
                              40,
                            ), // sudut melengkung
                            borderSide: BorderSide.none, // hilangkan border
                          ),
                        ),
                        validator: (value) {
                          // validasi input
                          if (value == null || value.isEmpty) {
                            // jika kosong
                            return "Masukkan nomor WhatsApp"; // pesan error
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25), // Jarak sebelum tombol
                      // Tombol Login
                      SizedBox(
                        // wadah tombol
                        width: double.infinity, // lebar penuh
                        child: ElevatedButton(
                          // tombol login
                          style: ElevatedButton.styleFrom(
                            // gaya tombol
                            backgroundColor: green, // warna hijau
                            shape: RoundedRectangleBorder(
                              // bentuk tombol
                              borderRadius: BorderRadius.circular(
                                10,
                              ), // sudut melengkung
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ), // padding vertikal
                          ),
                          onPressed:
                              _isLoading
                                  ? null
                                  : _login, // nonaktif saat loading
                          child: // isi tombol
                              _isLoading // tampilkan loading
                                  ? const SizedBox(
                                    // wadah loading
                                    height: 20, // tinggi 20
                                    width: 20, // lebar 20
                                    child: CircularProgressIndicator(
                                      // indikator loading
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      strokeWidth: 2, // ketebalan garis
                                    ),
                                  )
                                  : const Text(
                                    // teks tombol
                                    "LOGIN",
                                    style: TextStyle(
                                      // gaya teks
                                      fontWeight: FontWeight.bold, // tebal
                                      fontSize: 16,
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Hubungi CS
                      TextButton(
                        // tombol teks
                        onPressed: () {
                          // nanti bisa diarahkan ke WhatsApp API
                        },
                        style: TextButton.styleFrom(
                          // gaya tombol
                          backgroundColor: green.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            // bentuk tombol
                            borderRadius: BorderRadius.circular(
                              8,
                            ), // sudut melengkung
                          ),
                        ),
                        child: const Text(
                          // teks tombol
                          "Hubungi Customer Service",
                          style: TextStyle(
                            color: Color(0xFF0C4E1A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30), // Jarak bawah card
            ],
          ),
        ),
      ),
    );
  }
}
