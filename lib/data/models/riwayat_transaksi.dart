import 'package:flutter/material.dart';

// Jenis transaksi
enum TransactionType { isiSaldo, bayarUpt, uangJajan, tarikTunai }

// Model 1 baris riwayat transaksi
class RiwayatTransaksi {
  final String id;
  final DateTime tanggal;
  final String title; // contoh: "Isi Saldo"
  final String subtitle; // contoh: "Dari Bank BSI"
  final int nominal; // dalam rupiah (tanpa titik)
  final TransactionType type;
  final bool isCredit; // true = uang masuk, false = keluar

  const RiwayatTransaksi({
    required this.id,
    required this.tanggal,
    required this.title,
    required this.subtitle,
    required this.nominal,
    required this.type,
    required this.isCredit,
  });

  Color get amountColor => isCredit ? Colors.green : Colors.red;

  /// Icon sesuai jenis transaksi
  IconData get icon {
    switch (type) {
      case TransactionType.isiSaldo:
        return Icons.account_balance_wallet;
      case TransactionType.bayarUpt:
        return Icons.attach_money;
      case TransactionType.uangJajan:
        return Icons.restaurant_menu;
      case TransactionType.tarikTunai:
        return Icons.money_off;
    }
  }

  /// Label pendek jenis transaksi (untuk filter)
  String get typeLabel {
    switch (type) {
      case TransactionType.isiSaldo:
        return 'Isi Saldo';
      case TransactionType.bayarUpt:
        return 'Pembayaran UPT';
      case TransactionType.uangJajan:
        return 'Uang Jajan';
      case TransactionType.tarikTunai:
        return 'Penarikan Tunai';
    }
  }
}
