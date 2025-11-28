import 'package:flutter/material.dart';

/// Model 1 tagihan NON-UPT
class NonUptTagihan {
  final String id;
  final String title; // contoh: "UTS 1", "LKS 1"
  final DateTime tanggal; // tanggal penagihan / jatuh tempo
  final int nominal; // dalam rupiah
  final bool isCicilan; // false = Non Cicilan, true = Cicilan

  const NonUptTagihan({
    required this.id,
    required this.title,
    required this.tanggal,
    required this.nominal,
    required this.isCicilan,
  });

  /// Label subjudul di kartu
  /// - Non cicilan: "Tanggal Penagihan 01 September 2025"
  /// - Cicilan:     "Jatuh tempo 10 Desember 2024"
  String get subtitleLabel {
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

    final d = tanggal.day.toString().padLeft(2, '0');
    final m = bulan[tanggal.month];
    final y = tanggal.year;

    final prefix = isCicilan ? 'Jatuh tempo' : 'Tanggal Penagihan';
    return '$prefix $d $m $y';
  }

  Color get amountColor => Colors.black;
}
