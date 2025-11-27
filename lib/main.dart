// main.dart
import 'package:flutter/material.dart'; // Paket UI utama Flutter
import 'package:provider/provider.dart'; // Untuk state management sederhana
import 'providers/favorites_provider.dart'; // Provider untuk data favorite
import 'pages/splash_page.dart'; // Halaman splash sebagai entry pertama app

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // Root widget aplikasi
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => FavoritesProvider())],
      child: MaterialApp(
        title: 'Aplikasi Retoran',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 250, 157, 50),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF3F4F6),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
        ),
        home: const SplashPage(),
      ),
    );
  }
}
