import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';

/// Provider untuk nama mahasiswa (Soal 3)
final nameProvider = Provider<String>((ref) {
  return 'Mochamad Rasyid';
});

/// Provider untuk NPM mahasiswa (Soal 3)
final npmProvider = Provider<String>((ref) {
  return '085024009';
});

/// Provider untuk daftar buku koleksi pribadi (Soal 1 & 3)
/// Berisi 4 buku dengan minimal 1 buku tidak memiliki deskripsi (description: null)
final booksProvider = Provider<List<Book>>((ref) {
  return const [
    Book(
      id: 'book-01',
      title: 'Pemrograman Flutter: Dari Dasar Hingga Mahir',
      author: 'M. Saad Nurul Ishlah, M.Comp.',
      year: 2024,
      description:
          'Panduan komprehensif pengembangan aplikasi mobile multiplatform modern menggunakan Flutter dan Dart dengan pendekatan state management terstruktur.',
    ),
    Book(
      id: 'book-02',
      title: 'Clean Architecture: A Craftsman\'s Guide to Software Structure',
      author: 'Robert C. Martin (Uncle Bob)',
      year: 2017,
      description:
          'Prinsip-prinsip universal arsitektur perangkat lunak untuk membangun sistem yang kokoh, teruji, mudah dipelihara, dan independen terhadap framework.',
    ),
    Book(
      id: 'book-03',
      title: 'Refactoring: Improving the Design of Existing Code',
      author: 'Martin Fowler',
      year: 2018,
      description: null, // Buku tanpa deskripsi untuk memenuhi kriteria Soal 1
    ),
    Book(
      id: 'book-04',
      title: 'Design Patterns: Elements of Reusable Object-Oriented Software',
      author: 'Erich Gamma, Richard Helm, Ralph Johnson, John Vlissides',
      year: 1994,
      description:
          'Karya klasik yang merangkum 23 pola desain esensial untuk memecahkan permasalahan arsitektural berorientasi objek secara elegan.',
    ),
  ];
});

/// Provider gabungan nama dan jumlah buku menggunakan ref.watch() (Soal 3)
/// Contoh format: "Nama saya Mochamad Rasyid, saya memiliki 4 buku."
final infoProvider = Provider<String>((ref) {
  final name = ref.watch(nameProvider);
  final books = ref.watch(booksProvider);
  return 'Nama saya $name, saya memiliki ${books.length} buku.';
});

/// Notifier untuk mengelola state tampil/sembunyikan deskripsi buku (Soal 3)
/// Menyimpan Set dari id buku yang sedang dalam kondisi deskripsi terbuka (expanded).
class ExpandedBooksNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    return <String>{};
  }

  /// Toggle tampil/sembunyi deskripsi untuk buku tertentu
  void toggle(String bookId) {
    if (state.contains(bookId)) {
      state = {...state}..remove(bookId);
    } else {
      state = {...state, bookId};
    }
  }

  /// Tampilkan seluruh deskripsi buku
  void expandAll(List<Book> books) {
    state = books.map((b) => b.id).toSet();
  }

  /// Sembunyikan seluruh deskripsi buku
  void collapseAll() {
    state = <String>{};
  }
}

/// Provider state untuk buku-buku yang dibuka deskripsinya (Soal 3)
final expandedBooksProvider =
    NotifierProvider<ExpandedBooksNotifier, Set<String>>(
  ExpandedBooksNotifier.new,
);
