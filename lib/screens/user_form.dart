import 'package:flutter/material.dart';
import 'package:library_app/models/user.dart';
import 'package:library_app/repos/user_repo.dart';

class UserFormScreen extends StatefulWidget {
  final User? user;
  const UserFormScreen({super.key, this.user});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repo = UserRepository();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  String? _errorText;

  bool get _isEditing => widget.user != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user?.nama ?? '');
    _emailCtrl = TextEditingController(text: widget.user?.email ?? '');
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _errorText = null);

    try {
      if (_isEditing) {
        final updated = User(
          id: widget.user!.id,
          nama: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
        );
        await _repo.update(updated);
      } else {
        final newUser = User(
          nama: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
        );
        await _repo.create(newUser);
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => _errorText = 'Email sudah digunakan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit User' : 'Tambah User')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (v) => (v == null || v.trim().isEmpty) ? '*' : null,
              ),
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return '@';
                  if (!v.contains('@')) return 'Masukan email yang valid';
                  return null;
                },
              ),
              if (_errorText != null) ...[
                const SizedBox(height: 8),
                Text(_errorText!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 24),

              FilledButton(
                onPressed: _save,
                child: Text(_isEditing ? 'Simpan' : 'Tambah user'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}