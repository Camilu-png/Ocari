import 'package:flutter/material.dart';

class PlayerScreen extends StatelessWidget {
  final String songId;

  const PlayerScreen({super.key, required this.songId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Player')),
      body: Center(child: Text('Player Screen - Song: $songId')),
    );
  }
}