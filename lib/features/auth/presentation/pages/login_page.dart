import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:prime_work/core/theme/app_colors.dart';
import 'package:prime_work/features/auth/presentation/widgets/social_auth_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // Logo / Brand
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.workspace_premium_outlined,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                )
                    .animate()
                    .scale(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutBack,
                    )
                    .fadeIn(),

                const SizedBox(height: 32),

                // Title
                Text(
                  'Bienvenue !',
                  style: Theme.of(context).textTheme.displayMedium,
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 100))
                    .slideX(begin: -0.2, end: 0),

                const SizedBox(height: 8),

                Text(
                  'Connectez-vous pour accéder à votre espace',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 200))
                    .slideX(begin: -0.2, end: 0),

                const SizedBox(height: 40),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'votre.email@exemple.com',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre email';
                    }
                    if (!value.contains('@')) {
                      return 'Email invalide';
                    }
                    return null;
                  },
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 300))
                    .slideX(begin: -0.2, end: 0),

                const SizedBox(height: 20),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    hintText: '••••••••',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre mot de passe';
                    }
                    if (value.length < 6) {
                      return 'Le mot de passe doit contenir au moins 6 caractères';
                    }
                    return null;
                  },
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 400))
                    .slideX(begin: -0.2, end: 0),

                const SizedBox(height: 12),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implement forgot password
                    },
                    child: const Text('Mot de passe oublié ?'),
                  ),
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 500)),

                const SizedBox(height: 24),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              // TODO: Implement login
                              context.go('/');
                            }
                          },
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text('Se connecter'),
                  ),
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 600))
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 32),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OU',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 700)),

                const SizedBox(height: 24),

                // Social Auth Buttons
                Column(
                  children: [
                    SocialAuthButton(
                      text: 'Continuer avec Google',
                      icon: Icons.g_mobiledata,
                      onPressed: () {
                        // TODO: Implement Google Sign In
                      },
                      backgroundColor: Colors.white,
                      textColor: AppColors.textPrimary,
                      borderColor: AppColors.border,
                    ),
                    const SizedBox(height: 12),
                    SocialAuthButton(
                      text: 'Continuer avec Apple',
                      icon: Icons.apple,
                      onPressed: () {
                        // TODO: Implement Apple Sign In
                      },
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    SocialAuthButton(
                      text: 'Continuer avec Microsoft',
                      icon: Icons.window_outlined,
                      onPressed: () {
                        // TODO: Implement Microsoft Sign In
                      },
                      backgroundColor: const Color(0xFF00A4EF),
                      textColor: Colors.white,
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 800))
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 32),

                // Register Link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Pas encore de compte ? ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () => context.go('/register'),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('S\'inscrire'),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 900)),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
