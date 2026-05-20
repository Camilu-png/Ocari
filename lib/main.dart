import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  final supabaseUrl = dotenv.get('SUPABASE_URL', fallback: '');
  final supabaseAnonKey = dotenv.get('SUPABASE_ANON_KEY', fallback: '');

  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    throw Exception('Error: SUPABASE_URL or SUPABASE_ANON_KEY not found in .env');
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const ProviderScope(child: OcariApp()));
}

class OcariApp extends ConsumerWidget {
  const OcariApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouter);
    return MaterialApp.router(
      title: 'Ocari',
      routerConfig: router,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      builder: (context, child) {
        return Stack(
          children: [
            child ?? const SizedBox(),
            if (kDebugMode)
              _DebugButton(router: router),
          ],
        );
      },
    );
  }
}

class _DebugButton extends StatelessWidget {
  final GoRouter router;

  const _DebugButton({required this.router});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton(
        heroTag: 'debug_fab',
        onPressed: () => router.go('/debug'),
        backgroundColor: Colors.purple,
        mini: true,
        child: const Icon(Icons.bug_report, size: 20),
      ),
    );
  }
}
