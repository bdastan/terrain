import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prime_work/features/auth/presentation/pages/login_page.dart';
import 'package:prime_work/features/auth/presentation/pages/register_page.dart';
import 'package:prime_work/features/auth/presentation/pages/onboarding_page.dart';
import 'package:prime_work/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:prime_work/features/crm/presentation/pages/crm_clients_page.dart';
import 'package:prime_work/features/crm/presentation/pages/crm_team_page.dart';
import 'package:prime_work/features/tasks/presentation/pages/tasks_page.dart';
import 'package:prime_work/features/tracker/presentation/pages/tracker_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/onboarding',
    debugLogDiagnostics: true,
    routes: [
      // Onboarding & Auth
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),

      // Main App
      GoRoute(
        path: '/',
        name: 'dashboard',
        builder: (context, state) => const DashboardPage(),
      ),

      // CRM
      GoRoute(
        path: '/crm/clients',
        name: 'crm_clients',
        builder: (context, state) => const CrmClientsPage(),
      ),
      GoRoute(
        path: '/crm/team',
        name: 'crm_team',
        builder: (context, state) => const CrmTeamPage(),
      ),

      // Tasks
      GoRoute(
        path: '/tasks',
        name: 'tasks',
        builder: (context, state) => const TasksPage(),
      ),

      // Tracker
      GoRoute(
        path: '/tracker',
        name: 'tracker',
        builder: (context, state) => const TrackerPage(),
      ),
    ],
  );
});
