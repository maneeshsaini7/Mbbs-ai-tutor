import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/services/ai_service.dart';
import '../data/mock/mock_study_plan_repository.dart';
import '../data/mock/mock_subject_repository.dart';
import '../data/repositories/study_plan_repository.dart';
import '../data/repositories/subject_repository.dart';
import 'routes.dart';
import 'theme/app_theme.dart';

/// Single place where interfaces are bound to concrete implementations.
///
/// Phase 1: everything binds to the Mock* implementations below.
/// Later phases replace exactly these lines (e.g.
/// `Provider<SubjectRepository>(create: (_) => FirestoreSubjectRepository())`)
/// — no screen or widget anywhere else in the app changes.
class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SubjectRepository>(create: (_) => MockSubjectRepository()),
        Provider<StudyPlanRepository>(create: (_) => MockStudyPlanRepository()),
        Provider<AiService>(create: (_) => MockAiService()),
      ],
      child: child,
    );
  }
}

class MbbsAiTutorApp extends StatelessWidget {
  const MbbsAiTutorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: MaterialApp.router(
        title: 'MBBS AI Tutor',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
      ),
    );
  }
}
