import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:prime_work/core/theme/app_colors.dart';
import 'package:prime_work/features/crm/presentation/widgets/team_member_card.dart';

class CrmTeamPage extends StatefulWidget {
  const CrmTeamPage({super.key});

  @override
  State<CrmTeamPage> createState() => _CrmTeamPageState();
}

class _CrmTeamPageState extends State<CrmTeamPage> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Équipe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Team Overview
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.successGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Vue d\'ensemble',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildOverviewStat(
                        'Membres',
                        '8',
                        Icons.people_outline,
                      ),
                    ),
                    Expanded(
                      child: _buildOverviewStat(
                        'VP Équipe',
                        '3,450',
                        Icons.stars_outlined,
                      ),
                    ),
                    Expanded(
                      child: _buildOverviewStat(
                        'Actifs',
                        '6',
                        Icons.trending_up_outlined,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
              .animate()
              .fadeIn()
              .slideY(begin: -0.2, end: 0),

          const SizedBox(height: 24),

          Text(
            'Membres de l\'équipe',
            style: Theme.of(context).textTheme.titleLarge,
          )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 100)),

          const SizedBox(height: 16),

          // Team Members
          TeamMemberCard(
            name: 'Claire Dubois',
            level: 'Superviseur',
            levelColor: AppColors.accent,
            volumePoints: 1250,
            teamSize: 3,
            lastActivity: 'Il y a 1 jour',
            status: 'Actif',
            statusColor: AppColors.success,
          )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 200))
              .slideX(begin: -0.2, end: 0),

          const SizedBox(height: 12),

          TeamMemberCard(
            name: 'Marc Lefebvre',
            level: 'Distributeur',
            levelColor: AppColors.primary,
            volumePoints: 850,
            teamSize: 2,
            lastActivity: 'Il y a 2 jours',
            status: 'Actif',
            statusColor: AppColors.success,
          )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 300))
              .slideX(begin: -0.2, end: 0),

          const SizedBox(height: 12),

          TeamMemberCard(
            name: 'Sophie Martin',
            level: 'Distributeur',
            levelColor: AppColors.primary,
            volumePoints: 720,
            teamSize: 1,
            lastActivity: 'Il y a 3 jours',
            status: 'Actif',
            statusColor: AppColors.success,
          )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 400))
              .slideX(begin: -0.2, end: 0),

          const SizedBox(height: 12),

          TeamMemberCard(
            name: 'Thomas Bernard',
            level: 'Distributeur',
            levelColor: AppColors.primary,
            volumePoints: 380,
            teamSize: 0,
            lastActivity: 'Il y a 1 semaine',
            status: 'Modéré',
            statusColor: AppColors.warning,
          )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 500))
              .slideX(begin: -0.2, end: 0),

          const SizedBox(height: 12),

          TeamMemberCard(
            name: 'Julie Moreau',
            level: 'Nouveau',
            levelColor: AppColors.info,
            volumePoints: 120,
            teamSize: 0,
            lastActivity: 'Il y a 2 semaines',
            status: 'Inactif',
            statusColor: AppColors.textSecondary,
          )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 600))
              .slideX(begin: -0.2, end: 0),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Add team member
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Ajouter'),
      )
          .animate()
          .scale(delay: const Duration(milliseconds: 300)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/crm/clients');
              break;
            case 2:
              context.go('/tasks');
              break;
            case 3:
              context.go('/tracker');
              break;
            case 4:
              // TODO: Navigate to profile
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'CRM',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_outlined),
            activeIcon: Icon(Icons.task),
            label: 'Tâches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Tracker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
