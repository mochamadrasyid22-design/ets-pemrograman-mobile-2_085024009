/// Model data buku dengan penerapan Null Safety Dart.
///
/// Memenuhi ketentuan Soal 1:
/// - title: String (wajib/non-nullable)
/// - author: String (wajib/non-nullable)
/// - year: int (wajib/non-nullable)
/// - description: String? (opsional/nullable)
/// - Parameter menggunakan `required` untuk data yang wajib diisi.
class Book {
  final String id;
  final String title;
  final String author;
  final int year;
  final String? description;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.year,
    this.description,
  });

  /// Helper untuk mengecek apakah buku memiliki deskripsi
  bool get hasDescription => description != null && description!.trim().isNotEmpty;
}
