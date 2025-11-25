class TopupVa {
  final String id; // id transaksi topup
  final int nominal; // nominal isi saldo (tanpa admin)
  final int adminFee; // biaya admin
  final String bankName; // nama bank, mis: "Bank Syariah Indonesia (BSI)"
  final String bankCode; // kode bank, mis: "BSI"
  final String vaNumber; // nomor VA, mis: "9999 9999 9999 999"
  final DateTime expiredAt; // waktu kadaluarsa pembayaran

  TopupVa({
    required this.id,
    required this.nominal,
    required this.adminFee,
    required this.bankName,
    required this.bankCode,
    required this.vaNumber,
    required this.expiredAt,
  });

  int get totalTransfer => nominal + adminFee;

  factory TopupVa.fromJson(Map<String, dynamic> json) {
    return TopupVa(
      id: json['id']?.toString() ?? '',
      nominal: json['nominal'] ?? 0,
      adminFee: json['admin_fee'] ?? 0,
      bankName: json['bank_name'] ?? '',
      bankCode: json['bank_code'] ?? '',
      vaNumber: json['va_number'] ?? '',
      expiredAt: DateTime.parse(
        json['expired_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
