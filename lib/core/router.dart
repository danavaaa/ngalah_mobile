import 'package:flutter/material.dart';
import '../ui/screens/splash_screen.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/reading_screen.dart';
import '../ui/screens/settings_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const reading = '/reading';
  static const settings = '/settings';

  static Route<dynamic> onGenerate(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case reading:
        return MaterialPageRoute(builder: (_) => const ReadingScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
