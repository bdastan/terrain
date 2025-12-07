import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:prime_work/core/theme/app_colors.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _pages = [
    OnboardingContent(
      title: 'Gérez vos clients\navec facilité',
      description:
          'Un CRM complet pour suivre vos prospects et clients Herbalife avec des notifications intelligentes.',
      icon: Icons.people_outline,
      color: AppColors.primary,
    ),
    OnboardingContent(
      title: 'Suivez votre équipe\nen temps réel',
      description:
          'Pilotez votre activité de marketing relationnel et accompagnez votre équipe vers le succès.',
      icon: Icons.groups_outlined,
      color: AppColors.secondary,
    ),
    OnboardingContent(
      title: 'Atteignez vos objectifs\navec le plan 90 jours',
      description:
          'Définissez vos objectifs, suivez vos progrès quotidiens et visualisez votre évolution.',
      icon: Icons.trending_up_outlined,
      color: AppColors.accent,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Passer'),
                ),
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),

            // Page Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => _buildPageIndicator(index == _currentPage),
              ),
            ),

            const SizedBox(height: 32),

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < _pages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          context.go('/login');
                        }
                      },
                      child: Text(
                        _currentPage < _pages.length - 1
                            ? 'Suivant'
                            : 'Commencer',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('J\'ai déjà un compte'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingContent content) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  content.color,
                  content.color.withOpacity(0.7),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              content.icon,
              size: 64,
              color: Colors.white,
            ),
          )
              .animate()
              .scale(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutBack,
              )
              .fadeIn(duration: const Duration(milliseconds: 400)),

          const SizedBox(height: 48),

          // Title
          Text(
            content.title,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 600),
              )
              .slideY(
                begin: 0.3,
                end: 0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
              ),

          const SizedBox(height: 24),

          // Description
          Text(
            content.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(
                delay: const Duration(milliseconds: 400),
                duration: const Duration(milliseconds: 600),
              )
              .slideY(
                begin: 0.3,
                end: 0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
              ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.border,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingContent {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
