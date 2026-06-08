import 'package:ocari/features/songs/domain/models/song.dart';

abstract class SongRepository {
  Future<List<Song>> fetchAll();
  Future<Song?> fetchById(String id);
}
