import 'package:flutter/material.dart';

class SisdaProvider with ChangeNotifier {
  final List<Map<String, String>> _dummyAccounts = [
    // data dummy untuk demonstrasi
    {"idYayasan": "YDT001", "nomorWA": "081234567890"},
    {"idYayasan": "YDT002", "nomorWA": "089876543210"},
  ];

  bool login(String idYayasan, String nomorWA) {
    // metode login sederhana
    try {
      final account = _dummyAccounts.firstWhere(
        // mencari akun yang cocok
        (acc) =>
            acc['idYayasan'] == idYayasan && // validasi
            acc['nomorWA'] == nomorWA, // validasi
      );
      return account.isNotEmpty; // jika ditemukan, kembalikan true
    } catch (e) {
      // jika tidak ditemukan, tangkap pengecualian
      return false; // kembalikan false
    }
  }
}
