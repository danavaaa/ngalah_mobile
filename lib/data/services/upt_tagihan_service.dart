import '../models/upt_tagihan.dart';

class UptTagihanService {
  Future<List<UptTagihan>> fetchUptTagihan() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return [
      // SUDAH LEWAT (harus MERAH)
      UptTagihan(
        id: '1',
        bulanLabel: 'Juli 2025',
        jatuhTempo: DateTime(2025, 7, 10), // lewat
        nominal: 600000,
      ),
      UptTagihan(
        id: '2',
        bulanLabel: 'Agustus 2025',
        jatuhTempo: DateTime(2025, 8, 10), // lewat
        nominal: 600000,
      ),

      // BELUM LEWAT (harus PUTIH)
      UptTagihan(
        id: '3',
        bulanLabel: 'Desember 2025',
        jatuhTempo: DateTime(2025, 12, 10), // BELUM lewat
        nominal: 600000,
      ),
      UptTagihan(
        id: '4',
        bulanLabel: 'Januari 2026',
        jatuhTempo: DateTime(2026, 1, 10), // BELUM lewat
        nominal: 600000,
      ),
    ];
  }
}
