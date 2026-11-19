import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';

/// Widget kartu buku dengan animasi implicit dan integrasi Riverpod
/// Memenuhi ketentuan:
/// - Soal 1: Penanganan null safety deskripsi
/// - Soal 2: Tampilan buku (judul, penulis, tahun) & teks pengganti saat deskripsi null
/// - Soal 3: Riverpod state pengelolaan tampil/sembunyikan deskripsi
/// - Soal 4: Implicit animation (AnimatedContainer, AnimatedRotation, AnimatedCrossFade)
class BookCard extends ConsumerWidget {
  final Book book;
  final int index;

  const BookCard({
    super.key,
    required this.book,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Membaca state daftar ID buku yang sedang diperluas (Soal 3)
    final expandedIds = ref.watch(expandedBooksProvider);
    final isExpanded = expandedIds.contains(book.id);

    final theme = Theme.of(context);
    final isDescriptionAvailable = book.hasDescription;

    // Soal 4: Implicit Animation menggunakan AnimatedContainer
    // Perubahan dekorasi, border, dan shadow terjadi secara halus saat isExpanded berubah
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isExpanded
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.35)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
          width: isExpanded ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isExpanded
                ? theme.colorScheme.primary.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: isExpanded ? 16 : 8,
            offset: Offset(0, isExpanded ? 6 : 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Soal 3: Interaksi mengubah state Riverpod
            ref.read(expandedBooksProvider.notifier).toggle(book.id);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Kartu: Nomor Urut, Judul Buku, dan Tombol Expand
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge Nomor Urut
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '#${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Judul dan Penulis
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: 16,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  book.author,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Soal 4: Implicit Animation dengan AnimatedRotation
                    // Ikon panah berputar 180 derajat saat kartu dibuka/tutup
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down),
                        tooltip: isExpanded
                            ? 'Sembunyikan Deskripsi'
                            : 'Tampilkan Deskripsi',
                        onPressed: () {
                          ref
                              .read(expandedBooksProvider.notifier)
                              .toggle(book.id);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Baris Info Tambahan: Tahun Terbit & Status Ketersediaan Deskripsi
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 13,
                            color: theme.colorScheme.onSecondaryContainer,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Tahun ${book.year}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isDescriptionAvailable
                            ? Colors.green.withValues(alpha: 0.12)
                            : Colors.orange.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isDescriptionAvailable
                            ? 'Deskripsi Ada'
                            : 'Tanpa Deskripsi (Null)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDescriptionAvailable
                              ? Colors.green[800]
                              : Colors.orange[900],
                        ),
                      ),
                    ),
                  ],
                ),

                // Soal 4: Implicit Animation dengan AnimatedCrossFade
                // Melakukan transisi mulus antara kondisi collapsed dan expanded
                AnimatedCrossFade(
                  firstChild: const SizedBox(width: double.infinity, height: 0),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.description_outlined,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Sinopsis & Deskripsi:',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Soal 1 & 2: Penanganan deskripsi null safety
                        // Jika description null, tampilkan teks pengganti yang informatif
                        if (book.description != null &&
                            book.description!.trim().isNotEmpty) ...[
                          Text(
                            book.description!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              height: 1.5,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ] else ...[
                          // Teks pengganti informatif untuk deskripsi null (Soal 2)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.errorContainer
                                  .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: theme.colorScheme.error
                                    .withValues(alpha: 0.4),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 18,
                                  color: theme.colorScheme.error,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Deskripsi tidak tersedia untuk buku ini. Silakan periksa katalog pustaka resmi atau dokumentasi penerbit untuk informasi lebih lanjut.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic,
                                      color: theme.colorScheme.onErrorContainer,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
