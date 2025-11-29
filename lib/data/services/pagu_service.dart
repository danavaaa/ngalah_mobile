import 'dart:async';

import '../models/pagu_item.dart';

class PaguService {
  Future<List<PaguItem>> fetchPagu() async {
    await Future.delayed(const Duration(milliseconds: 500));

    // DUMMY DATA
    return [
      PaguItem(
        id: 'p1',
        bulanLabel: 'Juli 2025',
        jatuhTempo: DateTime(2025, 7, 10),
        nominal: 450000,
        sudahLunas: true,
      ),
      PaguItem(
        id: 'p2',
        bulanLabel: 'Agustus 2025',
        jatuhTempo: DateTime(2025, 8, 10),
        nominal: 505000,
        sudahLunas: true,
      ),
      PaguItem(
        id: 'p3',
        bulanLabel: 'September 2025',
        jatuhTempo: DateTime(2025, 9, 10),
        nominal: 450000,
        sudahLunas: true,
      ),
      PaguItem(
        id: 'p4',
        bulanLabel: 'Oktober 2025',
        jatuhTempo: DateTime(2025, 10, 10),
        nominal: 450000,
        sudahLunas: true,
      ),
      PaguItem(
        id: 'p5',
        bulanLabel: 'November 2025',
        jatuhTempo: DateTime(2025, 11, 10),
        nominal: 450000,
        sudahLunas: true,
      ),
      PaguItem(
        id: 'p6',
        bulanLabel: 'Desember 2025',
        jatuhTempo: DateTime(2025, 12, 10),
        nominal: 450000,
        sudahLunas: true,
      ),
      PaguItem(
        id: 'p7',
        bulanLabel: 'Januari 2026',
        jatuhTempo: DateTime(2026, 1, 10),
        nominal: 520000,
        sudahLunas: false,
      ),
      PaguItem(
        id: 'p8',
        bulanLabel: 'Februari 2026',
        jatuhTempo: DateTime(2026, 2, 10),
        nominal: 450000,
        sudahLunas: false,
      ),
    ];
  }
}
