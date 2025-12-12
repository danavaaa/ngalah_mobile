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

  bool get sudahLunas => terbayar >= tagihan;
  int get sisa => (tagihan - terbayar) < 0 ? 0 : (tagihan - terbayar);

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
    final month = monthNames[jatuhTempo.month - 1];
    final year = jatuhTempo.year;
    return 'Jatuh tempo $day $month $year';
  }
}
