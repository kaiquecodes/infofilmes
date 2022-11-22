import 'package:infofilmes/data/core/api_configurations.dart';
import 'package:infofilmes/data/data_source/api_client/movie_api_client.dart';
import 'package:infofilmes/domain/entity/movie_response.dart';

class MovieRepository  {
  final _movieApiClient = MovieApiClient();

  Future<MovieResponse> playingMovies(String locale) async =>
      _movieApiClient.getNowPlayingMovies(locale, ApiConfiguration.apiKey);

  Future<MovieResponse> upcoming(String locale) async =>
      _movieApiClient.getUpcomingMovies(locale, ApiConfiguration.apiKey);

  Future<MovieResponse> topRatedMovies(String locale) async =>
      _movieApiClient.getTopRatedMovies(locale, ApiConfiguration.apiKey);

  Future<MovieResponse> searchMovie(
          int page, String locale, String query) async =>
      _movieApiClient.searchMovie(page, locale, query, ApiConfiguration.apiKey);

}

