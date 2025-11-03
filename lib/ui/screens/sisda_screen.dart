import 'package:flutter/material.dart';

class SisdaScreen extends StatelessWidget {
  SisdaScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF0C4E1A);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: green,
        foregroundColor: Colors.white, // ✅ teks dan ikon AppBar jadi putih
        title: const Text(
          'Sisda',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // ✅ teks title putih
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
            mainAxisAlignment: MainAxisAlignment.center, // ✅ vertikal tengah
            crossAxisAlignment:
                CrossAxisAlignment.center, // ✅ horizontal tengah
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
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
