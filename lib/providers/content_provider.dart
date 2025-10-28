import 'package:flutter/foundation.dart';
import '../data/models/announcement.dart';
import '../data/repositories/content_repository.dart';

class ContentProvider with ChangeNotifier {
  final _repo = ContentRepository();

  Announcement? announcement;
  bool loading = false;
  String? error;

  Future<void> loadAnnouncement() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      announcement = await _repo.fetchAnnouncement();
    } catch (e) {
      error = 'Gagal memuat pengumuman';
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
