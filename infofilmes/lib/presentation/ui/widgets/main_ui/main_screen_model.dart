import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:infofilmes/domain/entity/movie.dart';
import 'package:infofilmes/data/repositories/auth_repository.dart';
import 'package:infofilmes/data/repositories/movie_repository..dart';
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

class MainScreenModel extends ChangeNotifier {
  final _movieRepository = MovieRepository ();
  final _authRepository = AuthRepository();


  String _locale = '';
  late DateFormat _dateFormat;

  var _playingMovies = <MovieListRowData>[];
  List<MovieListRowData> get playingMovies => _playingMovies;
  var _upcomingMovies = <MovieListRowData>[];
  List<MovieListRowData> get upcomingMovies => _upcomingMovies;
  var _topRatedMovies = <MovieListRowData>[];
  List<MovieListRowData> get topRatedMovies => _topRatedMovies;

  MainScreenModel() {
    _getMovies();
  }

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(_locale);
  }

  Future<void> _getMovies() async {
    final playingMovies = await _movieRepository.playingMovies('pt-BR');
    _playingMovies = playingMovies.movies.map(_makeRowData).toList();

    final upcomingMovies = await _movieRepository.upcoming('pt-BR');
    _upcomingMovies = upcomingMovies.movies.map(_makeRowData).toList();

    final topRatedMovies = await _movieRepository.topRatedMovies('pt-BR');
    _topRatedMovies = topRatedMovies.movies.map(_makeRowData).toList();

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

  void onMovieTap(BuildContext context, int id) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.movieDetails,
      arguments: id,
    );
  }

  Future<void> logout(BuildContext context) async {
    await _authRepository.logout();
    MainNavigation.resetNavigation(context);
  }
}
