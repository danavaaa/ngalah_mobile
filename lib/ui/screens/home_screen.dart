import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onTapSisda; // callback pindah tab SISDA

  const HomeScreen({super.key, this.onTapSisda});

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF0C4E1A);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [green.withOpacity(0.9), green],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    Image.asset('assets/images/logo_ngalah.png', width: 100),
                    const SizedBox(height: 12),
                    const Text(
                      'Ngalah Mobile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Selamat Datang di Aplikasi Yayasan Darut Taqwa Sengonagung',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // GRID MENU
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildMenu(
                      label: 'PPDB',
                      pngPath: 'assets/icons/ppdb.png',
                      onTap: () {},
                    ),
                    _buildMenu(
                      label: 'SISDA',
                      pngPath: 'assets/icons/sisda.png',
                      onTap: onTapSisda, // pindah tab ke sisda
                    ),
                    _buildMenu(
                      label: 'WAWASAN',
                      pngPath: 'assets/icons/wawasan.png',
                    ),
                    _buildMenu(
                      label: 'YASINAN',
                      pngPath: 'assets/icons/yasinan.png',
                    ),
                    _buildMenu(
                      label: 'KARYA NGALAH',
                      pngPath: 'assets/icons/karya.png',
                    ),
                    _buildMenu(
                      label: 'KHUTBAH',
                      pngPath: 'assets/icons/khutbah.png',
                    ),
                    _buildMenu(
                      label: 'JAMALIN',
                      pngPath: 'assets/icons/jamalin.png',
                    ),
                    _buildMenu(
                      label: 'AL QUR\'AN',
                      pngPath: 'assets/icons/quran.png',
                    ),
                    _buildMenu(
                      label: 'WIRID & DO\'A',
                      pngPath: 'assets/icons/wirid.png',
                    ),
                    _buildMenu(
                      label: 'MAULID',
                      pngPath: 'assets/icons/maulid.png',
                    ),
                    _buildMenu(
                      label: 'LAINNYA',
                      pngPath: 'assets/icons/lainnya.png',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET MENU
  Widget _buildMenu({
    required String label,
    required String pngPath,
    VoidCallback? onTap,
  }) {
    final green = const Color(0xFF0C4E1A);

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: green.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(pngPath, fit: BoxFit.contain),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
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
