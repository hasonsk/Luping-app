import 'dart:io';
import 'package:logger/logger.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:luping/models/hint_character.dart'; // Import lớp hintCharacter
import 'package:luping/models/word.dart'; // Import lớp word
import 'dart:convert'; // Import for JSON decoding

class DatabaseHelper {
  static final logger = Logger();

  static Database? _database;
  static const String dbName = "HanziStory.sqlite";

  static Future ensureDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'HanziStory.sqlite');

    // Check if the database already exists
    final exists = await databaseExists(path);
    if (!exists) {
      // Make sure the directory exists
      await Directory(dirname(path)).create(recursive: true);

      // Load the pre-populated database from assets
      final data = await rootBundle.load('lib/data/HanziStory.sqlite');
      final bytes = data.buffer.asUint8List();

      // Write the data to the device
      await File(path).writeAsBytes(bytes, flush: true);
      logger.i('[DB] Database copied to $path');
    } else {
      logger.i('[DB] Database already exists at $path');
    }
  }

  static Future<void> testDatabase() async {
    try {
      final db = await getDatabase();
      final result = await db.rawQuery('SELECT * FROM Words LIMIT 1');

      logger.i('[DB] Testing database...');

      for (var row in result) {
        logger.i('[DB] $row');
      }
    } catch (e) {
      logger.e('Error occurred while testing database: $e');
    }
  }

  // Hàm mở cơ sở dữ liệu
  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    // Get the database path
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    // Open database
    _database = await openDatabase(path, version: 1);
    return _database!;
  }
}
