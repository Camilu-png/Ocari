import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ocari/features/progress/data/repositories/firebase_user_song_progress_repository.dart';
import 'package:ocari/features/progress/domain/repositories/user_song_progress_repository.dart';

final firebaseFunctionsProvider = Provider<FirebaseFunctions>((ref) {
  return FirebaseFunctions.instance;
});

final userSongProgressRepositoryProvider =
    Provider<UserSongProgressRepository>((ref) {
  return FirebaseUserSongProgressRepository(
    ref.watch(firebaseFunctionsProvider),
  );
});
