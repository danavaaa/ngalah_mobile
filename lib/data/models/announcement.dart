class Announcement {
  final String title;
  final String greeting;
  final DateTime date;

  Announcement({
    required this.title, // Judul pengumuman
    required this.greeting, // Salam pembuka
    required this.date, // Tanggal pengumuman
  });

  factory Announcement.fromJson(Map<String, dynamic> j) => Announcement(
    title: j['title'] ?? '',
    greeting: j['greeting'] ?? '', // Salam pembuka
    date:
        DateTime.tryParse(j['date'] ?? '') ??
        DateTime.now(), // Tanggal pengumuman
  );
}
