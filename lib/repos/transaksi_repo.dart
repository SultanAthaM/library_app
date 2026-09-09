import '../db/db_helper.dart';
import '../models/transaksi.dart';

class TransactionView {
  final BukuTransaksi transaction;
  final String judulBuku;
  final String namaUser;

  TransactionView({
    required this.transaction,
    required this.judulBuku,
    required this.namaUser,
  });
}

class TransaksiRepo {
  final dbHelper = DatabaseHelper.instance;

  Future<BukuTransaksi> pinjamBuku({
    required int idBuku,
    required int idUser,
  }) async {
    final db = await dbHelper.database;

    return db.transaction((txn) async {
      final bukuMaps = await txn.query('bukus', where: 'id = ?', whereArgs: [idBuku]);

      if (bukuMaps.isEmpty) {
        throw StateError('Buku tidak ditemukan.');
      }

      final sedia = bukuMaps.first['sedia'] as int;

      if (sedia <= 0) {
        throw StateError('Buku ini tidak sedia.');
      }

      await txn.update(
        'bukus',
        {'sedia': sedia - 1},
        where: 'id = ?',
        whereArgs: [idBuku],
      );

      final catatanPinjam = BukuTransaksi(
        idBuku: idBuku,
        idUser: idUser,
        tanggalPinjam: DateTime.now(),
        status: StatusTransaksi.terpinjam,
      );

      final id = await txn.insert('transactions', catatanPinjam.toMap()..remove('id'));

      return catatanPinjam.copyWith(id: id);
    });
  }

  Future<void> ngembalikanBuku(int idTransaksi) async {
    final db = await dbHelper.database;

    await db.transaction((txn) async {
      final txMaps = await txn.query('transactions', where: 'id = ?', whereArgs: [idTransaksi]);

      if (txMaps.isEmpty) throw StateError('Transaksi tidak ditemukan.');

      final record = BukuTransaksi.fromMap(txMaps.first);

      if (record.status == StatusTransaksi.kembali) {
        throw StateError('Buku sudah dikembalikan.');
      }

      await txn.update(
        'transactions',
        {
          'status': 'kembali',
          'tanggalKembali': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [idTransaksi],
      );

      final bukuMaps = await txn.query('bukus', where: 'id = ?', whereArgs: [record.idBuku]);

      if (bukuMaps.isNotEmpty) {
        final sedia = bukuMaps.first['sedia'] as int;
        final total = bukuMaps.first['total'] as int;
        final sediaBaru = (sedia + 1).clamp(0, total);

        await txn.update(
          'bukus',
          {'sedia': sediaBaru},
          where: 'id = ?',
          whereArgs: [record.idBuku],
        );
      }
    });
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;

    return db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<TransactionView>> readAllWithDetails() async {
    final db = await dbHelper.database;

    final result = await db.rawQuery('''
    SELECT t.id as id, t.idBuku as idBuku, t.idUser as idUser,
           t.tanggalPinjam as tanggalPinjam, t.tanggalKembali as tanggalKembali,
           t.status as status,
           b.judul as judulBuku, u.nama as namaUser
    FROM transactions t
    JOIN bukus b ON b.id = t.idBuku
    JOIN users u ON u.id = t.idUser
    ORDER BY t.tanggalPinjam DESC
  ''');

    return result.map((row) {
      final tx = BukuTransaksi.fromMap(row);
      return TransactionView(
        transaction: tx,
        judulBuku: row['judulBuku'] as String,
        namaUser: row['namaUser'] as String,
      );
    }).toList();
  }
}