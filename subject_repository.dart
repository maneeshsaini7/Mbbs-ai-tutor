import '../models/subject.dart';
import '../models/topic.dart';
import '../models/user_profile.dart';

/// Abstract interface. Screens/view-models depend only on this.
/// Phase 1 binds it to [MockSubjectRepository]; a later phase binds it to a
/// Firestore-backed implementation without any screen changing.
abstract class SubjectRepository {
  Future<UserProfile> getCurrentUserProfile();
  Future<List<Subject>> getSubjects();
  Future<List<Topic>> getRecentlyStudiedTopics({int limit = 5});
  Future<List<Topic>> getWeakTopics({int limit = 5});
}
