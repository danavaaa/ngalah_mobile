class UptTagihan {
  final String id;
  final String keterangan;
  final String groupTagihan; // contoh: 2025-07
  final DateTime periodeTagihan; // 2025-07-01
  final DateTime jatuhTempo; // aturan: tgl 10 dari periode
  final int debet;
  final int bayar;

  const UptTagihan({
    required this.id,
    required this.keterangan,
    required this.groupTagihan,
    required this.periodeTagihan,
    required this.jatuhTempo,
    required this.debet,
    required this.bayar,
  });
  // hitung sisa tagihan
  int get sisa => (debet - bayar) < 0 ? 0 : (debet - bayar);
  bool get sudahLunas => bayar >= debet;
  // cek apakah sudah jatuh tempo
  bool isJatuhTempo(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(jatuhTempo.year, jatuhTempo.month, jatuhTempo.day);
    return !due.isAfter(today); //  jatuh tempo <= hari ini
  }

  // label bulan periode tagihan
  String get bulanLabel {
    const m = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${m[periodeTagihan.month - 1]} ${periodeTagihan.year}';
  }

  // cek apakah perlu ditampilkan peringatan jatuh tempo
  bool get isWarning {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(jatuhTempo.year, jatuhTempo.month, jatuhTempo.day);
    // hanya tampilkan peringatan jika sudah jatuh tempo dan sisa tagihan > 0
    return !due.isAfter(today) && sisa > 0;
  }

  // label jatuh tempo
  String get jatuhTempoLabel {
    final day = jatuhTempo.day.toString().padLeft(2, '0');
    const m = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return 'Jatuh tempo $day ${m[jatuhTempo.month - 1]} ${jatuhTempo.year}';
  }
}
