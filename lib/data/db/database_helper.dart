import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/restaurant_model.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tableFavorites = 'favorites';

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'restaurant_app.db');

    return openDatabase(dbPath, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableFavorites (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        pictureId TEXT,
        city TEXT,
        rating REAL
      )
    ''');
  }

  Future<void> insertFavorite(Restaurant restaurant) async {
    final db = await database;
    await db.insert(_tableFavorites, restaurant.toMap());
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete(_tableFavorites, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Restaurant>> getFavorites() async {
    final db = await database;
    final results = await db.query(_tableFavorites);
    return results.map((map) => Restaurant.fromMap(map)).toList();
  }

  Future<bool> isFavorite(String id) async {
    final db = await database;
    final results = await db.query(
      _tableFavorites,
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty;
  }
}
