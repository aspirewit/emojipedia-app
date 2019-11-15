import 'dart:async' show Future;
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'emoji.dart';

class EmojiRepository {
  final databaseFilename = 'emojipedia-dataset.sqlite';
  final tableName = 'emojis_fts5';
  final characterColumn = 'emoji_character';
  final nameColumn = 'emoji_name';
  final descriptionColumn = 'emoji_description';

  Database db;

  Future open() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, databaseFilename);
    final exists = await databaseExists(path);

    if (!exists) {
      print('Creating new copy from asset');
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      final data = await rootBundle.load(join('assets', databaseFilename));
      final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }

    db = await openDatabase(path, readOnly: true);
  }

  Future close() async => db.close();

  Future<List<Emoji>> findAllEmojis(String keyword) async {
    final maps = await db.query(
      tableName,
      columns: [characterColumn, nameColumn, descriptionColumn],
      where: '$characterColumn MATCH(?) OR $nameColumn MATCH(?) OR $descriptionColumn MATCH(?)',
      whereArgs: [keyword, keyword, keyword],
      limit: 120,
    );

    return List.generate(maps.length, (index) {
      return Emoji(
        character: maps[index][characterColumn],
        name: maps[index][nameColumn],
        description: maps[index][descriptionColumn],
      );
    });
  }
}
