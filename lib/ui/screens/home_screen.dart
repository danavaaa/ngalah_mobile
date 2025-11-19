import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                    _buildMenu('PPDB', 'assets/icons/ppdb.png'),
                    _buildMenu('SISDA', 'assets/icons/sisda.png'),
                    _buildMenu('WAWASAN', 'assets/icons/wawasan.png'),
                    _buildMenu('YASINAN', 'assets/icons/yasinan.png'),
                    _buildMenu('KARYA NGALAH', 'assets/icons/karya.png'),
                    _buildMenu('KHUTBAH', 'assets/icons/khutbah.png'),
                    _buildMenu('JAMALIN', 'assets/icons/jamalin.png'),
                    _buildMenu('AL QUR\'AN', 'assets/icons/quran.png'),
                    _buildMenu('WIRID & DO\'A', 'assets/icons/wirid.png'),
                    _buildMenu('MAULID', 'assets/icons/maulid.png'),
                    _buildMenu('LAINNYA', 'assets/icons/lainnya.png'),
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
  Widget _buildMenu(String label, String pngPath) {
    final green = const Color(0xFF0C4E1A);

    return InkWell(
      onTap: () {},
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
