import 'package:cloud_functions/cloud_functions.dart';

import 'package:ocari/features/progress/domain/models/user_song_progress.dart';
import 'package:ocari/features/progress/domain/repositories/user_song_progress_repository.dart';

class FirebaseUserSongProgressRepository
    implements UserSongProgressRepository {
  final FirebaseFunctions _functions;

  FirebaseUserSongProgressRepository(this._functions);

  @override
  Future<UserSongProgress> recordCompletion({
    required String userId,
    required String songId,
  }) async {
    final callable = _functions.httpsCallable('recordSongCompletion');
    final response = await callable.call<Map<String, dynamic>>({
      'songId': songId,
    });

    return UserSongProgress.fromJson(response.data);
  }
}