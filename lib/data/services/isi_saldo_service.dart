import '../models/topup_va.dart';

class IsiSaldoService {
  /// Fungsi membuat permintaan topup, untuk nanti bisa diganti sesuai API
  Future<TopupVa> createTopup({
    required int nominal,
    required String bankCode,
  }) async {
    // simulasi loading API
    await Future.delayed(const Duration(seconds: 1));

    return TopupVa(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // id dummy

      bankName:
          bankCode == 'BSI'
              ? 'Bank Syariah Indonesia (BSI)'
              : bankCode == 'BNI'
              ? 'Bank Negara Indonesia (BNI)'
              : bankCode == 'BRI'
              ? 'Bank Rakyat Indonesia (BRI)'
              : 'Bank Tidak Dikenal',

      bankCode: bankCode,
      vaNumber: '9999 9999 9999 999', // dummy VA
      nominal: nominal,
      adminFee: 2500,

      expiredAt: DateTime.now().add(
        const Duration(hours: 24),
      ), // masa berlaku 24 jam
    );
  }
}
