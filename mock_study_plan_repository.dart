import '../models/study_task.dart';
import '../repositories/study_plan_repository.dart';
import 'mock_data.dart';

class MockStudyPlanRepository implements StudyPlanRepository {
  @override
  Future<StudyTask?> getTodaysTask() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.todaysTask;
  }

  @override
  Future<List<StudyTask>> getUpcomingTasks({int limit = 5}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [MockData.todaysTask];
  }
}
