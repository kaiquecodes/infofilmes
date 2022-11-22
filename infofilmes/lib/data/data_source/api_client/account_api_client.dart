import 'package:infofilmes/data/core/api_configurations.dart';
import 'package:infofilmes/data/core/api_client.dart';
import 'package:infofilmes/domain/entity/movie_response.dart';

class AccountApiClient {
  final _networkClient = ApiClient();

  Future<int> getAccountInfo(String sessionId) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = jsonMap['id'] as int;
      return result;
    }
    final result = _networkClient.get(
      '/account',
      parser,
      {
        'api_key': ApiConfiguration.apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }

  Future<MovieResponse> getFavoriteMovies({
    required String accountId,
    required String sessionId,
    required String language,
  }) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieResponse.fromJson(jsonMap);
      return response;
    }
    final result = _networkClient.get(
      '/account/${accountId.toString()}/favorite/movies',
      parser,
      {
        'api_key': ApiConfiguration.apiKey,
        'session_id': sessionId,
        'language': language
      },
    );
    return result;
  }

  Future<int> markIsFavorite({
    required String accountId,
    required String sessionId,
    required int mediaId,
    required bool favorite,
  }) async {
    parser(dynamic json) {
      return 1;
    }

    final parametrs = <String, dynamic>{
      'media_type': 'movie',
      'media_id': mediaId,
      'favorite': favorite,
    };
    final result = _networkClient.post(
      '/account/$accountId.toString()/favorite',
      parser,
      parametrs,
      {
        'api_key': ApiConfiguration.apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }
}
