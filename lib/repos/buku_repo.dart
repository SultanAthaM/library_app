import '../db/db_helper.dart';
import '../models/buku.dart';

class BukuRepo {
  final dbHelper = DatabaseHelper.instance;

  Future<Buku> create(Buku buku) async {
    final db = await dbHelper.database;
    final id = await db.insert('bukus', buku.toMap()..remove('id'));

    return Buku(
      id: id,
      judul: buku.judul,
      pengarang: buku.pengarang,
      isbn: buku.isbn,
      total: buku.total,
      sedia: buku.sedia,
    );
  }

  Future<List<Buku>> readAll() async {
    final db = await dbHelper.database;
    final maps = await db.query('bukus', orderBy: 'judul ASC');

    return maps.map((m) => Buku.fromMap(m)).toList();
  }

  Future<Buku?> read(int id) async {
    final db = await dbHelper.database;
    final maps = await db.query('bukus', where: 'id = ?', whereArgs: [id]);

    if (maps.isEmpty) return null;

    return Buku.fromMap(maps.first);
  }

  Future<int> update(Buku buku) async {
    final db = await dbHelper.database;

    return db.update(
      'bukus',
      buku.toMap(),
      where: 'id = ?',
      whereArgs: [buku.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;

    return db.delete('bukus', where: 'id = ?', whereArgs: [id]);
  }
}