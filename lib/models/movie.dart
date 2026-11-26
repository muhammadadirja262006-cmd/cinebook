class Movie {
  final int? id;
  final String title;
  final String genre;
  final int year;
  final double rating;
  final String synopsis;
  final String poster;
  final int isFavorite;

  Movie({
    this.id,
    required this.title,
    required this.genre,
    required this.year,
    required this.rating,
    required this.synopsis,
    required this.poster,
    this.isFavorite = 0,
  });

  // Mengubah objek film menjadi Map untuk SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'genre': genre,
      'year': year,
      'rating': rating,
      'synopsis': synopsis,
      'poster': poster,
      'isFavorite': isFavorite,
    };
  }

  // Mengubah data SQLite menjadi objek film
  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      genre: map['genre'],
      year: map['year'],
      rating: (map['rating'] as num).toDouble(),
      synopsis: map['synopsis'],
      poster: map['poster'],
      isFavorite: map['isFavorite'],
    );
  }
}
