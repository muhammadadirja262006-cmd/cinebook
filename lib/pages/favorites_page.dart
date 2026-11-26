import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';
import 'detail_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Movie> favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      final data = await DatabaseHelper.instance.getFavorites();

      if (!mounted) return;

      setState(() {
        favorites = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal memuat favorit: $e')));
    }
  }

  Future<void> openDetail(Movie movie) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(movie: movie)),
    );

    loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101014),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101014),
        title: const Text(
          'Film Favorit',
          style: TextStyle(
            color: Color(0xFFFFC107),
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: loadFavorites,
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFC107)),
            )
          : RefreshIndicator(
              color: const Color(0xFFFFC107),
              onRefresh: loadFavorites,
              child: favorites.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 120),
                        Icon(
                          Icons.favorite_border,
                          color: Color(0xFFFFC107),
                          size: 75,
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            'Belum Ada Film Favorit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Center(
                          child: Text(
                            'Tambahkan film yang kamu sukai\nke daftar favorit.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                      children: [
                        Text(
                          'Koleksi Film Kamu',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${favorites.length} film tersimpan di favorit',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 18),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: favorites.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.58,
                              ),
                          itemBuilder: (context, index) {
                            final movie = favorites[index];

                            return MovieCard(
                              movie: movie,
                              onTap: () => openDetail(movie),
                            );
                          },
                        ),
                      ],
                    ),
            ),
    );
  }
}
