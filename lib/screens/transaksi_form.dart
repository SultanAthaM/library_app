import 'package:flutter/material.dart';
import 'package:library_app/models/buku.dart';
import 'package:library_app/models/user.dart';
import 'package:library_app/repos/buku_repo.dart';
import 'package:library_app/repos/user_repo.dart';
import 'package:library_app/repos/transaksi_repo.dart';

class TransactionFormScreen extends StatefulWidget {
  const TransactionFormScreen({super.key});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _bookRepo = BukuRepo();
  final _userRepo = UserRepository();
  final _txRepo = TransaksiRepo();

  List<Buku> _books = [];
  List<User> _users = [];
  Buku? _selectedBook;
  User? _selectedUser;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final books = await _bookRepo.readAll();
    final users = await _userRepo.readAll();

    setState(() {
      _books = books.where((b) => b.sedia > 0).toList();
      _users = users;
      _loading = false;
    });
  }

  Future<void> _submit() async {
    if (_selectedBook == null || _selectedUser == null) {
      setState(() => _error = 'Pilih sebuah buka dan user');
      return;
    }

    try {
      await _txRepo.pinjamBuku(idBuku: _selectedBook!.id!, idUser: _selectedUser!.id!);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pinjam Buku')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_books.isEmpty)const Text('Tidak ada buku yang tersedia'),
            if (_users.isEmpty)const Text('Belum ada user'),

            DropdownButtonFormField<Buku>(
              value: _selectedBook,
              decoration: const InputDecoration(labelText: 'Buku'),
              items: _books
                  .map((b) => DropdownMenuItem(
                value: b,
                child: Text('${b.judul} (sedia ${b.sedia})'),
              ))
                  .toList(),
              onChanged: (b) => setState(() => _selectedBook = b),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<User>(
              value: _selectedUser,
              decoration: const InputDecoration(labelText: 'User'),
              items: _users
                  .map((u) => DropdownMenuItem(value: u, child: Text(u.nama)))
                  .toList(),
              onChanged: (u) => setState(() => _selectedUser = u),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 24),

            FilledButton(
              onPressed: (_books.isEmpty || _users.isEmpty) ? null : _submit,
              child: const Text('Konfirmasi'),
            ),
          ],
        ),
      ),
    );
  }
}