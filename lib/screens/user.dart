import 'package:flutter/material.dart';
import 'package:library_app/models/user.dart';
import 'package:library_app/repos/user_repo.dart';
import 'package:library_app/screens/user_form.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final _repo = UserRepository();
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final users = await _repo.readAll();

    setState(() => _users = users);
  }

  Future<void> _openForm({User? user}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => UserFormScreen(user: user)),
    );

    if (result == true) _load();
  }

  Future<void> _delete(User user) async {
    await _repo.delete(user.id!);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: _users.isEmpty
          ? const Center(child: Text('Belum ada user. Klik + untuk menambahkan.'))
          : ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, i) {
          final user = _users[i];
          return ListTile(
            leading: CircleAvatar(child: Text(user.nama[0].toUpperCase())),
            title: Text(user.nama),
            subtitle: Text(user.email),
            onTap: () => _openForm(user: user),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _delete(user),
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