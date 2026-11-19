import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/catalog_page.dart';

void main() {
  // ProviderScope membungkus seluruh aplikasi agar state Riverpod dapat diakses (Soal 3)
  runApp(
    const ProviderScope(
      child: BookCatalogApp(),
    ),
  );
}

class BookCatalogApp extends StatelessWidget {
  const BookCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Katalog Buku Pribadi - 085024009',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A), // Indigo Deep Blue
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 2,
        ),
      ),
      home: const CatalogPage(),
    );
  }
}
