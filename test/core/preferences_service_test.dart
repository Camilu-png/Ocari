import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ocari/core/services/preferences_service.dart';

void main() {
  group('PreferencesService', () {
    late PreferencesService service;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    group('onboarding', () {
      test('hasSeenOnboarding returns false by default', () async {
        final prefs = await SharedPreferences.getInstance();
        service = PreferencesService(prefs);
        expect(await service.hasSeenOnboarding(), false);
      });

      test('setOnboardingSeen persists the value', () async {
        final prefs = await SharedPreferences.getInstance();
        service = PreferencesService(prefs);
        await service.setOnboardingSeen();
        expect(await service.hasSeenOnboarding(), true);
      });

      test('hasSeenOnboarding returns true after setOnboardingSeen', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('onboarding_completed', true);
        service = PreferencesService(prefs);
        expect(await service.hasSeenOnboarding(), true);
      });
    });

    group('tutorial per song', () {
      test('hasSeenTutorial returns false by default for any song', () async {
        final prefs = await SharedPreferences.getInstance();
        service = PreferencesService(prefs);
        expect(await service.hasSeenTutorial('song-1'), false);
        expect(await service.hasSeenTutorial('song-2'), false);
      });

      test('setTutorialSeen persists per song independently', () async {
        final prefs = await SharedPreferences.getInstance();
        service = PreferencesService(prefs);

        await service.setTutorialSeen('song-1');

        expect(await service.hasSeenTutorial('song-1'), true);
        expect(await service.hasSeenTutorial('song-2'), false);
      });

      test('hasSeenTutorial returns true for previously seen song', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('tutorial_seen_song-1', true);
        service = PreferencesService(prefs);

        expect(await service.hasSeenTutorial('song-1'), true);
        expect(await service.hasSeenTutorial('song-2'), false);
      });
    });
  });
}
