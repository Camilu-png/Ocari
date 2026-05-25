import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ocari/core/theme/app_theme.dart';
import 'package:ocari/core/widgets/ocari_scaffold.dart';

void main() {
  group('OcariScaffold', () {
    testWidgets('renders title when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const OcariScaffold(
            title: 'Test Title',
            body: Text('Body'),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
    });

    testWidgets('does not render title when not provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const OcariScaffold(
            body: Text('Body'),
          ),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('shows back button when showBackButton is true and route can pop',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Builder(
            builder: (context) => _BackButtonLauncher(
              onPressed: () => Navigator.of(context).push<void>(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const OcariScaffold(
                    title: 'Second',
                    body: Text('Body'),
                    showBackButton: true,
                  ),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Push'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 10));

      expect(find.text('Body'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    });

    testWidgets('does not show back button when showBackButton is false',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const OcariScaffold(
            title: 'Test',
            body: Text('Body'),
            showBackButton: false,
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsNothing);
    });

    testWidgets('renders actions in AppBar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: OcariScaffold(
            title: 'Test',
            body: const Text('Body'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {},
              ),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('renders floatingActionButton', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: OcariScaffold(
            title: 'Test',
            body: const Text('Body'),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
          ),
        ),
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}

class _BackButtonLauncher extends StatelessWidget {
  final VoidCallback onPressed;

  const _BackButtonLauncher({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Push'),
    );
  }
}