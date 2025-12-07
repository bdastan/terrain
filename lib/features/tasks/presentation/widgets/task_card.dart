import 'package:flutter/material.dart';
import 'package:prime_work/core/theme/app_colors.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String? description;
  final String? dueDate;
  final String priority;
  final bool isCompleted;
  final VoidCallback? onTap;
  final VoidCallback? onToggleComplete;

  const TaskCard({
    super.key,
    required this.title,
    this.description,
    this.dueDate,
    required this.priority,
    required this.isCompleted,
    this.onTap,
    this.onToggleComplete,
  });

  Color get _priorityColor {
    switch (priority) {
      case 'urgent_important':
        return AppColors.urgentImportant;
      case 'not_urgent_important':
        return AppColors.notUrgentImportant;
      case 'urgent_not_important':
        return AppColors.urgentNotImportant;
      case 'not_urgent_not_important':
        return AppColors.notUrgentNotImportant;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _priorityColor.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _priorityColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox
                Checkbox(
                  value: isCompleted,
                  onChanged: (value) {
                    onToggleComplete?.call();
                  },
                  activeColor: _priorityColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                      ),
                      if (description != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          description!,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                    decoration: isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                        ),
                      ],
                      if (dueDate != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: _priorityColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              dueDate!,
                              style: TextStyle(
                                fontSize: 12,
                                color: _priorityColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Priority Indicator
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _priorityColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
