import 'package:flutter/foundation.dart';

class AppProvider with ChangeNotifier {
  int _selectedTab = 0;
  int get selectedTab => _selectedTab;

  void setTab(int i) {
    _selectedTab = i;
    notifyListeners();
  }
}
