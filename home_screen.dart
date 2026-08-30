import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/section_header.dart';
import '../../../data/models/study_task.dart';
import '../../../data/models/subject.dart';
import '../../../data/models/topic.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/repositories/study_plan_repository.dart';
import '../../../data/repositories/subject_repository.dart';
import '../widgets/continue_studying_card.dart';
import '../widgets/greeting_header.dart';
import '../widgets/prep_summary_card.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/topic_list_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<_HomeData> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadHomeData();
  }

  Future<_HomeData> _loadHomeData() async {
    final subjectRepo = context.read<SubjectRepository>();
    final planRepo = context.read<StudyPlanRepository>();

    final results = await Future.wait([
      subjectRepo.getCurrentUserProfile(),
      subjectRepo.getSubjects(),
      subjectRepo.getRecentlyStudiedTopics(limit: 3),
      subjectRepo.getWeakTopics(limit: 3),
      planRepo.getTodaysTask(),
    ]);

    return _HomeData(
      profile: results[0] as UserProfile,
      subjects: results[1] as List<Subject>,
      recentTopics: results[2] as List<Topic>,
      weakTopics: results[3] as List<Topic>,
      todaysTask: results[4] as StudyTask?,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<_HomeData>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return Center(
                child: Text(
                  'Could not load your dashboard. Pull to refresh.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }

            final data = snapshot.data!;

            return RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                children: [
                  GreetingHeader(
                    name: data.profile.name,
                    mbbsYear: '${data.profile.mbbsYear} · ${data.profile.university}',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PrepSummaryCard(
                    streakDays: data.profile.studyStreakDays,
                    overallPercent: data.profile.overallPreparationPercent,
                  ),
                  if (data.todaysTask != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    ContinueStudyingCard(
                      task: data.todaysTask!,
                      onContinue: () => context.go('/ai-tutor'),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  const SectionHeader(title: 'Quick actions'),
                  const SizedBox(height: AppSpacing.md),
                  QuickActionsGrid(
                    onActionTap: (action) => context.go(action.route),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SectionHeader(
                    title: 'Recently studied',
                    actionLabel: data.recentTopics.isEmpty ? null : 'See all',
                    onAction: () => context.go('/subjects'),
                  ),
                  if (data.recentTopics.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: Text(
                        'Nothing studied yet — start with a subject or ask the AI tutor.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  else
                    ...data.recentTopics.map(
                      (t) => TopicListTile(topic: t, onTap: () => context.go('/subjects')),
                    ),
                  const SizedBox(height: AppSpacing.lg),
                  SectionHeader(
                    title: 'Weak topics',
                    actionLabel: data.weakTopics.isEmpty ? null : 'Practice now',
                    onAction: () => context.go('/practice'),
                  ),
                  if (data.weakTopics.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: Text(
                        'No weak topics flagged yet — keep practicing MCQs to build this.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  else
                    ...data.weakTopics.map(
                      (t) => TopicListTile(topic: t, onTap: () => context.go('/practice')),
                    ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HomeData {
  final UserProfile profile;
  final List<Subject> subjects;
  final List<Topic> recentTopics;
  final List<Topic> weakTopics;
  final StudyTask? todaysTask;

  _HomeData({
    required this.profile,
    required this.subjects,
    required this.recentTopics,
    required this.weakTopics,
    required this.todaysTask,
  });
}
