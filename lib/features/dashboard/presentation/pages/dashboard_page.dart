import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:prime_work/core/theme/app_colors.dart';
import 'package:prime_work/features/dashboard/presentation/widgets/dashboard_card.dart';
import 'package:prime_work/features/dashboard/presentation/widgets/stats_card.dart';
import 'package:prime_work/features/dashboard/presentation/widgets/quick_action_button.dart';
import 'package:prime_work/features/dashboard/presentation/widgets/activity_item.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bonjour,',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Jean Dupont 👋',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn()
                        .slideX(begin: -0.2, end: 0),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.notifications_outlined,
                            color: Colors.white),
                        onPressed: () {
                          // TODO: Navigate to notifications
                        },
                      ),
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 100))
                        .scale(),
                  ],
                ),

                const SizedBox(height: 24),

                // Trial Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.workspace_premium,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Période d\'essai',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '5 jours restants',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Navigate to subscription
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Passer Pro',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 200))
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 24),

                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        title: 'Clients',
                        value: '24',
                        icon: Icons.people_outline,
                        color: AppColors.primary,
                        trend: '+12%',
                        isPositive: true,
                      )
                          .animate()
                          .fadeIn(delay: const Duration(milliseconds: 300))
                          .slideY(begin: 0.2, end: 0),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatsCard(
                        title: 'Équipe',
                        value: '8',
                        icon: Icons.groups_outlined,
                        color: AppColors.secondary,
                        trend: '+2',
                        isPositive: true,
                      )
                          .animate()
                          .fadeIn(delay: const Duration(milliseconds: 400))
                          .slideY(begin: 0.2, end: 0),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        title: 'Points VP',
                        value: '1,240',
                        icon: Icons.stars_outlined,
                        color: AppColors.accent,
                        trend: '+180',
                        isPositive: true,
                      )
                          .animate()
                          .fadeIn(delay: const Duration(milliseconds: 500))
                          .slideY(begin: 0.2, end: 0),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatsCard(
                        title: 'Objectif',
                        value: '68%',
                        icon: Icons.trending_up_outlined,
                        color: AppColors.info,
                        trend: '32% restant',
                        isPositive: false,
                      )
                          .animate()
                          .fadeIn(delay: const Duration(milliseconds: 600))
                          .slideY(begin: 0.2, end: 0),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Quick Actions
                Text(
                  'Actions rapides',
                  style: Theme.of(context).textTheme.titleLarge,
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 700)),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: QuickActionButton(
                        icon: Icons.person_add_outlined,
                        label: 'Nouveau\nProspect',
                        color: AppColors.primary,
                        onTap: () {
                          context.go('/crm/clients');
                        },
                      )
                          .animate()
                          .fadeIn(delay: const Duration(milliseconds: 750))
                          .scale(begin: const Offset(0.8, 0.8)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: QuickActionButton(
                        icon: Icons.shopping_bag_outlined,
                        label: 'Nouvelle\nCommande',
                        color: AppColors.secondary,
                        onTap: () {
                          // TODO: Navigate to orders
                        },
                      )
                          .animate()
                          .fadeIn(delay: const Duration(milliseconds: 800))
                          .scale(begin: const Offset(0.8, 0.8)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: QuickActionButton(
                        icon: Icons.event_outlined,
                        label: 'Nouvel\nÉvénement',
                        color: AppColors.accent,
                        onTap: () {
                          // TODO: Navigate to events
                        },
                      )
                          .animate()
                          .fadeIn(delay: const Duration(milliseconds: 850))
                          .scale(begin: const Offset(0.8, 0.8)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: QuickActionButton(
                        icon: Icons.add_task_outlined,
                        label: 'Nouvelle\nTâche',
                        color: AppColors.info,
                        onTap: () {
                          context.go('/tasks');
                        },
                      )
                          .animate()
                          .fadeIn(delay: const Duration(milliseconds: 900))
                          .scale(begin: const Offset(0.8, 0.8)),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Recent Activity
                Text(
                  'Activité récente',
                  style: Theme.of(context).textTheme.titleLarge,
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 950)),

                const SizedBox(height: 16),

                DashboardCard(
                  child: Column(
                    children: [
                      ActivityItem(
                        icon: Icons.person_add_outlined,
                        title: 'Nouveau prospect ajouté',
                        subtitle: 'Marie Martin',
                        time: 'Il y a 2h',
                        color: AppColors.primary,
                      ),
                      const Divider(height: 24),
                      ActivityItem(
                        icon: Icons.shopping_bag_outlined,
                        title: 'Commande validée',
                        subtitle: '245€ - Paul Durand',
                        time: 'Il y a 5h',
                        color: AppColors.secondary,
                      ),
                      const Divider(height: 24),
                      ActivityItem(
                        icon: Icons.event_outlined,
                        title: 'Événement à venir',
                        subtitle: 'Nutrition Club - Samedi 14h',
                        time: 'Dans 2 jours',
                        color: AppColors.accent,
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 1000))
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
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
}
