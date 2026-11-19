import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/book_provider.dart';
import '../widgets/book_card.dart';
import '../widgets/info_header.dart';

/// Halaman utama Katalog Buku Pribadi
/// Menerapkan:
/// - Soal 2: Layout responsif dengan LayoutBuilder (Compact < 600px, Wide >= 600px)
/// - Soal 3: ref.watch() pada Riverpod providers (booksProvider, expandedBooksProvider)
/// - Fitur ekspansi batch (Buka Semua / Tutup Semua)
class CatalogPage extends ConsumerWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(booksProvider);
    final expandedIds = ref.watch(expandedBooksProvider);
    final allExpanded = expandedIds.length == books.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Katalog Buku Pribadi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          // Tombol aksi Expand / Collapse All
          IconButton(
            tooltip: allExpanded ? 'Tutup Semua' : 'Buka Semua Deskripsi',
            icon: Icon(
              allExpanded ? Icons.unfold_less : Icons.unfold_more,
            ),
            onPressed: () {
              if (allExpanded) {
                ref.read(expandedBooksProvider.notifier).collapseAll();
              } else {
                ref.read(expandedBooksProvider.notifier).expandAll(books);
              }
            },
          ),
          // Dialog Info Ujian
          IconButton(
            tooltip: 'Tentang Aplikasi',
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showAboutDialog(context, ref),
          ),
          const SizedBox(width: 8),
        ],
      ),
      // Soal 2: Terapkan perubahan layout menggunakan LayoutBuilder
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth >= 600;

          return CustomScrollView(
            slivers: [
              // Header identitas mahasiswa & info gabungan
              SliverToBoxAdapter(
                child: InfoHeader(isWideScreen: isWideScreen),
              ),

              // Judul bagian koleksi buku
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Daftar Buku (${books.length})',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton.icon(
                        icon: Icon(
                          allExpanded ? Icons.unfold_less : Icons.unfold_more,
                          size: 18,
                        ),
                        label: Text(
                          allExpanded ? 'Tutup Semua' : 'Buka Semua',
                        ),
                        onPressed: () {
                          if (allExpanded) {
                            ref
                                .read(expandedBooksProvider.notifier)
                                .collapseAll();
                          } else {
                            ref
                                .read(expandedBooksProvider.notifier)
                                .expandAll(books);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Soal 2: Perubahan layout berdasarkan ukuran layar
              if (!isWideScreen)
                // Layout Mobile (< 600px): List vertikal satu kolom
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return BookCard(
                        book: books[index],
                        index: index,
                      );
                    },
                    childCount: books.length,
                  ),
                )
              else
                // Layout Tablet/Desktop/Landscape (>= 600px): Grid responsif 2 kolom dengan auto-height
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, rowIndex) {
                      final firstIndex = rowIndex * 2;
                      final secondIndex = firstIndex + 1;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: BookCard(
                                book: books[firstIndex],
                                index: firstIndex,
                              ),
                            ),
                            if (secondIndex < books.length)
                              Expanded(
                                child: BookCard(
                                  book: books[secondIndex],
                                  index: secondIndex,
                                ),
                              )
                            else
                              const Expanded(child: SizedBox()),
                          ],
                        ),
                      );
                    },
                    childCount: (books.length / 2).ceil(),
                  ),
                ),

              // Footer catatan penutup
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  child: Center(
                    child: Text(
                      'ETS Pemrograman Mobile 2 • Universitas Pakuan 2026/2027',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAboutDialog(BuildContext context, WidgetRef ref) {
    final name = ref.read(nameProvider);
    final npm = ref.read(npmProvider);
    final info = ref.read(infoProvider);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.school, color: Colors.indigo),
              SizedBox(width: 8),
              Text('Informasi Proyek ETS'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _dialogRow('Nama Mahasiswa', name),
                _dialogRow('NPM', npm),
                _dialogRow('Program Studi', 'D3 Manajemen Informatika'),
                _dialogRow('Mata Kuliah', 'Pemrograman Mobile 2'),
                _dialogRow('Dosen Penguji', 'M. Saad Nurul Ishlah, M.Comp.'),
                const Divider(height: 20),
                Text(
                  'Output infoProvider:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    info,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Fitur Utama:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text('• Model Book & Null Safety Dart'),
                const Text('• LayoutBuilder Responsive (Mobile / Desktop Grid)'),
                const Text('• State Management Flutter Riverpod 3'),
                const Text('• Implicit Animation (Container, Rotation, Fade)'),
              ],
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  Widget _dialogRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
