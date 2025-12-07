import 'package:flutter/material.dart';
import 'package:prime_work/core/theme/app_colors.dart';

class ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color color;

  const ActivityItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
        Text(
          time,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textTertiary,
              ),
        ),
      ],
    );
  }
}
