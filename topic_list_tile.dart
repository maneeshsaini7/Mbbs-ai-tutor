import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../data/models/topic.dart';

class TopicListTile extends StatelessWidget {
  final Topic topic;
  final VoidCallback? onTap;

  const TopicListTile({super.key, required this.topic, this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = topic.isWeak ? AppColors.accentCoral : AppColors.primary;
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: color.withValues(alpha: 0.12),
        child: Text(
          '${topic.masteryPercent.round()}%',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
      title: Text(topic.title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(topic.subjectName, style: Theme.of(context).textTheme.bodyMedium),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}
