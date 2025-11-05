import 'package:flutter/foundation.dart';

class AppProvider with ChangeNotifier {
  // provide untuk state management aplikasi
  int _selectedTab = 0; // tab yang dipilih pada navigasi utama
  int get selectedTab => _selectedTab; // getter untuk tab yang dipilih

  void setTab(int i) {
    _selectedTab = i;
    notifyListeners();
  }
}
