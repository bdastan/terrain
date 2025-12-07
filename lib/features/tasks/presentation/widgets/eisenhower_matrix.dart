import 'package:flutter/material.dart';
import 'package:prime_work/core/theme/app_colors.dart';

class EisenhowerMatrix extends StatelessWidget {
  const EisenhowerMatrix({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Row: Urgent & Important | Important but not urgent
        Row(
          children: [
            Expanded(
              child: _buildQuadrant(
                context,
                'Urgent & Important',
                'À FAIRE MAINTENANT',
                AppColors.urgentImportant,
                3,
                Icons.flash_on,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuadrant(
                context,
                'Important',
                'PLANIFIER',
                AppColors.notUrgentImportant,
                2,
                Icons.schedule,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Bottom Row: Urgent but not important | Neither urgent nor important
        Row(
          children: [
            Expanded(
              child: _buildQuadrant(
                context,
                'Urgent',
                'DÉLÉGUER',
                AppColors.urgentNotImportant,
                1,
                Icons.people_outline,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuadrant(
                context,
                'Autres',
                'ÉLIMINER',
                AppColors.notUrgentNotImportant,
                0,
                Icons.delete_outline,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuadrant(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
    int taskCount,
    IconData icon,
  ) {
    return InkWell(
      onTap: () {
        // TODO: Navigate to quadrant tasks
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color,
              color.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 28,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$taskCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Voir les tâches',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white.withOpacity(0.9),
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
