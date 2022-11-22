import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:infofilmes/domain/entity/movie.dart';
import 'package:infofilmes/data/repositories/movie_repository..dart';
import 'package:infofilmes/data/repositories/paginator.dart';
import 'package:infofilmes/presentation/ui/navigation/main_navigation.dart';

class MovieListRowData {
  final String? title;
  final String? releaseDate;
  final String? overview;
  final String? posterPath;
  final int? id;

  MovieListRowData({
    required this.title,
    required this.releaseDate,
    required this.overview,
    required this.posterPath,
    required this.id,
  });
}

class MovieSearchModel extends ChangeNotifier {
  final _movieService = MovieRepository();
  late final Paginator<Movie> _MoviePaginator;
  late final Paginator<Movie> _searchMoviePaginator;

  Timer? searchDebounce;
  String _locale = '';
  var _movies = <MovieListRowData>[];
  String? _searchQuery;

  List<MovieListRowData> get movies => List.unmodifiable(_movies);
  late DateFormat _dateFormat;

  bool get isSearchMode {
    final searchQuery = _searchQuery;
    return searchQuery != null && searchQuery.isNotEmpty;
  }

  MovieSearchModel() {
    _MoviePaginator = Paginator<Movie>((page) async {
      final result = await _movieService.topRatedMovies(_locale);
      return PaginatorLoadResult(
        data: result.movies,
        currentPage: result.page,
        totalPage: result.totalPages,
      );
    });
    _searchMoviePaginator = Paginator<Movie>((page) async {
      final result =
          await _movieService.searchMovie(page, _locale, _searchQuery ?? 'sa');
      return PaginatorLoadResult(
        data: result.movies,
        currentPage: result.page,
        totalPage: result.totalPages,
      );
    });
  }

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(_locale);
    await _resetList();
  }

  Future<void> _resetList() async {
    await _MoviePaginator.reset();
    await _searchMoviePaginator.reset();
    _movies.clear();
    await _loadNextPage();
  }

  Future<void> _loadNextPage() async {
    if (isSearchMode) {
      await _searchMoviePaginator.loadNextPage();
      _movies = _searchMoviePaginator.data.map(_makeRowData).toList();
    } else {
      await _MoviePaginator.loadNextPage();
      _movies = _MoviePaginator.data.map(_makeRowData).toList();
    }
    notifyListeners();
  }

  MovieListRowData _makeRowData(Movie movie) {
    final releaseDate = movie.releaseDate;
    final releaseDateTitle =
        releaseDate != null ? _dateFormat.format(releaseDate) : '';
    return MovieListRowData(
      title: movie.title,
      releaseDate: releaseDateTitle,
      overview: movie.overview,
      posterPath: movie.posterPath,
      id: movie.id,
    );
  }

  void onMovieTap(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.movieDetails,
      arguments: id,
    );
  }

  Future<void> searchMovie(String text) async {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(microseconds: 250), () async {
      final searchQuery = text.isNotEmpty ? text : null;
      if (_searchQuery == searchQuery) return;
      _searchQuery = searchQuery;
      _movies.clear();
      if (isSearchMode) {
        await _searchMoviePaginator.reset();
      }
      _loadNextPage();
    });
  }

  void showedMovieAtIndex(int index) {
    if (index < _movies.length - 1) return;
    _loadNextPage();
  }
}
