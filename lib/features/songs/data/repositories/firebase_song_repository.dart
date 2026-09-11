import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:ocari/core/utils/note_parser.dart';
import 'package:ocari/features/songs/domain/models/song.dart';
import 'package:ocari/features/songs/domain/repositories/song_repository.dart';

class FirebaseSongRepository implements SongRepository {
  final FirebaseFirestore _db;
  final AssetBundle _bundle;

  FirebaseSongRepository(this._db, [AssetBundle? bundle])
      : _bundle = bundle ?? rootBundle;

  @visibleForTesting
  Future<List<Song>> fetchAllFromFirestore() async {
    final snapshot = await _db.collection('songs').get();
    return snapshot.docs
        .map((doc) => Song.fromJson(normalizeSongData(doc.data())))
        .toList();
  }

  @visibleForTesting
  Future<Song?> fetchByIdFromFirestore(String id) async {
    final doc = await _db.collection('songs').doc(id).get();
    if (!doc.exists) return null;
    return Song.fromJson(normalizeSongData(doc.data()!));
  }

  @override
  Future<List<Song>> fetchAll() async {
    try {
      return await fetchAllFromFirestore();
    } catch (e) {
      debugPrint('Firestore fetchAll failed, falling back to local assets: $e');
      return _fallbackAll();
    }
  }

  @override
  Future<Song?> fetchById(String id) async {
    try {
      return await fetchByIdFromFirestore(id);
    } catch (e) {
      debugPrint('Firestore fetchById($id) failed, falling back: $e');
      return _fallbackById(id);
    }
  }

  Future<List<Song>> _fallbackAll() async {
    try {
      final indexJson =
          await _bundle.loadString('assets/data/songs_index.json');
      final ids = jsonDecode(indexJson) as List<dynamic>;

      final songs = <Song>[];
      for (final id in ids) {
        try {
          final song = await _fallbackById(id as String);
          if (song != null) {
            songs.add(song);
          } else {
            debugPrint('Fallback: failed to load song $id');
          }
        } catch (e) {
          debugPrint('Fallback: error loading song $id: $e');
        }
      }
      return songs;
    } catch (e) {
      debugPrint('Fallback: failed to load song index: $e');
      return [];
    }
  }

  Future<Song?> _fallbackById(String id) async {
    try {
      final path = 'assets/data/songs/$id.json';
      final jsonStr = await _bundle.loadString(path);
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      data['id'] = id;
      return Song.fromJson(normalizeSongData(data));
    } catch (e) {
      debugPrint('Fallback: failed to load song $id: $e');
      return null;
    }
  }
}