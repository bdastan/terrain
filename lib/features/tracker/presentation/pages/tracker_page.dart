import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:prime_work/core/theme/app_colors.dart';
import 'package:prime_work/features/tracker/presentation/widgets/goal_card.dart';
import 'package:prime_work/features/tracker/presentation/widgets/progress_chart.dart';
import 'package:prime_work/features/tracker/presentation/widgets/daily_tracker_card.dart';

class TrackerPage extends StatefulWidget {
  const TrackerPage({super.key});

  @override
  State<TrackerPage> createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 3;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracker d\'Activité'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // TODO: Navigate to tracker settings
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'Vue d\'ensemble'),
            Tab(text: 'Quotidien'),
            Tab(text: 'Objectifs'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildDailyTab(),
          _buildGoalsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showValidateDayDialog(context);
        },
        icon: const Icon(Icons.check_circle_outline),
        label: const Text('Valider aujourd\'hui'),
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

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plan 90 Days Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Plan 90 Jours',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Trimestre Q4 2024',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            '45',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'jours restants',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: 0.50,
                    minHeight: 8,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '50% du plan accompli',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn()
              .slideY(begin: -0.2, end: 0),

          const SizedBox(height: 24),

          // Progress Chart
          Text(
            'Progression mensuelle',
            style: Theme.of(context).textTheme.titleLarge,
          )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 100)),

          const SizedBox(height: 16),

          const ProgressChart()
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 200))
              .scale(begin: const Offset(0.95, 0.95)),

          const SizedBox(height: 24),

          // Quick Stats
          Text(
            'Statistiques rapides',
            style: Theme.of(context).textTheme.titleLarge,
          )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 300)),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Jours validés',
                  '45/90',
                  Icons.check_circle_outline,
                  AppColors.success,
                  '50%',
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 400))
                    .slideX(begin: -0.2, end: 0),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Série actuelle',
                  '7 jours',
                  Icons.local_fire_department_outlined,
                  AppColors.warning,
                  '+2',
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 500))
                    .slideX(begin: 0.2, end: 0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Today's Date
        Text(
          'Mercredi 7 Décembre 2024',
          style: Theme.of(context).textTheme.headlineSmall,
        )
            .animate()
            .fadeIn()
            .slideX(begin: -0.2, end: 0),

        const SizedBox(height: 24),

        // Daily Trackers
        DailyTrackerCard(
          title: 'Nouveaux prospects contactés',
          goal: 5,
          current: 3,
          icon: Icons.person_add_outlined,
          color: AppColors.primary,
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 100))
            .slideX(begin: -0.2, end: 0),

        const SizedBox(height: 12),

        DailyTrackerCard(
          title: 'Appels passés',
          goal: 10,
          current: 7,
          icon: Icons.phone_outlined,
          color: AppColors.secondary,
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 200))
            .slideX(begin: -0.2, end: 0),

        const SizedBox(height: 12),

        DailyTrackerCard(
          title: 'Rendez-vous fixés',
          goal: 3,
          current: 2,
          icon: Icons.event_outlined,
          color: AppColors.accent,
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 300))
            .slideX(begin: -0.2, end: 0),

        const SizedBox(height: 12),

        DailyTrackerCard(
          title: 'Commandes prises',
          goal: 2,
          current: 1,
          icon: Icons.shopping_bag_outlined,
          color: AppColors.success,
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 400))
            .slideX(begin: -0.2, end: 0),

        const SizedBox(height: 12),

        DailyTrackerCard(
          title: 'Publications réseaux sociaux',
          goal: 3,
          current: 3,
          icon: Icons.share_outlined,
          color: AppColors.info,
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 500))
            .slideX(begin: -0.2, end: 0),
      ],
    );
  }

  Widget _buildGoalsTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Objectifs du trimestre',
          style: Theme.of(context).textTheme.headlineSmall,
        )
            .animate()
            .fadeIn()
            .slideX(begin: -0.2, end: 0),

        const SizedBox(height: 16),

        GoalCard(
          title: 'Atteindre Superviseur',
          description: '2,500 VP requis',
          current: 1240,
          target: 2500,
          icon: Icons.workspace_premium_outlined,
          color: AppColors.accent,
          unit: 'VP',
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 100))
            .slideY(begin: 0.2, end: 0),

        const SizedBox(height: 12),

        GoalCard(
          title: 'Nouveaux clients',
          description: 'Objectif: 30 nouveaux clients',
          current: 24,
          target: 30,
          icon: Icons.people_outline,
          color: AppColors.primary,
          unit: 'clients',
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 200))
            .slideY(begin: 0.2, end: 0),

        const SizedBox(height: 12),

        GoalCard(
          title: 'Chiffre d\'affaires',
          description: 'Objectif trimestriel',
          current: 8500,
          target: 15000,
          icon: Icons.euro_outlined,
          color: AppColors.success,
          unit: '€',
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 300))
            .slideY(begin: 0.2, end: 0),

        const SizedBox(height: 12),

        GoalCard(
          title: 'Développement équipe',
          description: 'Recruter et former',
          current: 8,
          target: 12,
          icon: Icons.groups_outlined,
          color: AppColors.secondary,
          unit: 'membres',
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 400))
            .slideY(begin: 0.2, end: 0),

        const SizedBox(height: 24),

        OutlinedButton.icon(
          onPressed: () {
            _showAddGoalDialog(context);
          },
          icon: const Icon(Icons.add),
          label: const Text('Ajouter un objectif'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
          ),
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 500)),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  void _showValidateDayDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Valider la journée'),
        content: const Text(
          'Avez-vous atteint vos objectifs quotidiens ?\n\nCette action validera votre journée et sera comptabilisée dans votre plan 90 jours.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Validate day
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Journée validée ! 🎉'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nouvel objectif',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Titre de l\'objectif',
                  prefixIcon: Icon(Icons.flag_outlined),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: const TextField(
                      decoration: InputDecoration(
                        labelText: 'Objectif cible',
                        prefixIcon: Icon(Icons.trending_up),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: const TextField(
                      decoration: InputDecoration(
                        labelText: 'Unité',
                        prefixIcon: Icon(Icons.straighten),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: Add goal
                  },
                  child: const Text('Ajouter'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
