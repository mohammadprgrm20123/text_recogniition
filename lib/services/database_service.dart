import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

import '../models/point.dart';

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
      'CREATE TABLE points(id INTEGER PRIMARY KEY , name TEXT, image TEXT)',
    );
  }

  Future<void> insertAll() async {
    final db = await database;

    ByteData bytes1 = await rootBundle.load('assets/images/1.png');
    ByteData bytes2 = await rootBundle.load('assets/images/2.jpg');
    ByteData bytes3 = await rootBundle.load('assets/images/3.png');
    ByteData bytes4 = await rootBundle.load('assets/images/4.png');

    Point p1 = Point(
      id: 1,
        name: 'bicepts', img: base64.encode(Uint8List.view(bytes1.buffer)));
    Point p2 = Point(
      id: 2,
        name: 'quads1', img: base64.encode(Uint8List.view(bytes2.buffer)));
    Point p3 = Point(
      id: 3,
        name: 'quads2', img: base64.encode(Uint8List.view(bytes3.buffer)));
    Point p4 = Point(
      id: 4,
        name: 'tricept', img: base64.encode(Uint8List.view(bytes4.buffer)));

    final id = await db.insert('points', p1.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    final id2 = await db.insert('points', p2.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    final id3 = await db.insert('points', p3.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    final id4 = await db.insert('points', p4.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    print('insert and id ===> $id');
    print('insert and id ===> $id2');
    print('insert and id ===> $id3');
    print('insert and id ===> $id4');
  }

  Future<List<Point>> getAllData(String value) async {
    value = value.toLowerCase();
    final query = 'SELECT * FROM "points" WHERE "name" LIKE "$value\%"';
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(query);

    List<Point> points = [];
    for (var element in maps) {
      points.add(Point.fromMap(element));
    }

    return points;
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
