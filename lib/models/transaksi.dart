enum StatusTransaksi { terpinjam, kembali }

class BukuTransaksi {
  final int? id;
  final int idBuku;
  final int idUser;
  final DateTime tanggalPinjam;
  final DateTime? tanggalKembali;
  final StatusTransaksi status;

  BukuTransaksi({
    this.id,
    required this.idBuku,
    required this.idUser,
    required this.tanggalPinjam,
    this.tanggalKembali,
    required this.status
  });

  BukuTransaksi copyWith({int? id}) {
    return BukuTransaksi(
      id: id ?? this.id,
      idBuku: idBuku,
      idUser: idUser,
      tanggalPinjam: tanggalPinjam,
      tanggalKembali: tanggalKembali,
      status: status
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idBuku': idBuku,
      'idUser': idUser,
      'tanggalPinjam': tanggalPinjam.toIso8601String(),
      'tanggalKembali': tanggalKembali?.toIso8601String(),
      'status': status == StatusTransaksi.terpinjam ? 'terpinjam' : 'kembali',
    };
  }

  factory BukuTransaksi.fromMap(Map<String, dynamic> map) {
    return BukuTransaksi(
        id: map['id'] as int?,
        idBuku: map['idBuku'] as int,
        idUser: map['idUser'] as int,
        tanggalPinjam: DateTime.parse(map['tanggalPinjam'] as String),
        tanggalKembali: map['tanggalKembali'] != null ? DateTime.parse(map['tanggalKembali'] as String) : null,
        status: (map['status'] as String) == 'terpinjam' ? StatusTransaksi.terpinjam : StatusTransaksi.kembali
    );
  }
}