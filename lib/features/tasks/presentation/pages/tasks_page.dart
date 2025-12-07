import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:prime_work/core/theme/app_colors.dart';
import 'package:prime_work/features/tasks/presentation/widgets/task_card.dart';
import 'package:prime_work/features/tasks/presentation/widgets/eisenhower_matrix.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  int _currentIndex = 2;
  bool _isMatrixView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Tâches'),
        actions: [
          IconButton(
            icon: Icon(
              _isMatrixView ? Icons.list : Icons.grid_view,
            ),
            onPressed: () {
              setState(() {
                _isMatrixView = !_isMatrixView;
              });
            },
            tooltip: _isMatrixView ? 'Vue liste' : 'Matrice Eisenhower',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show filter dialog
            },
          ),
        ],
      ),
      body: _isMatrixView ? _buildMatrixView() : _buildListView(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle tâche'),
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

  Widget _buildMatrixView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info Card
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
                const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Matrice d\'Eisenhower: Priorisez vos tâches',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn()
              .slideY(begin: -0.2, end: 0),

          const SizedBox(height: 24),

          // Eisenhower Matrix
          const EisenhowerMatrix()
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 200))
              .scale(begin: const Offset(0.95, 0.95)),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Urgent & Important',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.urgentImportant,
              ),
        )
            .animate()
            .fadeIn()
            .slideX(begin: -0.2, end: 0),
        const SizedBox(height: 12),
        TaskCard(
          title: 'Appeler prospect chaud Marie',
          description: 'Relance prévue aujourd\'hui',
          dueDate: 'Aujourd\'hui 14:00',
          priority: 'urgent_important',
          isCompleted: false,
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 100))
            .slideX(begin: -0.2, end: 0),
        const SizedBox(height: 12),
        TaskCard(
          title: 'Préparer commande Paul',
          description: 'Commande à livrer demain',
          dueDate: 'Aujourd\'hui 18:00',
          priority: 'urgent_important',
          isCompleted: false,
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 200))
            .slideX(begin: -0.2, end: 0),

        const SizedBox(height: 24),

        Text(
          'Important mais pas urgent',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.notUrgentImportant,
              ),
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 300)),
        const SizedBox(height: 12),
        TaskCard(
          title: 'Planifier événement nutrition club',
          description: 'Pour le mois prochain',
          dueDate: 'Cette semaine',
          priority: 'not_urgent_important',
          isCompleted: false,
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 400))
            .slideX(begin: -0.2, end: 0),
        const SizedBox(height: 12),
        TaskCard(
          title: 'Formation équipe sur nouveaux produits',
          description: 'Organiser session de formation',
          dueDate: 'Dans 2 semaines',
          priority: 'not_urgent_important',
          isCompleted: false,
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 500))
            .slideX(begin: -0.2, end: 0),

        const SizedBox(height: 24),

        Text(
          'Urgent mais pas important',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.urgentNotImportant,
              ),
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 600)),
        const SizedBox(height: 12),
        TaskCard(
          title: 'Répondre aux emails',
          description: 'Boîte de réception à traiter',
          dueDate: 'Aujourd\'hui',
          priority: 'urgent_not_important',
          isCompleted: false,
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 700))
            .slideX(begin: -0.2, end: 0),
      ],
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    String? selectedPriority;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
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
                      'Nouvelle tâche',
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
                    labelText: 'Titre',
                    prefixIcon: Icon(Icons.task_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Priorité',
                    prefixIcon: Icon(Icons.flag_outlined),
                  ),
                  value: selectedPriority,
                  items: const [
                    DropdownMenuItem(
                      value: 'urgent_important',
                      child: Text('Urgent & Important'),
                    ),
                    DropdownMenuItem(
                      value: 'not_urgent_important',
                      child: Text('Important mais pas urgent'),
                    ),
                    DropdownMenuItem(
                      value: 'urgent_not_important',
                      child: Text('Urgent mais pas important'),
                    ),
                    DropdownMenuItem(
                      value: 'not_urgent_not_important',
                      child: Text('Ni urgent ni important'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedPriority = value;
                    });
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Add task
                    },
                    child: const Text('Ajouter'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
