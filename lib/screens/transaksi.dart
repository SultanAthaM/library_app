import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:library_app/models/transaksi.dart';
import 'package:library_app/repos/transaksi_repo.dart';
import 'package:library_app/screens/transaksi_form.dart';

class TransaksiScreen extends StatefulWidget {
  const TransaksiScreen({super.key});

  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  final _repo = TransaksiRepo();
  List<TransactionView> _items = [];
  final _dateFmt = DateFormat('d MMM, y  HH:mm');

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items = await _repo.readAllWithDetails();

    setState(() => _items = items);
  }

  Future<void> _newBorrow() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const TransactionFormScreen()),
    );

    if (result == true) _load();
  }

  Future<void> _returnBook(TransactionView view) async {
    try {
      await _repo.ngembalikanBuku(view.transaction.id!);
      _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaksi')),
      body: _items.isEmpty
          ? const Center(child: Text('Belum ada transaksi. Klik + untuk menambahkan.'))
          : ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, i) {
          final view = _items[i];
          final tx = view.transaction;
          final isBorrowed = tx.status == StatusTransaksi.terpinjam;

          return ListTile(
            leading: Icon(
              isBorrowed ? Icons.book_online : Icons.check_circle_outline,
              color: isBorrowed ? Colors.orange : Colors.green,
            ),
            title: Text('${view.judulBuku} → ${view.namaUser}'),
            subtitle: Text('Dipinjam ${_dateFmt.format(tx.tanggalPinjam)}'),
            trailing: isBorrowed
                ? TextButton(
              onPressed: () => _returnBook(view),
              child: const Text('Kembali'),
            )
                : const Text('Dikembalikan'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newBorrow,
        tooltip: 'Pinjam Buku',
        child: const Icon(Icons.add),
      ),
    );
  }
}