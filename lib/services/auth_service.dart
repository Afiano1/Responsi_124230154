// services/auth_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Key untuk menyimpan data di SharedPreferences
  static const _keyUsername = 'username';
  static const _keyPassword = 'password';
  static const _keyIsLoggedIn = 'is_logged_in';

  // Fungsi registrasi: simpan username + password
  static Future<void> register({
    required String username,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username); // Simpan username
    await prefs.setString(_keyPassword, password); // Simpan password
  }

  // Fungsi login: cek username + password
  static Future<bool> login({
    required String username,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final savedUser = prefs.getString(_keyUsername);
    final savedPass = prefs.getString(_keyPassword);

    if (savedUser == null || savedPass == null) {
      return false;
    }

    final success = (savedUser == username && savedPass == password);
    if (success) {
      await prefs.setBool(_keyIsLoggedIn, true);
    }
    return success;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<String?> getCurrentUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }
}
