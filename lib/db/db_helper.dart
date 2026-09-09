import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('perpus.db');

    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bukus (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        judul TEXT NOT NULL,
        pengarang TEXT NOT NULL,
        isbn TEXT NOT NULL,
        total INTEGER NOT NULL,
        sedia INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idBuku INTEGER NOT NULL,
        idUser INTEGER NOT NULL,
        tanggalPinjam TEXT NOT NULL,
        tanggalKembali TEXT,
        status TEXT NOT NULL,
        FOREIGN KEY (idBuku) REFERENCES bukus (id) ON DELETE CASCADE,
        FOREIGN KEY (idUser) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}