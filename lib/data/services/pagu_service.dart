import 'package:dio/dio.dart';
import '../models/pagu_item.dart';

// Service Pagu
class PaguService {
  final Dio dio;
  PaguService(this.dio);

  Future<List<PaguItem>> fetchPagu({required String idperson}) async {
    // idperson dari Sisda
    final res = await dio.post(
      // POST request
      '/sandbox/personDetails',
      data: {'idperson': idperson},
    );

    final body = res.data; // response body
    if (body is! Map || body['success'] != true) {
      // validasi response
      throw Exception('personDetails gagal'); // lempar error jika gagal
    }

    final paguList = body['paguList']; // ambil paguList dari response
    if (paguList is! Map || paguList['success'] != true) {
      // validasi paguList
      return []; // kembalikan list kosong jika tidak sukses
    }

    final List rawList = paguList['data'] ?? []; // ambil data list

    /// grouping per bulan (group_tagihan)
    final Map<String, _Agg> grouped = {};

    for (final row in rawList) {
      final group = row['group_tagihan'];
      final periode = row['periode_tagihan'];
      // lewati jika group atau periode null
      if (group == null || periode == null) continue;
      // ambil debet dan bayar sebagai int
      final debet = _toInt(row['debet']);
      final bayar = _toInt(row['bayar']);
      // inisialisasi grouping jika belum ada
      grouped.putIfAbsent(group, () => _Agg(group, periode));
      grouped[group]!.debet += debet;
      grouped[group]!.bayar += bayar;
    }
    // buat list PaguItem dari hasil grouping
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
    // urutkan berdasarkan jatuh tempo
    items.sort((a, b) => a.jatuhTempo.compareTo(b.jatuhTempo));
    return items;
  }

  // konversi dynamic ke int
  int _toInt(dynamic v) => (double.tryParse(v.toString()) ?? 0).round();
  // format label bulan
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
