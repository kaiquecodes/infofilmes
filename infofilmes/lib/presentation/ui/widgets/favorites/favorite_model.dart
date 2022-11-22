import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:infofilmes/domain/entity/movie.dart';
import 'package:infofilmes/data/repositories/favorite_repository.dart';
import 'package:infofilmes/presentation/ui/navigation/main_navigation.dart';

class MovieListRowData {
  final String? title;
  final String? releaseDate;
  final String? posterPath;
  final String? backdropPath;
  final int? id;
  final double? voteAvarage;
  final String? overview;

  MovieListRowData({
    required this.backdropPath,
    required this.title,
    required this.releaseDate,
    required this.posterPath,
    required this.id,
    required this.voteAvarage,
    required this.overview,
  });
}

class FavoriteModel extends ChangeNotifier {
  final _favoriteService = FavoriteRepository();

  late DateFormat _dateFormat;

   var _favoriteMovies = <MovieListRowData>[];
  List<MovieListRowData> get favoriteMovies => _favoriteMovies;
  
  FavoriteModel() {
     _dateFormat = DateFormat.yMMMMd('pt-BR');
    getMovies();
  }

  Future<void> getMovies() async {
    final favoriteMovies = await _favoriteService.favoriteMovies('pt-BR');
    _favoriteMovies = favoriteMovies.movies.map(_makeRowData).toList();
    notifyListeners();
  }

   MovieListRowData _makeRowData(Movie movie) {
    final releaseDate = movie.releaseDate;
    final releaseDateTitle =
        releaseDate != null ? _dateFormat.format(releaseDate) : '';
    return MovieListRowData(
      title: movie.title,
      releaseDate: releaseDateTitle,
      posterPath: movie.posterPath,
      id: movie.id,
      voteAvarage: movie.voteAverage,
      backdropPath: movie.backdropPath,
      overview: movie.overview,
    );
  }

  void onMovieTap(BuildContext context, int index) {
    final id = _favoriteMovies[index].id;
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.movieDetails,
      arguments: id,
    );
  }
}
