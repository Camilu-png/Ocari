import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_notifier.dart'
    show authProvider;

final connectionStatusProvider = FutureProvider<bool>((ref) async {
  try {
    final client = Supabase.instance.client;
    final session = client.auth.currentSession;
    if (session == null) {
      debugPrint('No active session, but Supabase is connected');
    }
    return true;
  } catch (e) {
    debugPrint('Connection error: $e');
    return false;
  }
});

final googleSignInLoadingProvider = StateProvider<bool>((ref) => false);

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionAsync = ref.watch(connectionStatusProvider);
    final isLoading = ref.watch(googleSignInLoadingProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Login Screen'),
            const SizedBox(height: 16),
            connectionAsync.when(
              data: (connected) => Text(
                connected ? '✓ Conectado a Supabase' : '✗ Sin conexión',
                style: TextStyle(
                  color: connected ? Colors.green : Colors.red,
                ),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text(
                '✗ Error de conexión',
                style: TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 24),
            SignInButton(
              Buttons.Google,
              onPressed: isLoading
                  ? null
                  : () async {
                      ref.read(googleSignInLoadingProvider.notifier).state =
                          true;
                      final result = await ref
                          .read(authProvider.notifier)
                          .signInWithGoogle();
                      ref.read(googleSignInLoadingProvider.notifier).state =
                          false;
                      if (result.success && context.mounted) {
                        context.go('/songs');
                      } else if (!result.success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result.error ?? 'Error de login'),
                          ),
                        );
                      }
                    },
              text: 'Continuar con Google',
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
                  child: const Text('Regístrate'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}