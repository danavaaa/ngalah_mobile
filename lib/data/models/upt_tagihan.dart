class UptTagihan {
  final String id;
  final String bulanLabel; // contoh: "Juli 2024"
  final DateTime jatuhTempo; // contoh: 2025-06-10
  final int nominal; // rupiah tanpa titik

  const UptTagihan({
    required this.id,
    required this.bulanLabel,
    required this.jatuhTempo,
    required this.nominal,
  });

  /// true = bar merah/pink (sudah lewat jatuh tempo)
  bool get isWarning {
    final now = DateTime.now();
    final due = DateTime(jatuhTempo.year, jatuhTempo.month, jatuhTempo.day);

    return now.isAfter(due);
  }

  /// Contoh label: "Jatuh tempo 10 Agustus 2024"
  String get jatuhTempoLabel {
    const bulan = [
      '',
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

    final d = jatuhTempo.day;
    final m = bulan[jatuhTempo.month];
    final y = jatuhTempo.year;

    return 'Jatuh tempo $d $m $y';
  }
}
