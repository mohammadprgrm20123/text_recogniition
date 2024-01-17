import '../models/Point.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, 'flutter_sqflite_database.db');

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  // When the database is first created, create a table to store points
  // and a table to store points.
  Future<void> _onCreate(Database db, int version) async {
    // Run the CREATE {points} TABLE statement on the database.
    await db.execute(
      'CREATE TABLE points(id INTEGER PRIMARY KEY, name TEXT, description TEXT)',
    );
  }

  Future<Point> point(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query('points', where: 'id = ?', whereArgs: [id]);
    return Point.fromMap(maps[0]);
  }

  Future<void> insertPoint(Point point) async {
    final db = await _databaseService.database;
    await db.insert(
      'points',
      point.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Point>> points() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('points');
    return List.generate(maps.length, (index) => Point.fromMap(maps[index]));
  }

  Future<void> updatePoint(Point point) async {
    final db = await _databaseService.database;
    await db.update('points', point.toMap(),
        where: 'id = ?', whereArgs: [point.id]);
  }

  Future<void> deletePoint(int id) async {
    final db = await _databaseService.database;
    await db.delete('points', where: 'id = ?', whereArgs: [id]);
  }
}
