import 'package:infofilmes/data/core/api_configurations.dart';
import 'package:infofilmes/domain/entity/movie_details.dart';
import 'package:infofilmes/domain/entity/movie_details_credits.dart';
import 'package:infofilmes/domain/entity/movie_details_video.dart';
import 'package:infofilmes/domain/entity/movie_response.dart';

import '../../core/api_client.dart';


class MovieApiClient {
  final _networkClient = ApiClient();

  Future<MovieResponse> getNowPlayingMovies(String locale, String apiKey) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieResponse.fromJson(jsonMap);
      return response;
    }
    final result = _networkClient.get(
      '/movie/now_playing',
      parser,
      {
        'api_key': apiKey,
        'language': locale,
      },
    );
    return result;
  }

  Future<MovieResponse> getUpcomingMovies(String locale, String apiKey) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieResponse.fromJson(jsonMap);
      return response;
    }
    final result = _networkClient.get(
      '/movie/upcoming',
      parser,
      {
        'api_key': apiKey,
        'language': locale,
      },
    );
    return result;
  }

   Future<MovieResponse> getTopRatedMovies (String locale, String apiKey) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieResponse.fromJson(jsonMap);
      return response;
    }
    final result = _networkClient.get(
      '/movie/top_rated',
      parser,
      {
        'api_key': apiKey,
        'language': locale,
      },
    );
    return result;
  }

  Future<MovieResponse> searchMovie(
      int page, String locale, String query, String apiKey) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieResponse.fromJson(jsonMap);
      return response;
    }
    final result = _networkClient.get(
      '/search/movie',
      parser,
      {
        'api_key': apiKey,
        'page': page.toString(),
        'language': locale,
        'query': query,
        'include_adult': true.toString(),
      },
    );
    return result;
  }

  Future<MovieDetails> movieDetails(int movieId, String locale) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieDetails.fromJson(jsonMap);
      return response;
    }
    final result = _networkClient.get(
      '/movie/$movieId',
      parser,
      {
        'api_key': ApiConfiguration.apiKey,
        'language': locale,
      },
    );
    return result;
  }

  Future<MovieDetailsCredits> getCastForMovieDetails(
      int movieId, String locale) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieDetailsCredits.fromJson(jsonMap);
      return response;
    }
    final result = _networkClient.get(
      '/movie/$movieId/credits',
      parser,
      {
        'api_key': ApiConfiguration.apiKey,
        'language': locale,
      },
    );
    return result;
  }

  Future<MovieDetailsVideo> getVideosForMovieDetails(
      int movieId, String locale) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieDetailsVideo.fromJson(jsonMap);
      return response;
    }
    final result = _networkClient.get(
      '/movie/$movieId/videos',
      parser,
      {
        'api_key': ApiConfiguration.apiKey,
        'language': locale,
      },
    );
    return result;
  }

  Future<bool> isFavorite(int movieId, String sessionId) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = jsonMap['favorite'] as bool;
      return result;
    }
    final result = _networkClient.get(
      '/movie/$movieId/account_states',
      parser,
      {
        'api_key': ApiConfiguration.apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }
}
