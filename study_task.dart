class StudyTask {
  final String id;
  final DateTime date;
  final String subjectName;
  final String topicTitle;
  final int durationMin;
  final bool done;
  final bool isRevision;

  const StudyTask({
    required this.id,
    required this.date,
    required this.subjectName,
    required this.topicTitle,
    required this.durationMin,
    required this.done,
    required this.isRevision,
  });
}
