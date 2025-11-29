class PaguItem {
  final String id;
  final String bulanLabel; // contoh: "Juli 2025"
  final DateTime jatuhTempo; // contoh: 2025-07-10
  final int nominal; // dalam rupiah
  final bool sudahLunas; // true = kartu hijau, false = abu-abu

  const PaguItem({
    required this.id,
    required this.bulanLabel,
    required this.jatuhTempo,
    required this.nominal,
    required this.sudahLunas,
  });

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
