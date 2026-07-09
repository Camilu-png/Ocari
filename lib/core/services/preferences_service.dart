import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  Future<bool> hasSeenOnboarding() async {
    return _prefs.getBool('onboarding_completed') ?? false;
  }

  Future<void> setOnboardingSeen() async {
    await _prefs.setBool('onboarding_completed', true);
  }

  Future<bool> hasSeenTutorial(String songId) async {
    return _prefs.getBool('tutorial_seen_$songId') ?? false;
  }

  Future<void> setTutorialSeen(String songId) async {
    await _prefs.setBool('tutorial_seen_$songId', true);
  }
}

final preferencesServiceProvider =
    FutureProvider<PreferencesService>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return PreferencesService(prefs);
});
