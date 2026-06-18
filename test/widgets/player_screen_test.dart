import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ocari/core/services/audio_service.dart';
import 'package:ocari/core/theme/app_theme.dart';
import 'package:ocari/features/player/presentation/screens/player_screen.dart';
import 'package:ocari/features/songs/domain/models/difficulty.dart';
import 'package:ocari/features/songs/domain/models/song.dart';
import 'package:ocari/features/songs/presentation/providers/songs_provider.dart';

class MockAudioService extends Mock implements AudioService {}

const _testSong = Song(
  id: 'test-song',
  title: 'Test Song',
  difficulty: Difficulty.easy,
  durationSeconds: 30,
  notesJson: {
    'notes': [
      {
        'note': 'C4',
        'top': [1, 0, 0, 0],
        'bot': [0, 0, 0, 0],
        'sub': [0, 0],
        'middle': [0, 0],
        'timestamp_ms': 0,
        'duration_ms': 1000,
        'note_value': 'quarter',
      },
      {
        'note': 'D4',
        'top': [1, 1, 0, 0],
        'bot': [0, 0, 0, 0],
        'sub': [0, 0],
        'middle': [0, 0],
        'timestamp_ms': 1000,
        'duration_ms': 1000,
        'note_value': 'quarter',
      },
    ],
  },
);

Widget createTestWidget({
  required MockAudioService mockAudioService,
  required Song song,
}) {
  return ProviderScope(
    overrides: [
      songByIdProvider(song.id).overrideWith(
        (ref) async => song,
      ),
      audioServiceProvider.overrideWithValue(mockAudioService),
    ],
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      home: PlayerScreen(songId: song.id),
    ),
  );
}

void main() {
  late MockAudioService mockAudioService;
  late StreamController<bool> playingController;

  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });

  setUp(() {
    playingController = StreamController<bool>.broadcast();
    mockAudioService = MockAudioService();

    when(() => mockAudioService.positionStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockAudioService.playingStream)
        .thenAnswer((_) => playingController.stream);
    when(() => mockAudioService.completionStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockAudioService.load(any())).thenAnswer((_) async {});
    when(() => mockAudioService.play()).thenAnswer((_) async {});
    when(() => mockAudioService.pause()).thenAnswer((_) async {});
    when(() => mockAudioService.seek(any())).thenAnswer((_) async {});
    when(() => mockAudioService.setSpeed(any())).thenAnswer((_) async {});
    when(() => mockAudioService.duration).thenReturn(Duration.zero);
    when(() => mockAudioService.isPlaying).thenReturn(false);
  });

  tearDown(() {
    playingController.close();
  });

  group('PlayerScreen', () {
    testWidgets('renders song title and player elements for valid songId',
        (tester) async {
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      tester.view.physicalSize = const Size(411, 891);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(createTestWidget(
        mockAudioService: mockAudioService,
        song: _testSong,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Test Song'), findsWidgets);
      expect(find.byIcon(Icons.play_circle_filled_rounded), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
      expect(find.text('×1'), findsOneWidget);
    });

    testWidgets('play button toggles to pause when audio plays',
        (tester) async {
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      tester.view.physicalSize = const Size(411, 891);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(createTestWidget(
        mockAudioService: mockAudioService,
        song: _testSong,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.play_circle_filled_rounded));
      await tester.pump();

      verify(() => mockAudioService.play()).called(1);

      playingController.add(true);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.pause_circle_filled_rounded), findsOneWidget);
    });

    testWidgets('pause button toggles back to play when audio pauses',
        (tester) async {
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      tester.view.physicalSize = const Size(411, 891);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(createTestWidget(
        mockAudioService: mockAudioService,
        song: _testSong,
      ));
      await tester.pumpAndSettle();

      playingController.add(true);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.pause_circle_filled_rounded));
      await tester.pump();

      verify(() => mockAudioService.pause()).called(1);

      playingController.add(false);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.play_circle_filled_rounded), findsOneWidget);
    });
  });
}
