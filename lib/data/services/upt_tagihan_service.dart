import 'package:dio/dio.dart';
import '../models/upt_tagihan.dart';

class UptTagihanService {
  final Dio dio;
  UptTagihanService(this.dio);
  // ambil tagihan UPT dari personDetails
  Future<List<UptTagihan>> fetchUptTagihan({required String idperson}) async {
    final res = await dio.post(
      '/sandbox/personDetails',
      data: {'idperson': idperson},
    );
    // cek response
    final body = res.data;
    if (body is! Map || body['success'] != true) {
      throw Exception('personDetails gagal');
    }
    // ambil paguList
    final paguList = body['paguList'];
    if (paguList is! Map || paguList['success'] != true) return [];

    final List raw = (paguList['data'] ?? []) as List;

    // UPT = cicilan == null
    final uptRows = raw.where((e) => e['cicilan'] == null);
    // mapping ke UptTagihan
    final items =
        uptRows.map((e) {
          final periode = DateTime.parse(e['periode_tagihan']); // yyyy-MM-01
          return UptTagihan(
            id: (e['id'] ?? '').toString(),
            keterangan: (e['keterangan'] ?? '').toString(),
            groupTagihan: (e['group_tagihan'] ?? '').toString(),
            periodeTagihan: periode,
            jatuhTempo: DateTime(periode.year, periode.month, 10),
            debet: _toInt(e['debet']),
            bayar: _toInt(e['bayar']),
          );
        }).toList();

    // yang ditampilkan di Bayar Tagihan: hanya yang belum lunas (sisa > 0)
    final unpaid = items.where((t) => t.sisa > 0).toList();
    // sort by jatuhTempo ascending
    unpaid.sort((a, b) => a.jatuhTempo.compareTo(b.jatuhTempo));
    return unpaid;
  }

  // konversi dynamic ke int
  int _toInt(dynamic v) => (double.tryParse(v.toString()) ?? 0).round();
}
