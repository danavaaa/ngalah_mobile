import 'dart:async';
import '../models/riwayat_transaksi.dart';

class RiwayatTransaksiService {
  /// Fungsi ini nantinya memanggil API
  Future<List<RiwayatTransaksi>> fetchRiwayat() async {
    // simulasi loading API
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      RiwayatTransaksi(
        id: '1',
        tanggal: DateTime(2024, 8, 15),
        title: 'Isi Saldo',
        subtitle: 'Dari Bank BSI',
        nominal: 150000,
        type: TransactionType.isiSaldo,
        isCredit: true, // uang masuk
      ),
      RiwayatTransaksi(
        id: '2',
        tanggal: DateTime(2024, 8, 15),
        title: 'Pembayaran UPT Juni',
        subtitle: 'Dari Saldo Ngalah Mobile',
        nominal: 300000,
        type: TransactionType.bayarUpt,
        isCredit: false, // uang keluar
      ),
      RiwayatTransaksi(
        id: '3',
        tanggal: DateTime(2024, 8, 15),
        title: 'Pembayaran Uang Jajan',
        subtitle: 'Dari Kantin Asrama A / Duta Swalayan',
        nominal: 25000,
        type: TransactionType.uangJajan,
        isCredit: false,
      ),
      RiwayatTransaksi(
        id: '4',
        tanggal: DateTime(2024, 7, 15),
        title: 'Penarikan Tunai',
        subtitle: 'Dari Loket (Nama Petugas)',
        nominal: 50000,
        type: TransactionType.tarikTunai,
        isCredit: false,
      ),
    ];
  }
}
