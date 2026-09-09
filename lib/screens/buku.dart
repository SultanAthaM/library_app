import 'package:flutter/material.dart';
import 'package:library_app/models/buku.dart';
import 'package:library_app/repos/buku_repo.dart';
import 'package:library_app/screens/buku_form.dart';

class BukuScreen extends StatefulWidget {
  const BukuScreen({super.key});

  @override
  State<BukuScreen> createState() => _BukuScreenState();
}

class _BukuScreenState extends State<BukuScreen> {
  final _repo = BukuRepo();
  List<Buku> _buku = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final buku = await _repo.readAll();

    setState(() => _buku = buku);
  }

  Future<void> _openForm({Buku? buku}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => BukuFormScreen(buku: buku)),
    );

    if (result == true) _load();
  }

  Future<void> _delete(Buku buku) async {
    await _repo.delete(buku.id!);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buku')),
      body: _buku.isEmpty
          ? const Center(child: Text('Belum ada buku. Klik + untuk menambahkan.'))
          : ListView.builder(
        itemCount: _buku.length,
        itemBuilder: (context, i) {
          final buku = _buku[i];
          return ListTile(
            title: Text(buku.judul),
            subtitle: Text(
                '${buku.pengarang} · Sedia: ${buku.sedia}/${buku.total}'),
            onTap: () => _openForm(buku: buku),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _delete(buku),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}