import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'database.sqlite3');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('PRAGMA foreign_keys = ON');

        await db.execute('''
            CREATE TABLE workouts (
              id INTEGER PRIMARY KEY,
              created_at VARCHAR(30) DEFAULT (datetime('now')),
              updated_at VARCHAR(30) DEFAULT (datetime('now')),
              type_id INTEGER NOT NULL,
              FOREIGN KEY (type_id) REFERENCES workout_types(id) ON DELETE CASCADE
            );
            ''');

        await db.execute('''
            CREATE TABLE workout_types (
              id INTEGER PRIMARY KEY,
              created_at VARCHAR(30) DEFAULT (datetime('now')),
              updated_at VARCHAR(30) DEFAULT (datetime('now')),
              name VARCHAR(100) NOT NULL
            );
            ''');

        await db.execute('''
            CREATE TABLE sets (
              id INTEGER PRIMARY KEY,
              created_at VARCHAR(30) DEFAULT (datetime('now')),
              updated_at VARCHAR(30) DEFAULT (datetime('now')),
              workout_id INTEGER NOT NULL,
              weight REAL NOT NULL,
              repetitions INTEGER NOT NULL,
              FOREIGN KEY (workout_id) REFERENCES workouts(id) ON DELETE CASCADE
            );
            ''');

        await db.execute('''
            CREATE TRIGGER update_workout_timestamp
            AFTER UPDATE ON workouts
            FOR EACH ROW
            BEGIN
              UPDATE workouts
              SET updated_at = datetime('now')
              WHERE id = OLD.id;
            END;
            ''');

        await db.execute('''
            CREATE TRIGGER update_workout_type_timestamp
            AFTER UPDATE ON workout_types
            FOR EACH ROW
            BEGIN
              UPDATE workout_types
              SET updated_at = datetime('now')
              WHERE id = OLD.id;
            END;
            ''');

        await db.execute('''
            CREATE TRIGGER update_set_timestamp
            AFTER UPDATE ON sets
            FOR EACH ROW
            BEGIN
              UPDATE sets
              SET updated_at = datetime('now')
              WHERE id = OLD.id;
            END;
            ''');
      },
      onOpen: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  static Future<int> insert(String table, Map<String, Object?> data) async {
    final db = await database;
    return await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
      nullColumnHack: 'id',
    );
  }

  static Future<List<Map<String, Object?>>> query(
    String table, {
    String? whereKey,
    String? whereValue,
    String? orderBy,
  }) async {
    final db = await database;
    return await db.query(
      table,
      where: whereKey?.isNotEmpty == true ? '$whereKey = ?' : null,
      whereArgs: whereValue?.isNotEmpty == true ? [whereValue] : null,
      orderBy: orderBy?.isNotEmpty == true ? orderBy : null,
    );
  }

  static Future<int> update(
    String table,
    Map<String, Object?> data,
    int id,
  ) async {
    final db = await database;
    return await db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> delete(String table, int id) async {
    final db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<String> exportTableToCSV(String table) async {
    final db = await database;
    final maps = await db.query(table);
    if (maps.isEmpty) return '';

    final columns = maps.first.keys.join(',');
    final rows = maps.map((map) => map.values.join(',')).join('\n');

    return '$columns\n$rows';
  }

  static Future<void> importTableFromCSV(String table, File file) async{
    final db = await database;
    final lines = await file.readAsLines();
    if (lines.length < 2) return;

    final columns = lines[0].split(',');
    for (var i = 1; i < lines.length; i++) {
        final values = lines[i].split(',');
        final map = <String, dynamic>{};
        for (var j = 0; j < columns.length; j++) {
            map[columns[j]] = values[j];
          }
          await db.insert(table, map, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    }

}
