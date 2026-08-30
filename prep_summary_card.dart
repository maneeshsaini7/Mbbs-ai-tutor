import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/stat_pill.dart';

class PrepSummaryCard extends StatelessWidget {
  final int streakDays;
  final double overallPercent;

  const PrepSummaryCard({
    super.key,
    required this.streakDays,
    required this.overallPercent,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatPill(
                icon: Icons.local_fire_department_rounded,
                label: '$streakDays-day streak',
                color: AppColors.accentAmber,
              ),
              const SizedBox(width: 8),
              StatPill(
                icon: Icons.trending_up_rounded,
                label: 'Overall ${overallPercent.round()}%',
                color: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: overallPercent / 100,
              minHeight: 10,
              backgroundColor: Theme.of(context).dividerColor,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Overall preparation across your subjects',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
