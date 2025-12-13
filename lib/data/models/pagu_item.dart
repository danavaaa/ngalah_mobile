class PaguItem {
  final String id;
  final String bulanLabel;
  final DateTime jatuhTempo;

  /// dari API (hasil agregasi)
  final int tagihan; // total debet dalam 1 group_tagihan (bulan tsb)
  final int terbayar; // total bayar dalam 1 group_tagihan

  const PaguItem({
    required this.id,
    required this.bulanLabel,
    required this.jatuhTempo,
    required this.tagihan,
    required this.terbayar,
  });
  // lunas jika terbayar >= tagihan
  bool get sudahLunas => terbayar >= tagihan;
  int get sisa =>
      (tagihan - terbayar) < 0 ? 0 : (tagihan - terbayar); // sisa tagihan
  // label jatuh tempo dalam format "Jatuh tempo DD MMMM YYYY"
  String get jatuhTempoLabel {
    final day = jatuhTempo.day.toString().padLeft(2, '0');
    final monthNames = [
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
    final month = monthNames[jatuhTempo.month - 1]; // bulan 1-12
    final year = jatuhTempo.year; // tahun
    return 'Jatuh tempo $day $month $year';
  }

  // apakah sudah jatuh tempo dibandingkan dengan tanggal sekarang
  bool isJatuhTempo(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(jatuhTempo.year, jatuhTempo.month, jatuhTempo.day);
    return !due.isAfter(today); // due <= today
  }

  bool get belumLunas => !sudahLunas;
}
