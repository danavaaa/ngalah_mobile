import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Home Screen UI
    final green = const Color(0xFF0C4E1A); // warna hijau khas aplikasi

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // memastikan UI tidak tertutup area aman perangkat
        child: Column(
          // tata letak kolom vertikal
          children: [
            // Header
            Container(
              width: double.infinity, // lebar penuh layar
              padding: const EdgeInsets.symmetric(
                vertical: 40,
                horizontal: 16,
              ), // padding vertikal dan horizontal
              decoration: BoxDecoration(
                // dekorasi latar belakang
                gradient: LinearGradient(
                  // gradasi warna
                  colors: [
                    green.withValues(alpha: 0.9),
                    green,
                  ], // gradasi hijau
                  begin: Alignment.topCenter, // mulai dari atas
                  end: Alignment.bottomCenter, // berakhir di bawah
                ),
                borderRadius: const BorderRadius.vertical(
                  // sudut melengkung di bagian bawah
                  bottom: Radius.circular(50), // radius lengkung 50
                ),
              ),
              child: Column(
                // kolom untuk logo dan teks
                children: [
                  // isi header
                  Image.asset(
                    'assets/images/logo_ngalah.png',
                    width: 100,
                  ), // logo aplikasi
                  const SizedBox(height: 12), // jarak vertikal
                  const Text(
                    // judul aplikasi
                    'Ngalah Mobile',
                    style: TextStyle(
                      // gaya teks
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    // teks sambutan
                    'Selamat Datang di Aplikasi Yayasan Darut Taqwa Sengonagung',
                    textAlign: TextAlign.center, // rata tengah
                    style: TextStyle(
                      // gaya teks
                      color: Colors.white, // warna putih
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Grid menu utama
            Expanded(
              // mengisi ruang yang tersisa
              child: Padding(
                // padding horizontal
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ), // padding horizontal
                child: GridView.count(
                  // grid dengan jumlah kolom tetap
                  crossAxisCount: 3, // 3 kolom
                  mainAxisSpacing: 20, // jarak vertikal antar item
                  crossAxisSpacing: 20, // jarak horizontal antar item
                  children: [
                    // daftar menu
                    _buildMenu('PPDB', 'assets/icons/ppdb.svg'),
                    _buildMenu('SISDA', 'assets/icons/sisda.svg'),
                    _buildMenu('WAWASAN', 'assets/icons/wawasan.svg'),
                    _buildMenu('YASINAN', 'assets/icons/yasinan.svg'),
                    _buildMenu('KARYA NGALAH', 'assets/icons/karya.svg'),
                    _buildMenu('KHUTBAH', 'assets/icons/khutbah.svg'),
                    _buildMenu('JAMALIN', 'assets/icons/jamalin.svg'),
                    _buildMenu('AL QUR\'AN', 'assets/icons/quran.svg'),
                    _buildMenu('WIRID & DO\'A', 'assets/icons/wirid.svg'),
                    _buildMenu('MAULID', 'assets/icons/maulid.svg'),
                    _buildMenu('LAINNYA', 'assets/icons/lainnya.svg'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu(String label, String assetPath) {
    // widget menu individual
    final green = const Color(0xFF0C4E1A); // warna hijau khas aplikasi
    return InkWell(
      // membuat area yang dapat ditekan
      borderRadius: BorderRadius.circular(16), // sudut melengkung
      onTap: () {}, // aksi saat ditekan
      child: Column(
        // tata letak vertikal
        mainAxisSize: MainAxisSize.min, // ukuran utama sesuai konten
        children: [
          // isi menu
          Container(
            // wadah ikon
            width: 70,
            height: 70,
            padding: const EdgeInsets.all(12), // padding di dalam wadah
            decoration: BoxDecoration(
              // dekorasi wadah
              color: green.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16), // sudut melengkung
            ),
            child: SvgPicture.asset(
              // ikon menu
              assetPath, // path ikon
              fit: BoxFit.contain, // menyesuaikan ukuran
              colorFilter: null, // tidak ada filter warna
            ),
          ),
          const SizedBox(height: 8), // jarak vertikal
          Text(
            // teks label menu
            label, // teks label
            textAlign: TextAlign.center, // rata tengah
            style: TextStyle(
              color: green,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
