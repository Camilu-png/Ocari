import 'package:flutter/material.dart';

import 'package:ocari/core/widgets/ocari_scaffold.dart';

class PlayerScreen extends StatelessWidget {
  final String songId;

  const PlayerScreen({super.key, required this.songId});

  @override
  Widget build(BuildContext context) {
    return OcariScaffold(
      title: 'Player',
      body: Center(
        child: Text('Player Screen - Song: $songId'),
      ),
    );
  }
}
