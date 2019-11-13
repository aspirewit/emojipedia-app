import 'dart:async' show Future;
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'emoji.dart';

Future<Database> _getConnection() async {
  final databasesPath = await getDatabasesPath();
  final databaseFilename = 'emojipedia-dataset.sqlite';
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

  return openDatabase(path, readOnly: true);
}

Future<List<Emoji>> findAllEmojis(String keyword) async {
  final db = await _getConnection();
  final tableName = 'emojis';
  final characterColumn = 'emoji_character';
  final nameColumn = 'emoji_name';
  final descriptionColumn = 'emoji_description';

  final maps = await db.query(
    tableName,
    columns: [characterColumn, nameColumn, descriptionColumn],
    where: '$nameColumn LIKE ?',
    whereArgs: ['%$keyword%'],
    limit: 120,
  );
  db.close();

  return List.generate(maps.length, (index) {
    return Emoji(
      character: maps[index][characterColumn],
      name: maps[index][nameColumn],
      description: maps[index][descriptionColumn],
    );
  });
}
