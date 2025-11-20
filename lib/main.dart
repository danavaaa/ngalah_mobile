import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/screens/splash_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/reading_screen.dart';
import 'ui/screens/sisda_screen.dart';
import 'ui/screens/ppdb_screen.dart';
import 'ui/screens/settings_screen.dart';
import 'providers/sisda_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NgalahApp());
}

class NgalahApp extends StatelessWidget {
  const NgalahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SisdaProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ngalah Mobile',
        theme: ThemeData(
          primaryColor: const Color(0xFF0C4E1A),
          fontFamily: 'Poppins',
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

/// Navigasi utama dengan bottom navigation
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF0C4E1A);

    // daftar layar, HomeScreen diberi callback untuk pindah ke tab SISDA
    final List<Widget> screens = [
      HomeScreen(
        onTapSisda: () {
          setState(() => _currentIndex = 2); // index 2 = SisdaScreen
        },
      ),
      const ReadingScreen(),
      const SisdaScreen(),
      const PpdbScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: green,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'BERANDA'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'BACAAN'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'SISDA'),
          BottomNavigationBarItem(icon: Icon(Icons.group_add), label: 'PPDB'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'SETTING'),
        ],
      ),
    );
  }
}
