import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onTapSisda; // callback pindah tab SISDA

  const HomeScreen({super.key, this.onTapSisda});

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF0C4E1A);
    // daftar menu di home screen
    final menus = <_HomeMenu>[
      _HomeMenu('PPDB', 'assets/icons/ppdb.png', onTap: () {}),
      _HomeMenu('SISDA', 'assets/icons/sisda.png', onTap: onTapSisda),
      _HomeMenu('WAWASAN', 'assets/icons/wawasan.png'),
      _HomeMenu('YASINAN', 'assets/icons/yasinan.png'),
      _HomeMenu('KARYA NGALAH', 'assets/icons/karya.png'),
      _HomeMenu('KHUTBAH', 'assets/icons/khutbah.png'),
      _HomeMenu('JAMALIN', 'assets/icons/jamalin.png'),
      _HomeMenu('AL QUR\'AN', 'assets/icons/quran.png'),
      _HomeMenu('WIRID & DO\'A', 'assets/icons/wirid.png'),
      _HomeMenu('MAULID', 'assets/icons/maulid.png'),
      _HomeMenu('LAINNYA', 'assets/icons/lainnya.png'),
    ];
    // halaman utama aplikasi
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                child: _Header(green: green),
              ),
            ),
            // icon menu grid
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 18),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _IconMenuTile(menu: menus[i], green: green),
                  childCount: menus.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 18,

                  mainAxisExtent: 118,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Color green;
  const _Header({required this.green});
  // header di home screen
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
      decoration: BoxDecoration(
        color: green,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/logo_ngalah.png', width: 80),
          const SizedBox(height: 10),
          const Text(
            'Ngalah Mobile',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Selamat Pagi,\nSelamat Datang di Aplikasi yayasan Darut Taqwa Sengonagung',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// tile icon menu di home screen
class _IconMenuTile extends StatelessWidget {
  final _HomeMenu menu;
  final Color green;

  const _IconMenuTile({required this.menu, required this.green});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: menu.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // icon menu
          SizedBox(
            width: 54,
            height: 54,
            child: Image.asset(menu.pngPath, fit: BoxFit.contain),
          ),
          const SizedBox(height: 8),

          // label menu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              menu.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: green,
                fontSize: 12,
                height: 1.15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// model menu di home screen
class _HomeMenu {
  final String label;
  final String pngPath;
  final VoidCallback? onTap;

  _HomeMenu(this.label, this.pngPath, {this.onTap});
}
