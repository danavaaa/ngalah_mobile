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
            const _HeaderCloud(),
            const SizedBox(height: 20),

            // 📱 Grid menu utama
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: const [
                    _MenuItem(
                      label: 'PPDB',
                      assetPath: 'assets/icons/ppdb.svg',
                    ),
                    _MenuItem(
                      label: 'SISDA',
                      assetPath: 'assets/icons/sisda.svg',
                    ),
                    _MenuItem(
                      label: 'WAWASAN',
                      assetPath: 'assets/icons/wawasan.svg',
                    ),
                    _MenuItem(
                      label: 'YASINAN',
                      assetPath: 'assets/icons/yasinan.svg',
                    ),
                    _MenuItem(
                      label: 'KARYA NGALAH',
                      assetPath: 'assets/icons/karya.svg',
                    ),
                    _MenuItem(
                      label: 'KHUTBAH',
                      assetPath: 'assets/icons/khutbah.svg',
                    ),
                    _MenuItem(
                      label: 'JAMALIN',
                      assetPath: 'assets/icons/jamalin.svg',
                    ),
                    _MenuItem(
                      label: 'AL QUR\'AN',
                      assetPath: 'assets/icons/quran.svg',
                    ),
                    _MenuItem(
                      label: 'WIRID & DO\'A',
                      assetPath: 'assets/icons/wirid.svg',
                    ),
                    _MenuItem(
                      label: 'MAULID',
                      assetPath: 'assets/icons/maulid.svg',
                    ),
                    _MenuItem(
                      label: 'LAINNYA',
                      assetPath: 'assets/icons/lainnya.svg',
                    ),
                  ],
                ),
              ),
            ),

            // ⚙️ Bottom Navigation Bar
            Container(
              color: green,
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _BottomItem(icon: Icons.home, label: 'BERANDA', active: true),
                  _BottomItem(icon: Icons.menu_book, label: 'BACAAN'),
                  _BottomItem(icon: Icons.person, label: 'SISDA'),
                  _BottomItem(icon: Icons.group_add, label: 'PPDB'),
                  _BottomItem(icon: Icons.settings, label: 'SETTING'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCloud extends StatelessWidget {
  const _HeaderCloud();

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF0C4E1A);

    return Stack(
      children: [
        Container(
          height: 260,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [green.withOpacity(0.9), green],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        ClipPath(
          clipper: _CloudClipper(),
          child: Container(height: 100, color: Colors.white),
        ),
        Positioned(
          top: 70,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Image.asset('assets/images/logo_ngalah.png', width: 100),
              const SizedBox(height: 10),
              const Text(
                'Ngalah Mobile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Selamat Pagi,\nSelamat Datang di Aplikasi Yayasan Darut Taqwa Sengonagung',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CloudClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height - 30,
    );
    path.quadraticBezierTo(
      size.width * 3 / 4,
      size.height - 60,
      size.width,
      size.height - 20,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _MenuItem extends StatelessWidget {
  final String label;
  final String assetPath;

  const _MenuItem({required this.label, required this.assetPath});

  @override
  Widget build(BuildContext context) {
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
              width: 32,
              height: 32,
              color: null, // tampilkan warna asli SVG
              semanticsLabel: label,
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

class _BottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _BottomItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: active ? Colors.white : Colors.white70, size: 24),
        Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
