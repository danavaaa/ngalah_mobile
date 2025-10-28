import 'package:flutter/material.dart';
import 'core/router.dart';
import 'core/theme.dart';

class NgalahApp extends StatelessWidget {
  const NgalahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ngalah Mobile',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.onGenerate,
    );
  }
}
