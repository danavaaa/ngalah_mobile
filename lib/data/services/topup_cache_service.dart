import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/topup_va.dart';

class TopupCacheService {
  static const String _keyActiveTopup = 'active_topup_va';

  Future<void> saveActiveTopup(TopupVa topup) async {
    final prefs = await SharedPreferences.getInstance();

    final map = <String, dynamic>{
      'id': topup.id,
      'nominal': topup.nominal,
      'admin_fee': topup.adminFee,
      'bank_name': topup.bankName,
      'bank_code': topup.bankCode,
      'va_number': topup.vaNumber,
      'expired_at': topup.expiredAt.toIso8601String(),
    };

    await prefs.setString(_keyActiveTopup, jsonEncode(map));
  }

  Future<TopupVa?> getActiveTopup() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyActiveTopup);
    if (raw == null || raw.isEmpty) return null;

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final topup = TopupVa.fromJson(map);

      // kalau sudah expired, auto clear biar dashboard gak munculin lagi
      if (topup.expiredAt.isBefore(DateTime.now())) {
        await clearActiveTopup();
        return null;
      }

      return topup;
    } catch (_) {
      // kalau data rusak, buang saja
      await clearActiveTopup();
      return null;
    }
  }

  Future<void> clearActiveTopup() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyActiveTopup);
  }
}
