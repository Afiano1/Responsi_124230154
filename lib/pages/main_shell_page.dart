// pages/main_shell_page.dart

import 'package:flutter/material.dart';
import '../services/auth_service.dart'; // Untuk logout & ambil username
import 'home_page.dart'; // Halaman list artikel
import 'favorites_page.dart'; // Halaman favorite
import 'login_page.dart'; // Untuk kembali ke login ketika logout

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _currentIndex = 0; // Index bottom navigation
  String _username = ''; // Nama user yang login

  // List halaman yang dipakai di bottom navigation
  final _pages = const [
    HomePage(), // Index 0
    FavoritesPage(), // Index 1
  ];

  @override
  void initState() {
    super.initState();
    _loadUsername(); // Ambil username dari AuthService
  }

  Future<void> _loadUsername() async {
    final name = await AuthService.getCurrentUsername();
    if (!mounted) return;
    setState(() {
      _username = name ?? '';
    });
  }

  Future<void> _logout() async {
    await AuthService.logout(); // Set is_logged_in = false
    if (!mounted) return;
    // Pindah ke LoginPage dan hapus semua route sebelumnya
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gunakan container gradient untuk header di atas AppBar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 236, 160, 37),
                Color.fromARGB(255, 251, 213, 143),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            // AppBar transparan di atas gradient
            backgroundColor: Colors.transparent,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, ${_username.isEmpty ? 'User' : _username}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Selamat datang Aplikasi Restourant',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: _logout, // Logout
                icon: const Icon(Icons.logout, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      body: _pages[_currentIndex], // Tampilkan halaman sesuai index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Index aktif
        onTap: (i) => setState(() => _currentIndex = i), // Ganti index
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
        ],
      ),
    );
  }
}
