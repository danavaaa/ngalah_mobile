import 'dart:async';

import '../models/non_upt_tagihan.dart';

class NonUptTagihanService {
  Future<List<NonUptTagihan>> fetchNonUptTagihan() async {
    // simulasi delay network
    await Future.delayed(const Duration(milliseconds: 600));

    return [
      NonUptTagihan(
        id: 'uts1',
        title: 'UTS 1',
        tanggal: DateTime(2025, 9, 1),
        nominal: 50000,
        isCicilan: false,
      ),
      NonUptTagihan(
        id: 'uas1',
        title: 'UAS 1',
        tanggal: DateTime(2025, 10, 1),
        nominal: 50000,
        isCicilan: false,
      ),
      NonUptTagihan(
        id: 'uts2',
        title: 'UTS 2',
        tanggal: DateTime(2025, 11, 1),
        nominal: 50000,
        isCicilan: false,
      ),
      NonUptTagihan(
        id: 'uas2',
        title: 'UAS 2',
        tanggal: DateTime(2025, 12, 1),
        nominal: 50000,
        isCicilan: false,
      ),

      // TAGIHAN CICILAN
      NonUptTagihan(
        id: 'lks1',
        title: 'LKS 1',
        tanggal: DateTime(2024, 12, 10),
        nominal: 500000,
        isCicilan: true,
      ),
    ];
  }
}
