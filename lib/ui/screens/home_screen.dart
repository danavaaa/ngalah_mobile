import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF0C4E1A);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [green.withValues(alpha: 0.9), green],
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
                  const SizedBox(height: 16),
                  const Text(
                    'Selamat Datang di Aplikasi Yayasan Darut Taqwa Sengonagung',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
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
    final green = const Color(0xFF0C4E1A);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
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
            child: SvgPicture.asset(
              assetPath,
              fit: BoxFit.contain,
              colorFilter: null,
            ),
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
