import 'package:infofilmes/data/data_source/api_client/account_api_client.dart';
import 'package:infofilmes/domain/data_providers/session_data_provider.dart';
import 'package:infofilmes/domain/entity/movie_response.dart';

class FavoriteRepository  {
  final _accountApiClient = AccountApiClient();
  final _sessionDataProvider = SessionDataProvider();

  Future<MovieResponse> favoriteMovies(String locale) async {

    final accountId = await _sessionDataProvider.getAccountId();
    final sessionId = await _sessionDataProvider.getSessionId();
    return await _accountApiClient.getFavoriteMovies(
      language: locale,
      accountId: accountId.toString(),
      sessionId: sessionId.toString(),
    );
  }
  Future<int> markMovies(bool newFavoriteValue, int mediaId) async {
    final accountId = await _sessionDataProvider.getAccountId();
    final sessionId = await _sessionDataProvider.getSessionId();

    return await _accountApiClient.markIsFavorite(
      accountId: accountId.toString(),
      sessionId: sessionId.toString(),
      mediaId: mediaId,
      favorite: newFavoriteValue

    );
  }
}
