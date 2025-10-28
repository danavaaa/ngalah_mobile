import '../models/announcement.dart';
import '../services/api_client.dart';

class ContentRepository {
  final _dio = ApiClient.I.dio;

  Future<Announcement> fetchAnnouncement() async {
    final res = await _dio.get('/v1/announcement');
    return Announcement.fromJson(res.data);
  }

  // TODO: tambah method untuk fitur PPDB/SISDA/Wawasan dll.
}
