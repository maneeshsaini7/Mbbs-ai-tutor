class Topic {
  final String id;
  final String subjectId;
  final String subjectName;
  final String title;
  final double masteryPercent; // 0-100
  final bool isWeak;
  final DateTime? lastStudiedAt;

  const Topic({
    required this.id,
    required this.subjectId,
    required this.subjectName,
    required this.title,
    required this.masteryPercent,
    required this.isWeak,
    this.lastStudiedAt,
  });
}
