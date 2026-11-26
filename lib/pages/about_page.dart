import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101014),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101014),
        title: const Text(
          'Tentang CineBook',
          style: TextStyle(
            color: Color(0xFFFFC107),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 25),

            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: const Color(0xFF29251A),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.movie_creation_outlined,
                color: Color(0xFFFFC107),
                size: 65,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'CineBook',
              style: TextStyle(
                color: Color(0xFFFFC107),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Temukan Film Favoritmu',
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),

            const SizedBox(height: 30),

            infoCard(
              icon: Icons.info_outline,
              title: 'Tentang Aplikasi',
              description: 'CineBook merupakan aplikasi katalog film yang membantu pengguna menemukan informasi berbagai film. Pengguna dapat melihat detail film, mencari judul, memilih kategori, dan menyimpan film favorit.',
            ),

            const SizedBox(height: 15),

            infoCard(
              icon: Icons.star_outline,
              title: 'Fitur Utama',
              description:
                  '• Katalog 15 film\n'
                  '• Detail dan sinopsis film\n'
                  '• Pencarian judul film\n'
                  '• Filter berdasarkan genre\n'
                  '• Tambah dan hapus film favorit\n'
                  '• Penyimpanan data menggunakan SQLite',
            ),

            const SizedBox(height: 15),

            infoCard(
              icon: Icons.storage,
              title: 'Teknologi',
              description: 'Aplikasi dibuat menggunakan Flutter dan bahasa pemrograman Dart. Penyimpanan data menggunakan SQLite dengan bantuan package sqflite dan path.',
            ),

            const SizedBox(height: 15),

            infoCard(
              icon: Icons.person_outline,
              title: 'Pengembang',
              description:
                  'Nama: Muhammad Adirja\n'
                  'NPM: Isi NPM kamu\n'
                  'Kelas: Isi kelas kamu\n'
                  'Mata Kuliah: Mobile Programming',
            ),

            const SizedBox(height: 30),

            const Text(
              '© 2026 CineBook',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget infoCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C24),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFFFC107), size: 23),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
