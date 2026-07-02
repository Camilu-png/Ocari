import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ocari/core/theme/app_theme.dart';
import 'package:ocari/core/widgets/shimmer_widget.dart';
import 'package:ocari/features/songs/domain/models/difficulty.dart';
import 'package:ocari/features/songs/domain/models/song.dart';
import 'package:ocari/features/songs/domain/repositories/song_repository.dart';
import 'package:ocari/features/songs/presentation/providers/songs_provider.dart';
import 'package:ocari/features/songs/presentation/screens/songs_screen.dart';

class MockSongRepository extends Mock implements SongRepository {}

final _testSongs = [
  const Song(
    id: '1',
    title: 'Test Song',
    artist: 'Test Artist',
    difficulty: Difficulty.easy,
    durationSeconds: 60,
  ),
  const Song(
    id: '2',
    title: 'Another Song',
    artist: 'Another Artist',
    difficulty: Difficulty.medium,
    durationSeconds: 120,
  ),
];

Widget createTestWidget({
  required SongRepository repository,
  ThemeData? theme,
}) {
  return ProviderScope(
    overrides: [
      songRepositoryProvider.overrideWithValue(repository),
    ],
    child: MaterialApp(
      theme: theme ?? AppTheme.lightTheme,
      home: const SongsScreen(),
    ),
  );
}

void main() {
  late MockSongRepository mockRepository;
  late Completer<List<Song>> loadingCompleter;

  setUp(() {
    loadingCompleter = Completer<List<Song>>();
    mockRepository = MockSongRepository();
  });

  group('SongsScreen states', () {
    testWidgets('shows shimmer during loading', (tester) async {
      when(() => mockRepository.fetchAll())
          .thenAnswer((_) => loadingCompleter.future);

      await tester.pumpWidget(createTestWidget(repository: mockRepository));

      expect(find.byType(SongCardShimmer), findsOneWidget);

      loadingCompleter.complete([]);
      await tester.pump();
    });

    testWidgets('shows error state with retry button', (tester) async {
      when(() => mockRepository.fetchAll())
          .thenThrow(Exception('Network error'));

      await tester.pumpWidget(createTestWidget(repository: mockRepository));
      await tester.pumpAndSettle();

      expect(find.text('Connection error'), findsOneWidget);
      expect(find.text('Could not load songs. Please check your connection.'),
          findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
    });

    testWidgets('retry button calls refresh and recovers', (tester) async {
      when(() => mockRepository.fetchAll())
          .thenThrow(Exception('Network error'));

      await tester.pumpWidget(createTestWidget(repository: mockRepository));
      await tester.pumpAndSettle();

      expect(find.text('Connection error'), findsOneWidget);

      when(() => mockRepository.fetchAll())
          .thenAnswer((_) async => _testSongs);

      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();

      expect(find.text('Test Song'), findsOneWidget);
      expect(find.text('2 songs'), findsOneWidget);
    });

    testWidgets('shows empty state when no songs available', (tester) async {
      when(() => mockRepository.fetchAll()).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget(repository: mockRepository));
      await tester.pumpAndSettle();

      expect(find.text('There are no songs available'), findsOneWidget);
    });

    testWidgets('shows no search results message', (tester) async {
      when(() => mockRepository.fetchAll())
          .thenAnswer((_) async => _testSongs);

      await tester.pumpWidget(createTestWidget(repository: mockRepository));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'nonexistent');
      await tester.pump();

      expect(
          find.text('No songs with that name were found'), findsOneWidget);
    });

    testWidgets('renders songs list successfully', (tester) async {
      when(() => mockRepository.fetchAll())
          .thenAnswer((_) async => _testSongs);

      await tester.pumpWidget(createTestWidget(repository: mockRepository));
      await tester.pumpAndSettle();

      expect(find.text('Test Song'), findsOneWidget);
      expect(find.text('Another Song'), findsOneWidget);
      expect(find.text('2 songs'), findsOneWidget);
    });
  });

  group('SongsScreen dark mode', () {
    testWidgets('shows states correctly in dark mode', (tester) async {
      when(() => mockRepository.fetchAll())
          .thenThrow(Exception('Network error'));

      await tester.pumpWidget(createTestWidget(
        repository: mockRepository,
        theme: AppTheme.darkTheme,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Connection error'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
    });

    testWidgets('shows empty state in dark mode', (tester) async {
      when(() => mockRepository.fetchAll()).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget(
        repository: mockRepository,
        theme: AppTheme.darkTheme,
      ));
      await tester.pumpAndSettle();

      expect(find.text('There are no songs available'), findsOneWidget);
    });
  });
}
