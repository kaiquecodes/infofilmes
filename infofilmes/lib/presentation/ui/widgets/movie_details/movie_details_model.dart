import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:infofilmes/data/repositories/favorite_repository.dart';
import 'package:infofilmes/domain/data_providers/session_data_provider.dart';
import 'package:infofilmes/domain/entity/movie_details.dart';
import 'package:infofilmes/domain/entity/movie_details_credits.dart';
import 'package:infofilmes/domain/entity/movie_details_video.dart';
import 'package:infofilmes/data/repositories/auth_repository.dart';
import 'package:infofilmes/presentation/ui/navigation/main_navigation.dart';
import '../../../../data/core/api_client_exception.dart';
import '../../../../data/data_source/api_client/movie_api_client.dart';

class MovieDetailsBackdropPosterData {
  final String? backdropPath;
  final String? trailerKey;

  MovieDetailsBackdropPosterData({this.backdropPath, this.trailerKey});
}

class MovieDetailsMovieMainDataWidget {
  final String? posterPath;
  final String? title;
  final String? year;
  final String? time;
  final double? voteCount;
  final double? voteAvarage;

  MovieDetailsMovieMainDataWidget({
    this.posterPath,
    this.title,
    this.year,
    this.time,
    this.voteCount,
    this.voteAvarage,
  });
}

class MovieDetailsData {
  bool isLoading = true;
  MovieDetailsBackdropPosterData posterData = MovieDetailsBackdropPosterData();
  MovieDetailsMovieMainDataWidget mainData = MovieDetailsMovieMainDataWidget();
  String overview = '';
}

class MovieDetailsModel extends ChangeNotifier {
  MovieDetailsModel({required this.movieId});

  final _authService = AuthRepository();
  final _sessionDataProvider = SessionDataProvider();
  final _movieApiClient = MovieApiClient();

  MovieDetails? _movieDetails;
  MovieDetailsCredits? _movieDetailsCast;
  MovieDetailsVideo? _movieDetailsVideo;

  final int movieId;
  final data = MovieDetailsData();
  String _locale = '';
  late DateFormat _dateFormat;
  bool _isFavorite = false;

  MovieDetails? get movieDetails => _movieDetails;
  MovieDetailsCredits? get movieDetailsCast => _movieDetailsCast;
  MovieDetailsVideo? get movieDetailsVideo => _movieDetailsVideo;
  bool? get isFavorite => _isFavorite;

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(_locale);
    await loadDetails(context);
  }

  Future<void> loadDetails(BuildContext context) async {
    try {
      _movieDetails = await _movieApiClient.movieDetails(movieId, _locale);
      _movieDetailsCast =
          await _movieApiClient.getCastForMovieDetails(movieId, _locale);
      _movieDetailsVideo =
          await _movieApiClient.getVideosForMovieDetails(movieId, _locale);
      final sessionId = await _sessionDataProvider.getSessionId();
      if (sessionId != null) {
        _isFavorite = await _movieApiClient.isFavorite(movieId, sessionId);
      }
      updateData(_movieDetails, _isFavorite);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  void updateData(MovieDetails? details, bool isFavorite) {
    data.isLoading = details == null;
    if (details == null) {
      notifyListeners();
      return;
    }
    data.overview = details.overview ?? '';

    final videos = movieDetailsVideo?.results
        .where((video) => video.type == 'Trailer' && video.site == 'YouTube');
    final trailerKey = videos?.isNotEmpty == true ? videos?.first.key : null;
    data.posterData = MovieDetailsBackdropPosterData(
        backdropPath: details.backdropPath, trailerKey: trailerKey);

    var year = details.releaseDate?.year.toString();
    year != null ? year = year : '';
    final runtime = details.runtime ?? 0;
    final duration = Duration(minutes: runtime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    data.mainData = MovieDetailsMovieMainDataWidget(
      posterPath: details.posterPath,
      year: year ?? '',
      title: details.title,
      voteAvarage: details.voteAverage,
      voteCount: details.voteCount.toDouble(),
      time: '${hours}h ${minutes}m',
    );

    notifyListeners();
  }

  Future<void> toggleFavorite(BuildContext context) async {
    final accountId = await _sessionDataProvider.getAccountId();
    final sessionId = await _sessionDataProvider.getSessionId();
    if (sessionId == null || accountId == null) return;
    final newFavoriteValue = !_isFavorite;
    _isFavorite = newFavoriteValue;
    notifyListeners();
    try {
      await FavoriteRepository().markMovies(newFavoriteValue, movieId);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  void _handleApiClientException(
      ApiClientException exception, BuildContext context) {
    switch (exception.type) {
      case ApiClientExceptionType.sessionExpired:
        _authService.logout();
        MainNavigation.resetNavigation(context);
        break;
      default:
        if (kDebugMode) {
          print(exception);
        }
    }
  }
}
