import '../models/subject.dart';
import '../models/topic.dart';
import '../models/user_profile.dart';
import '../models/study_task.dart';

/// Realistic seed data so every screen renders meaningfully without a
/// backend. Reused by Phase 2's other mock repositories — keep new mock
/// data here rather than scattering literals through screens.
class MockData {
  MockData._();

  static const userProfile = UserProfile(
    uid: 'mock-user-1',
    name: 'Mks',
    mbbsYear: '3rd Year',
    university: 'RUHS',
    subjects: ['Pathology', 'Pharmacology', 'Microbiology', 'Forensic Medicine', 'PSM'],
    darkMode: false,
    studyStreakDays: 6,
    overallPreparationPercent: 42,
  );

  static const subjects = <Subject>[
    Subject(id: 'path', name: 'Pathology', masteryPercent: 55, topicCount: 48),
    Subject(id: 'pharm', name: 'Pharmacology', masteryPercent: 38, topicCount: 52),
    Subject(id: 'micro', name: 'Microbiology', masteryPercent: 61, topicCount: 40),
    Subject(id: 'fmt', name: 'Forensic Medicine', masteryPercent: 29, topicCount: 30),
    Subject(id: 'psm', name: 'PSM', masteryPercent: 33, topicCount: 45),
  ];

  static final recentTopics = <Topic>[
    Topic(
      id: 't1',
      subjectId: 'path',
      subjectName: 'Pathology',
      title: 'Nephrotic Syndrome',
      masteryPercent: 70,
      isWeak: false,
      lastStudiedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Topic(
      id: 't2',
      subjectId: 'micro',
      subjectName: 'Microbiology',
      title: 'Mycobacterium Tuberculosis',
      masteryPercent: 64,
      isWeak: false,
      lastStudiedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Topic(
      id: 't3',
      subjectId: 'pharm',
      subjectName: 'Pharmacology',
      title: 'Antiarrhythmic Drugs',
      masteryPercent: 40,
      isWeak: true,
      lastStudiedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  static final weakTopics = <Topic>[
    Topic(
      id: 'w1',
      subjectId: 'fmt',
      subjectName: 'Forensic Medicine',
      title: 'Asphyxial Deaths',
      masteryPercent: 22,
      isWeak: true,
    ),
    Topic(
      id: 'w2',
      subjectId: 'pharm',
      subjectName: 'Pharmacology',
      title: 'Antiarrhythmic Drugs',
      masteryPercent: 40,
      isWeak: true,
    ),
    Topic(
      id: 'w3',
      subjectId: 'psm',
      subjectName: 'PSM',
      title: 'National Health Programs',
      masteryPercent: 31,
      isWeak: true,
    ),
  ];

  static final todaysTask = StudyTask(
    id: 'task-today',
    date: DateTime.now(),
    subjectName: 'Pharmacology',
    topicTitle: 'Antiarrhythmic Drugs',
    durationMin: 45,
    done: false,
    isRevision: false,
  );
}
