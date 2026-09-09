class User {
  final int? id;
  final String nama;
  final String email;

  User({
    this.id,
    required this.nama,
    required this.email
  });

  Map<String, dynamic> ToMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      nama: map['nama'] as String,
      email: map['email'] as String
    );
  }
}