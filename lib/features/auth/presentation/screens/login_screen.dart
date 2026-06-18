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
  bool _isEmailLoading = false;
  bool _isGoogleLoading = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo es obligatorio';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    }
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    return null;
  }

  Future<void> _handleEmailLogin() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    setState(() => _isEmailLoading = true);

    final result = await ref.read(authProvider.notifier).signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted) return;
    setState(() => _isEmailLoading = false);

    if (result.success) {
      context.go('/songs');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.error ?? 'Error al iniciar sesión',
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
      title: 'Iniciar sesión',
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Bienvenido de nuevo',
                style: context.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Inicia sesión en tu cuenta',
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colors.onBgLight.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              OcariTextField(
                label: 'Correo electrónico',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              const SizedBox(height: AppSpacing.md),
              OcariTextField(
                label: 'Contraseña',
                controller: _passwordController,
                obscureText: true,
                validator: _validatePassword,
              ),
              const SizedBox(height: AppSpacing.xl),
              OcariButton(
                label: 'Iniciar sesión',
                isLoading: _isEmailLoading,
                onPressed: _handleEmailLogin,
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text(
                      'O',
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
                child: Stack(
                  children: [
                    AbsorbPointer(
                      absorbing: _isGoogleLoading,
                      child: SignInButton(
                        Buttons.Google,
                        onPressed: () async {
                          setState(() => _isGoogleLoading = true);
                          final result = await ref
                              .read(authProvider.notifier)
                              .signInWithGoogle();
                          setState(() => _isGoogleLoading = false);
                          if (result.success && context.mounted) {
                            context.go('/songs');
                          } else if (!result.success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result.error ?? 'Error al iniciar sesión'),
                                backgroundColor: context.colors.error,
                              ),
                            );
                          }
                        },
                        text: 'Google',
                      ),
                    ),
                    if (_isGoogleLoading)
                      const Positioned(
                        right: AppSpacing.sm,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF4285F4),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿No tienes cuenta? ',
                    style: context.textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () => context.go('/register'),
                    child: const Text('Registrarse'),
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
