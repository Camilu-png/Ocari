import 'package:ocari/features/progress/domain/models/user_song_progress.dart';

abstract class UserSongProgressRepository {
  Future<UserSongProgress> recordCompletion({
    required String userId,
    required String songId,
  });
}
