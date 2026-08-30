import '../models/study_task.dart';

/// Abstract interface for the Study Planner (implemented for real in Phase 10).
abstract class StudyPlanRepository {
  Future<StudyTask?> getTodaysTask();
  Future<List<StudyTask>> getUpcomingTasks({int limit = 5});
}
