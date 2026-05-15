import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionAsync = ref.watch(connectionStatusProvider);

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
            FilledButton(
              onPressed: () {
                ref.read(authProvider.notifier).loginForTest();
                context.go('/songs');
              },
              child: const Text('Login (test)'),
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