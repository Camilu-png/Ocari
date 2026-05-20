import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ocari/core/theme/app_theme.dart';
import 'package:ocari/features/auth/presentation/providers/auth_notifier.dart'
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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
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
                connected ? '✓ Connected to Supabase' : '✗ No connection',
                style: TextStyle(
                  color: connected ? Colors.green : Colors.red,
                ),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text(
                '✗ Connection error',
                style: TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 24),
            SignInButton(
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
                          ),
                        );
                      }
                    },
              text: 'Continue with Google',
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
          ],
        ),
      ),
    );
  }
}
