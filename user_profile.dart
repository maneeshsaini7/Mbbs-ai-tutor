class UserProfile {
  final String uid;
  final String name;
  final String mbbsYear; // e.g. "3rd Year"
  final String university; // e.g. "RUHS"
  final List<String> subjects;
  final bool darkMode;
  final int studyStreakDays;
  final double overallPreparationPercent; // 0-100

  const UserProfile({
    required this.uid,
    required this.name,
    required this.mbbsYear,
    required this.university,
    required this.subjects,
    required this.darkMode,
    required this.studyStreakDays,
    required this.overallPreparationPercent,
  });
}
