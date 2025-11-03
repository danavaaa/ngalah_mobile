import 'package:flutter/material.dart';

class SisdaScreen extends StatefulWidget {
  const SisdaScreen({Key? key}) : super(key: key);

  @override
  _SisdaScreenState createState() => _SisdaScreenState();
}

class _SisdaScreenState extends State<SisdaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _waController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _idController.dispose();
    _waController.dispose();
    super.dispose();
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      // Simulasi permintaan jaringan / proses login
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login berhasil')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF0C4E1A);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: green,
        foregroundColor: Colors.white, // teks dan ikon AppBar jadi putih
        title: const Text(
          'Sisda',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // teks title putih
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), // ✅ panah putih
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
      ),

      // 🔹 Body di tengah layar
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // vertikal tengah
            crossAxisAlignment: CrossAxisAlignment.center, // horizontal tengah
            children: [
              // Judul
              const Text(
                'SISDA',
                textAlign: TextAlign.center,
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

              // Card login
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Khusus Wali Santri/Siswa',
                        textAlign: TextAlign.center,
                        style: TextStyle(
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
                        controller: _idController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.account_circle_rounded, // ikon user
                            color: Colors.white,
                          ),
                          hintText: "ID Yayasan",
                          filled: true,
                          fillColor: Colors.white,
                          prefixIconColor: green,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Masukkan ID Yayasan";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Nomor WhatsApp
                      TextFormField(
                        controller: _waController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          hintText: "Nomor WhatsApp",
                          filled: true,
                          fillColor: Colors.white,
                          prefixIconColor: green, // warna ikon
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Masukkan nomor WhatsApp";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),

                      // Tombol Login
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _isLoading ? null : _login,
                          child:
                              _isLoading
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text(
                                    "LOGIN",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 10),
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
