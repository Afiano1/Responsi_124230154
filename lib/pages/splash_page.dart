// pages/splash_page.dart

import 'package:flutter/material.dart';
import '../services/auth_service.dart'; // Untuk cek login
import 'login_page.dart'; // Halaman login
import 'main_shell_page.dart'; // Halaman utama setelah login

// Halaman pertama yang muncul, hanya cek status login
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkLogin(); // Begitu halaman dibuat, langsung cek login
  }

  Future<void> _checkLogin() async {
    final loggedIn = await AuthService.isLoggedIn(); // Cek status login
    if (!mounted) return; // Pastikan widget masih aktif

    if (loggedIn) {
      // Kalau sudah login, ke MainShellPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainShellPage()),
      );
    } else {
      // Kalau belum login, ke LoginPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // UI sederhana: logo + loading
    return Scaffold(
      body: Container(
        // Background gradient agar lebih bagus
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 236, 160, 37),
              Color.fromARGB(255, 251, 213, 143),
            ], // Dua warna
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.food_bank, size: 80, color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Spaceflight News',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 24),
              CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
