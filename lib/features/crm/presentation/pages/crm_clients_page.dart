import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:prime_work/core/theme/app_colors.dart';
import 'package:prime_work/features/crm/presentation/widgets/client_card.dart';
import 'package:prime_work/features/crm/presentation/widgets/crm_filter_chip.dart';

class CrmClientsPage extends StatefulWidget {
  const CrmClientsPage({super.key});

  @override
  State<CrmClientsPage> createState() => _CrmClientsPageState();
}

class _CrmClientsPageState extends State<CrmClientsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'Tous';
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRM'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filter
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
            fontSize: 16,
          ),
          tabs: const [
            Tab(text: 'Prospects'),
            Tab(text: 'Clients'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CrmFilterChip(
                    label: 'Tous',
                    isSelected: _selectedFilter == 'Tous',
                    onTap: () {
                      setState(() {
                        _selectedFilter = 'Tous';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  CrmFilterChip(
                    label: 'À relancer',
                    isSelected: _selectedFilter == 'À relancer',
                    count: 5,
                    onTap: () {
                      setState(() {
                        _selectedFilter = 'À relancer';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  CrmFilterChip(
                    label: 'Nouveaux',
                    isSelected: _selectedFilter == 'Nouveaux',
                    count: 3,
                    onTap: () {
                      setState(() {
                        _selectedFilter = 'Nouveaux';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  CrmFilterChip(
                    label: 'Chauds',
                    isSelected: _selectedFilter == 'Chauds',
                    onTap: () {
                      setState(() {
                        _selectedFilter = 'Chauds';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  CrmFilterChip(
                    label: 'Inactifs',
                    isSelected: _selectedFilter == 'Inactifs',
                    onTap: () {
                      setState(() {
                        _selectedFilter = 'Inactifs';
                      });
                    },
                  ),
                ],
              ),
            ),
          )
              .animate()
              .fadeIn()
              .slideY(begin: -0.2, end: 0),

          const Divider(height: 1),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProspectsList(),
                _buildClientsList(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddClientDialog(context);
        },
        icon: const Icon(Icons.add),
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

  Widget _buildProspectsList() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        ClientCard(
          name: 'Marie Martin',
          phone: '+33 6 12 34 56 78',
          email: 'marie.martin@email.com',
          status: 'Nouveau',
          statusColor: AppColors.info,
          lastContact: 'Il y a 2 jours',
          nextAction: 'Relance prévue demain',
          hasNotification: true,
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 100))
            .slideX(begin: -0.2, end: 0),
        const SizedBox(height: 12),
        ClientCard(
          name: 'Thomas Dubois',
          phone: '+33 6 98 76 54 32',
          email: 'thomas.dubois@email.com',
          status: 'Chaud',
          statusColor: AppColors.warning,
          lastContact: 'Il y a 5 jours',
          nextAction: 'À relancer aujourd\'hui',
          hasNotification: true,
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 200))
            .slideX(begin: -0.2, end: 0),
        const SizedBox(height: 12),
        ClientCard(
          name: 'Sophie Lefebvre',
          phone: '+33 6 45 67 89 01',
          email: 'sophie.lefebvre@email.com',
          status: 'En cours',
          statusColor: AppColors.primary,
          lastContact: 'Il y a 1 semaine',
          nextAction: 'Rendez-vous fixé le 15/12',
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 300))
            .slideX(begin: -0.2, end: 0),
      ],
    );
  }

  Widget _buildClientsList() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        ClientCard(
          name: 'Paul Durand',
          phone: '+33 6 23 45 67 89',
          email: 'paul.durand@email.com',
          status: 'Actif',
          statusColor: AppColors.success,
          lastContact: 'Hier',
          lastOrder: '245€ - Il y a 3 jours',
          totalOrders: '2,450€',
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 100))
            .slideX(begin: -0.2, end: 0),
        const SizedBox(height: 12),
        ClientCard(
          name: 'Julie Moreau',
          phone: '+33 6 87 65 43 21',
          email: 'julie.moreau@email.com',
          status: 'Actif',
          statusColor: AppColors.success,
          lastContact: 'Il y a 3 jours',
          lastOrder: '180€ - Il y a 1 semaine',
          totalOrders: '1,890€',
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 200))
            .slideX(begin: -0.2, end: 0),
        const SizedBox(height: 12),
        ClientCard(
          name: 'Lucas Bernard',
          phone: '+33 6 11 22 33 44',
          email: 'lucas.bernard@email.com',
          status: 'Inactif',
          statusColor: AppColors.textSecondary,
          lastContact: 'Il y a 2 mois',
          lastOrder: '320€ - Il y a 3 mois',
          totalOrders: '3,200€',
          hasNotification: true,
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 300))
            .slideX(begin: -0.2, end: 0),
      ],
    );
  }

  void _showAddClientDialog(BuildContext context) {
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
                    'Nouveau contact',
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
                  labelText: 'Nom complet',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Téléphone',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: Add client
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
