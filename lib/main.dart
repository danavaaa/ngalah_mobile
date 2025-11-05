import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ✅ Tambahkan ini
import 'ui/screens/splash_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/reading_screen.dart';
import 'ui/screens/sisda_screen.dart';
import 'ui/screens/ppdb_screen.dart';
import 'ui/screens/settings_screen.dart';
import 'providers/sisda_provider.dart'; // Provider yang baru kamu buat

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NgalahApp()); // Menjalankan aplikasi NgalahApp
}

class NgalahApp extends StatelessWidget {
  const NgalahApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Bungkus MaterialApp dengan MultiProvider
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SisdaProvider(),
        ), // daftar provider
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ngalah Mobile', // Judul aplikasi
        theme: ThemeData(
          // Tema aplikasi
          primaryColor: const Color(0xFF0C4E1A), // warna hijau khas
          fontFamily: 'Poppins',
        ),
        home: const SplashScreen(), // Halaman awal aplikasi
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  // navigasi utama
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0; // indeks layar saat ini

  final List<Widget> _screens = [
    // daftar layar
    HomeScreen(),
    ReadingScreen(),
    SisdaScreen(),
    PpdbScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    //  tampilan
    final green = const Color(0xFF0C4E1A); // warna hijau khas

    return Scaffold(
      // tampilan dasar
      body: _screens[_currentIndex], // tampilkan layar sesuai indeks saat ini
      bottomNavigationBar: BottomNavigationBar(
        // bilah navigasi bawah
        currentIndex: _currentIndex, // indeks saat ini
        selectedItemColor: Colors.white, // warna item terpilih putih
        unselectedItemColor:
            Colors.white70, // warna item tidak terpilih putih transparan
        backgroundColor: green, // warna latar belakang hijau
        type: BottomNavigationBarType.fixed, // tipe bilah navigasi tetap
        onTap: (index) {
          setState(
            () => _currentIndex = index,
          ); // perbarui indeks saat item ditekan
        },
        items: const [
          // item bilah navigasi
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'BERANDA',
          ), // ikon dan label Beranda
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'BACAAN'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'SISDA'),
          BottomNavigationBarItem(icon: Icon(Icons.group_add), label: 'PPDB'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'SETTING'),
        ],
      ),
    );
  }
}
