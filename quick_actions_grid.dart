import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';

class QuickAction {
  final String label;
  final IconData icon;
  final Color color;
  final String route;

  const QuickAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.route,
  });
}

// Routes here point at the Phase 1 tab roots. Once Phases 6-10 add the real
// sub-routes (e.g. '/practice/mcq'), update these six `route` values to the
// specific sub-route — the grid/UI code itself won't need to change.
const quickActions = <QuickAction>[
  QuickAction(
    label: 'Ask AI',
    icon: Icons.auto_awesome_rounded,
    color: AppColors.accentLavender,
    route: '/ai-tutor',
  ),
  QuickAction(
    label: 'Generate MCQ',
    icon: Icons.fact_check_rounded,
    color: AppColors.primary,
    route: '/practice',
  ),
  QuickAction(
    label: 'Upload PDF',
    icon: Icons.upload_file_rounded,
    color: AppColors.accentAmber,
    route: '/ai-tutor',
  ),
  QuickAction(
    label: 'Flashcards',
    icon: Icons.style_rounded,
    color: AppColors.accentCoral,
    route: '/practice',
  ),
  QuickAction(
    label: 'PYQs',
    icon: Icons.history_edu_rounded,
    color: AppColors.primaryDark,
    route: '/practice',
  ),
  QuickAction(
    label: 'Study Planner',
    icon: Icons.event_note_rounded,
    color: AppColors.accentLavender,
    route: '/profile',
  ),
];

class QuickActionsGrid extends StatelessWidget {
  final void Function(QuickAction action) onActionTap;

  const QuickActionsGrid({super.key, required this.onActionTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: quickActions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        final action = quickActions[index];
        return AppCard(
          padding: const EdgeInsets.all(12),
          onTap: () => onActionTap(action),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: action.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(action.icon, color: action.color, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                action.label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                maxLines: 2,
              ),
            ],
          ),
        );
      },
    );
  }
}
