class Subject {
  final String id;
  final String name;
  final double masteryPercent; // 0-100
  final int topicCount;

  const Subject({
    required this.id,
    required this.name,
    required this.masteryPercent,
    required this.topicCount,
  });
}
