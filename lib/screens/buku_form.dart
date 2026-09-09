import 'package:flutter/material.dart';
import 'package:library_app/repos/buku_repo.dart';
import 'package:library_app/models/buku.dart';

class BukuFormScreen extends StatefulWidget {
  final Buku? buku;
  const BukuFormScreen({super.key, this.buku});

  @override
  State<BukuFormScreen> createState() => _BukuFormScreenState();
}

class _BukuFormScreenState extends State<BukuFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repo = BukuRepo();

  late final TextEditingController _judulCtrl;
  late final TextEditingController _pengarangCtrl;
  late final TextEditingController _isbnCtrl;
  late final TextEditingController _totalCtrl;

  bool get _isEditing => widget.buku != null;

  @override
  void initState() {
    super.initState();
    _judulCtrl = TextEditingController(text: widget.buku?.judul ?? '');
    _pengarangCtrl = TextEditingController(text: widget.buku?.pengarang ?? '');
    _isbnCtrl = TextEditingController(text: widget.buku?.isbn ?? '');
    _totalCtrl = TextEditingController(text: widget.buku?.total.toString() ?? '1');
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final total = int.parse(_totalCtrl.text);

    if (_isEditing) {
      final updated = Buku(
        id: widget.buku!.id,
        judul: _judulCtrl.text.trim(),
        pengarang: _pengarangCtrl.text.trim(),
        isbn: _isbnCtrl.text.trim(),
        total: total,
        sedia: widget.buku!.sedia,
      );
      await _repo.update(updated);
    } else {
      final newBook = Buku(
        judul: _judulCtrl.text.trim(),
        pengarang: _pengarangCtrl.text.trim(),
        isbn: _isbnCtrl.text.trim(),
        total: total,
        sedia: total,
      );
      await _repo.create(newBook);
    }

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Buku' : 'Tambah Buku')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _judulCtrl,
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (v) => (v == null || v.trim().isEmpty) ? '*' : null,
              ),
              TextFormField(
                controller: _pengarangCtrl,
                decoration: const InputDecoration(labelText: 'Pengarang'),
                validator: (v) => (v == null || v.trim().isEmpty) ? '*' : null,
              ),
              TextFormField(
                controller: _isbnCtrl,
                decoration: const InputDecoration(labelText: 'ISBN'),
                validator: (v) => (v == null || v.trim().isEmpty) ? '*' : null,
              ),
              TextFormField(
                controller: _totalCtrl,
                decoration: const InputDecoration(labelText: 'Total'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null || n < 1) return 'Masukan angka positif';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              FilledButton(
                onPressed: _save,
                child: Text(_isEditing ? 'Simpan' : 'Tambah buku'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}