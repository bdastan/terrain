import 'package:flutter/material.dart';
import 'package:prime_work/core/theme/app_colors.dart';

class TeamMemberCard extends StatelessWidget {
  final String name;
  final String level;
  final Color levelColor;
  final int volumePoints;
  final int teamSize;
  final String lastActivity;
  final String status;
  final Color statusColor;

  const TeamMemberCard({
    super.key,
    required this.name,
    required this.level,
    required this.levelColor,
    required this.volumePoints,
    required this.teamSize,
    required this.lastActivity,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
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
              // Avatar
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      levelColor,
                      levelColor.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Name & Level
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: levelColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            level,
                            style: TextStyle(
                              color: levelColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.visibility_outlined, size: 20),
                        SizedBox(width: 12),
                        Text('Voir le profil'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'message',
                    child: Row(
                      children: [
                        Icon(Icons.message_outlined, size: 20),
                        SizedBox(width: 12),
                        Text('Envoyer un message'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'call',
                    child: Row(
                      children: [
                        Icon(Icons.phone_outlined, size: 20),
                        SizedBox(width: 12),
                        Text('Appeler'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStat(
                  context,
                  'VP',
                  volumePoints.toString(),
                  Icons.stars_outlined,
                  AppColors.accent,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.border,
              ),
              Expanded(
                child: _buildStat(
                  context,
                  'Équipe',
                  teamSize.toString(),
                  Icons.people_outline,
                  AppColors.secondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),

          // Last Activity
          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 14,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: 6),
              Text(
                'Dernière activité: $lastActivity',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textTertiary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }
}
