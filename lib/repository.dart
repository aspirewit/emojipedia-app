import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'emoji.dart';

Future<List<Emoji>> findAllEmojis(String keyword) async {
  return List.generate(new Random().nextInt(10), (index) {
    return Emoji(
      character: '😀',
      name: 'Grinning Face',
      description: 'A yellow face with simple, open eyes and a broad, open smile, showing upper teeth and tongue on some platforms. Often conveys general pleasure and good cheer or humor.',
    );
  });
}
