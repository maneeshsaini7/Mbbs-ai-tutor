import '../models/subject.dart';
import '../models/topic.dart';
import '../models/user_profile.dart';
import '../repositories/subject_repository.dart';
import 'mock_data.dart';

/// Mock implementation used until Phase 4 wires a real Firestore repository.
/// The artificial delay mimics network latency so loading states in the UI
/// are exercised even in Phase 1.
class MockSubjectRepository implements SubjectRepository {
  @override
  Future<UserProfile> getCurrentUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.userProfile;
  }

  @override
  Future<List<Subject>> getSubjects() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.subjects;
  }

  @override
  Future<List<Topic>> getRecentlyStudiedTopics({int limit = 5}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.recentTopics.take(limit).toList();
  }

  @override
  Future<List<Topic>> getWeakTopics({int limit = 5}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.weakTopics.take(limit).toList();
  }
}
