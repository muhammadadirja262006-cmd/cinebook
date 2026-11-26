import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../data/movie_data.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Movie> movies = [];
  bool isLoading = true;

  final TextEditingController searchController = TextEditingController();

  String searchQuery = '';
  String selectedGenre = 'Semua';

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadMovies() async {
    try {
      List<Movie> data = await DatabaseHelper.instance.getMovies();

      // Tambahkan film yang belum ada ke SQLite.
      for (final movie in movieList) {
        final alreadyExists = data.any((item) => item.title == movie.title);

        if (!alreadyExists) {
          await DatabaseHelper.instance.insertMovie(movie);
        }
      }

      data = await DatabaseHelper.instance.getMovies();

      if (!mounted) return;

      setState(() {
        movies = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal memuat film: $e')));
    }
  }

  // Daftar genre yang tersedia.
  List<String> get genres {
    final allGenres = <String>{};

    for (final movie in movies) {
      allGenres.addAll(movie.genre.split(',').map((genre) => genre.trim()));
    }

    return ['Semua', ...allGenres.toList()..sort()];
  }

  // Pencarian dan filter genre.
  List<Movie> get filteredMovies {
    return movies.where((movie) {
      final matchesSearch = movie.title.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

      final movieGenres = movie.genre
          .split(',')
          .map((genre) => genre.trim())
          .toList();

      final matchesGenre =
          selectedGenre == 'Semua' || movieGenres.contains(selectedGenre);

      return matchesSearch && matchesGenre;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayedMovies = filteredMovies;

    return Scaffold(
      backgroundColor: const Color(0xFF101014),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101014),
        title: const Text(
          'CineBook',
          style: TextStyle(
            color: Color(0xFFFFC107),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: loadMovies,
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
              onRefresh: loadMovies,
              child: ListView(
                padding: const EdgeInsets.only(bottom: 20),
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Text(
                      'Temukan Film Favoritmu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Jelajahi berbagai pilihan film menarik.',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Kolom pencarian.
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Cari judul film...',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFFFFC107),
                        ),
                        suffixIcon: searchQuery.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  searchController.clear();
                                  setState(() {
                                    searchQuery = '';
                                  });
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.grey,
                                ),
                              )
                            : null,
                        filled: true,
                        fillColor: const Color(0xFF1C1C24),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Judul kategori.
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Kategori Film',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Pilihan genre yang bisa digeser.
                  SizedBox(
                    height: 42,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: genres.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final genre = genres[index];
                        final isSelected = selectedGenre == genre;

                        return ChoiceChip(
                          label: Text(genre),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              selectedGenre = genre;
                            });
                          },
                          selectedColor: const Color(0xFFFFC107),
                          backgroundColor: const Color(0xFF1C1C24),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          side: BorderSide.none,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Katalog dan jumlah film.
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Katalog Film',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${displayedMovies.length} Film',
                          style: const TextStyle(
                            color: Color(0xFFFFC107),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Jika film tidak ditemukan.
                  if (displayedMovies.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: [
                          Icon(
                            Icons.movie_filter_outlined,
                            color: Colors.grey,
                            size: 55,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Film tidak ditemukan',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Coba kata kunci atau kategori lain.',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: displayedMovies.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.58,
                            ),
                        itemBuilder: (context, index) {
                          final movie = displayedMovies[index];

                          return MovieCard(
                            movie: movie,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailPage(movie: movie),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
