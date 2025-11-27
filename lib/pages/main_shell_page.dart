
import 'package:flutter/material.dart';
import '../services/auth_service.dart'; 
import 'home_page.dart'; 
import 'favorites_page.dart'; 
import 'login_page.dart'; 

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _currentIndex = 0; 
  String _username = ''; 

  
  final _pages = const [
    HomePage(), 
    FavoritesPage(), 
  ];

  @override
  void initState() {
    super.initState();
    _loadUsername(); 
  }

  Future<void> _loadUsername() async {
    final name = await AuthService.getCurrentUsername();
    if (!mounted) return;
    setState(() {
      _username = name ?? '';
    });
  }

  Future<void> _logout() async {
    await AuthService.logout(); 
    if (!mounted) return;
    // Pindah ke LoginPage dan hapus
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gunakan container gradient 
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
            // AppBar transparan
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
      body: _pages[_currentIndex], 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, 
        onTap: (i) => setState(() => _currentIndex = i), 
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
