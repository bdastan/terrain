import 'package:flutter/material.dart';
import 'package:prime_work/core/theme/app_colors.dart';

class DailyTrackerCard extends StatelessWidget {
  final String title;
  final int goal;
  final int current;
  final IconData icon;
  final Color color;

  const DailyTrackerCard({
    super.key,
    required this.title,
    required this.goal,
    required this.current,
    required this.icon,
    required this.color,
  });

  double get progress => (current / goal).clamp(0.0, 1.0);
  bool get isCompleted => current >= goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? AppColors.success.withOpacity(0.3)
              : AppColors.border,
          width: isCompleted ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
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
                      'Objectif: $goal',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 28,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$current / $goal',
                      style: TextStyle(
                        color: color,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: color.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () {
                  // TODO: Increment counter
                },
                icon: const Icon(Icons.add_circle_outline),
                color: color,
                iconSize: 32,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
