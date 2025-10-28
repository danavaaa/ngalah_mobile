class Announcement {
  final String title;
  final String greeting;
  final DateTime date;

  Announcement({
    required this.title,
    required this.greeting,
    required this.date,
  });

  factory Announcement.fromJson(Map<String, dynamic> j) => Announcement(
    title: j['title'] ?? '',
    greeting: j['greeting'] ?? '',
    date: DateTime.tryParse(j['date'] ?? '') ?? DateTime.now(),
  );
}
