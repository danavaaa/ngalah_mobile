import 'package:flutter/material.dart';
import '../ui/screens/splash_screen.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/reading_screen.dart';
import '../ui/screens/settings_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const home = '/home'; // home screen route
  static const reading = '/reading'; // reading screen route
  static const settings = '/settings'; // settings screen route

  static Route<dynamic> onGenerate(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        ); // splash screen route
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ); // home screen route
      case reading:
        return MaterialPageRoute(
          builder: (_) => const ReadingScreen(),
        ); // reading screen route
      case settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        ); // settings screen route
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        ); // default to splash screen
    }
  }
}
