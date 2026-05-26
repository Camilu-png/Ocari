import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:go_router/go_router.dart';

import 'package:ocari/core/theme/app_theme.dart';
import 'package:ocari/core/widgets/ocari_button.dart';
import 'package:ocari/core/widgets/ocari_scaffold.dart';
import 'package:ocari/core/widgets/ocari_text_field.dart';
import 'package:ocari/features/auth/presentation/providers/auth_notifier.dart'
    show authProvider;

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  Future<void> _handleEmailLogin() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    setState(() => _isLoading = true);

    final result = await ref.read(authProvider.notifier).signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      context.go('/songs');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.error ?? 'Login failed',
            style: TextStyle(color: context.colors.onError),
          ),
          backgroundColor: context.colors.error,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OcariScaffold(
      title: 'Sign in',
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Welcome Back',
                style: context.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Sign in to your account',
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colors.onBgLight.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              OcariTextField(
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              const SizedBox(height: AppSpacing.md),
              OcariTextField(
                label: 'Password',
                controller: _passwordController,
                obscureText: true,
                validator: _validatePassword,
              ),
              const SizedBox(height: AppSpacing.xl),
              OcariButton(
                label: 'Sign in',
                isLoading: _isLoading,
                onPressed: _handleEmailLogin,
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text(
                      'Or',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colors.onBgLight.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: SignInButton(
                  Buttons.Google,
                  onPressed: _isLoading
                      ? null
                      : () async {
                          setState(() => _isLoading = true);
                          final result = await ref
                              .read(authProvider.notifier)
                              .signInWithGoogle();
                          setState(() => _isLoading = false);
                          if (result.success && context.mounted) {
                            context.go('/songs');
                          } else if (!result.success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result.error ?? 'Login failed'),
                                backgroundColor: context.colors.error,
                              ),
                            );
                          }
                        },
                  text: 'Google',
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: context.textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () => context.go('/register'),
                    child: const Text('Sign up'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
