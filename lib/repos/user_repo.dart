import '../db/db_helper.dart';
import '../models/user.dart';

class UserRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<User> create(User user) async {
    final db = await dbHelper.database;
    final id = await db.insert('users', user.ToMap()..remove('id'));

    return User(id: id, nama: user.nama, email: user.email);
  }

  Future<List<User>> readAll() async {
    final db = await dbHelper.database;
    final maps = await db.query('users', orderBy: 'nama ASC');

    return maps.map((m) => User.fromMap(m)).toList();
  }

  Future<User?> read(int id) async {
    final db = await dbHelper.database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);

    if (maps.isEmpty) return null;

    return User.fromMap(maps.first);
  }

  Future<int> update(User user) async {
    final db = await dbHelper.database;

    return db.update(
      'users',
      user.ToMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;

    return db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}