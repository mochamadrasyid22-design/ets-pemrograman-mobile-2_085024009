import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ets_pemrograman_mobile_2_085024009/main.dart';

void main() {
  testWidgets('Memverifikasi tampilan katalog buku, identitas mahasiswa, dan interaksi',
      (WidgetTester tester) async {
    // Gunakan ukuran layar pengujian yang mencukupi
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    // Bangun aplikasi di dalam ProviderScope
    await tester.pumpWidget(
      const ProviderScope(
        child: BookCatalogApp(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verifikasi identitas mahasiswa tampil dari provider
    expect(find.text('Mochamad Rasyid'), findsWidgets);
    expect(find.text('NPM: 085024009'), findsOneWidget);

    // 2. Verifikasi infoProvider gabungan nama dan jumlah buku tampil
    expect(find.text('Nama saya Mochamad Rasyid, saya memiliki 4 buku.'), findsOneWidget);

    // 3. Verifikasi judul buku tampil
    expect(find.text('Pemrograman Flutter: Dari Dasar Hingga Mahir'), findsOneWidget);
    expect(find.text('Refactoring: Improving the Design of Existing Code'), findsOneWidget);

    // 4. Uji interaksi tombol "Buka Semua" (fitur Riverpod state)
    final expandAllButton = find.text('Buka Semua');
    expect(expandAllButton, findsOneWidget);
    await tester.tap(expandAllButton);
    await tester.pumpAndSettle();

    // Verifikasi teks pengganti deskripsi null muncul untuk buku tanpa deskripsi
    expect(
      find.textContaining('Deskripsi tidak tersedia untuk buku ini'),
      findsOneWidget,
    );

    // Verifikasi tombol berubah menjadi "Tutup Semua"
    expect(find.text('Tutup Semua'), findsOneWidget);
  });
}
