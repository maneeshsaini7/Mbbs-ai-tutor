import 'package:flutter/material.dart';

import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../data/models/study_task.dart';

class ContinueStudyingCard extends StatelessWidget {
  final StudyTask task;
  final VoidCallback onContinue;

  const ContinueStudyingCard({
    super.key,
    required this.task,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.play_arrow_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Continue studying',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  '${task.subjectName} · ${task.topicTitle}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${task.durationMin} min planned today',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          PrimaryButton(label: 'Go', onPressed: onContinue),
        ],
      ),
    );
  }
}
