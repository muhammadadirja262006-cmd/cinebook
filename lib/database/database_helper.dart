import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/movie.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  // Membuka database
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('cinebook.db');
    return _database!;
  }

  // Membuat file database
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Membuat tabel film
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE movies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        genre TEXT NOT NULL,
        year INTEGER NOT NULL,
        rating REAL NOT NULL,
        synopsis TEXT NOT NULL,
        poster TEXT NOT NULL,
        isFavorite INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  // Menambahkan film
  Future<int> insertMovie(Movie movie) async {
    final db = await database;

    return await db.insert(
      'movies',
      movie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Mengambil semua film
  Future<List<Movie>> getMovies() async {
    final db = await database;

    final result = await db.query('movies');

    return result.map((e) => Movie.fromMap(e)).toList();
  }

  // Mengambil film favorit
  Future<List<Movie>> getFavorites() async {
    final db = await database;

    final result = await db.query(
      'movies',
      where: 'isFavorite = ?',
      whereArgs: [1],
    );

    return result.map((e) => Movie.fromMap(e)).toList();
  }

  // Mengubah status favorit
  Future<int> updateFavorite(int id, int status) async {
    final db = await database;

    return await db.update(
      'movies',
      {'isFavorite': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Menghapus film
  Future<int> deleteMovie(int id) async {
    final db = await database;

    return await db.delete('movies', where: 'id = ?', whereArgs: [id]);
  }
}
