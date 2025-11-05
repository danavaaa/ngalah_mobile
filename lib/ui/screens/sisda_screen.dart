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
    _idController.dispose();
    _waController.dispose();
    super.dispose();
  }

  void _login() async {
    // metode login
    if (!_formKey.currentState!.validate()) return; // validasi form

    setState(() => _isLoading = true); // mulai loading
    try {
      // Ambil provider
      final sisdaProvider = Provider.of<SisdaProvider>(context, listen: false);

      // Cek login dengan data dummy
      final success = sisdaProvider.login(
        // metode login
        _idController.text.trim(), // ambil ID Yayasan
        _waController.text.trim(), // ambil Nomor WhatsApp
      );

      await Future.delayed(const Duration(seconds: 1)); // efek loading

      if (!mounted) return;

      if (success) {
        // jika login berhasil
        ScaffoldMessenger.of(context).showSnackBar(
          // tampilkan pesan sukses
          const SnackBar(
            content: Text('Login berhasil (data dummy)'),
          ), // pesan sukses
        );
      } else {
        // jika login gagal
        ScaffoldMessenger.of(context).showSnackBar(
          // tampilkan pesan gagal
          const SnackBar(
            content: Text('ID Yayasan atau Nomor WA salah'),
          ), // pesan gagal
        );
      }
    } catch (e) {
      // tangkap kesalahan
      if (!mounted) return; // pastikan widget masih terpasang
      ScaffoldMessenger.of(
        // tampilkan pesan kesalahan
        context,
      ).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      ); // pesan kesalahan
    } finally {
      //  akhirnya
      if (!mounted) return; // pastikan widget masih terpasang
      setState(() => _isLoading = false); // loading selesai
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
