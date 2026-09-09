class Buku {
  final int? id;
  final String judul;
  final String pengarang;
  final String isbn;
  final int total;
  final int sedia;

  Buku({
    this.id,
    required this.judul,
    required this.pengarang,
    required this.isbn,
    required this.total,
    required this.sedia,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'pengarang': pengarang,
      'isbn': isbn,
      'total': total,
      'sedia': sedia,
    };
  }

  factory Buku.fromMap(Map<String, dynamic> map) {
    return Buku(
      id: map['id'] as int?,
      judul: map['judul'] as String,
      pengarang: map['pengarang'] as String,
      isbn: map['isbn'] as String,
      total: map['total'] as int,
      sedia: map['sedia'] as int,
    );
  }
}