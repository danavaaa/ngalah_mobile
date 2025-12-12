import 'package:dio/dio.dart';
import '../models/pagu_item.dart';

class PaguService {
  final Dio dio;
  PaguService(this.dio);

  Future<List<PaguItem>> fetchPagu({required String idperson}) async {
    final res = await dio.post(
      '/sandbox/personDetails',
      data: {'idperson': idperson},
    );

    final body = res.data;
    if (body is! Map || body['success'] != true) {
      throw Exception('personDetails gagal');
    }

    final paguList = body['paguList'];
    if (paguList is! Map || paguList['success'] != true) {
      return [];
    }

    final List rawList = paguList['data'] ?? [];

    /// grouping per bulan (group_tagihan)
    final Map<String, _Agg> grouped = {};

    for (final row in rawList) {
      final group = row['group_tagihan'];
      final periode = row['periode_tagihan'];

      if (group == null || periode == null) continue;

      final debet = _toInt(row['debet']);
      final bayar = _toInt(row['bayar']);

      grouped.putIfAbsent(group, () => _Agg(group, periode));
      grouped[group]!.debet += debet;
      grouped[group]!.bayar += bayar;
    }

    final items =
        grouped.values.map((g) {
          final dt = DateTime.parse(g.periode); // yyyy-MM-01
          return PaguItem(
            id: g.group,
            bulanLabel: _bulanLabel(dt),
            jatuhTempo: DateTime(dt.year, dt.month, 10),
            tagihan: g.debet,
            terbayar: g.bayar,
          );
        }).toList();

    items.sort((a, b) => a.jatuhTempo.compareTo(b.jatuhTempo));
    return items;
  }

  int _toInt(dynamic v) => (double.tryParse(v.toString()) ?? 0).round();

  String _bulanLabel(DateTime d) {
    const m = [
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
    return '${m[d.month - 1]} ${d.year}';
  }
}

class _Agg {
  final String group;
  final String periode;
  int debet = 0;
  int bayar = 0;
  _Agg(this.group, this.periode);
}
