import 'package:flutter/material.dart';

class SisdaProvider with ChangeNotifier {
  /// Dummy data untuk login awal
  final List<Map<String, String>> _dummyAccounts = [
    {"idYayasan": "YDT001", "nomorWA": "081234567890"},
    {"idYayasan": "YDT002", "nomorWA": "089876543210"},
  ];

  bool _isLoggedIn = false;
  Map<String, String>? _currentAccount;

  bool get isLoggedIn => _isLoggedIn;
  Map<String, String>? get currentAccount => _currentAccount;

  bool loginWithDummy(String idYayasan, String nomorWA) {
    try {
      final acc = _dummyAccounts.firstWhere(
        (data) => data["idYayasan"] == idYayasan && data["nomorWA"] == nomorWA,
      );

      _currentAccount = acc; // Simpan data user (SEBELUM OTP)
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Tahap 2: OTP benar → User resmi dinyatakan login SISDA
  void markOtpSuccess() {
    _isLoggedIn = true;
    notifyListeners();
  }
}
