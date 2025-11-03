import 'package:flutter/material.dart';
import 'ui/screens/splash_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/reading_screen.dart';
import 'ui/screens/sisda_screen.dart';
import 'ui/screens/ppdb_screen.dart';
import 'ui/screens/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NgalahApp());
}

class NgalahApp extends StatelessWidget {
  const NgalahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ngalah Mobile',
      theme: ThemeData(
        primaryColor: const Color(0xFF0C4E1A),
        fontFamily: 'Poppins',
      ),
      home: const SplashScreen(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ReadingScreen(),
    SisdaScreen(),
    PpdbScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF0C4E1A);

    return Scaffold(
      body: _screens[_currentIndex],
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
