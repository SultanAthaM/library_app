import 'package:flutter/material.dart';
import 'package:library_app/screens/transaksi.dart';
import 'package:library_app/screens/user.dart';
import 'package:library_app/screens/buku.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  int _index = 0;

  final _pages = const [
    BukuScreen(),
    UsersScreen(),
    TransaksiScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), label: 'Buku'),
          NavigationDestination(icon: Icon(Icons.people_outline), label: 'User'),
          NavigationDestination(icon: Icon(Icons.swap_horiz_outlined), label: 'Transaksi'),
        ],
      ),
    );
  }
}