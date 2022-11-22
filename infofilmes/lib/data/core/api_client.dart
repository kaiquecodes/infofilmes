import 'dart:convert';
import 'dart:io';
import 'package:infofilmes/data/core/api_configurations.dart';
import 'package:infofilmes/data/core/api_client_exception.dart';

class ApiClient {
  final _client = HttpClient();

   Uri _makeUri(String path, [Map<String, dynamic>? parameters]) {
    final uri = Uri.parse('${ApiConfiguration.host}$path');
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    } else {
      return uri;
    }
  }
  
  Future<T> get<T>(String path, T Function(dynamic json) parser,
      [Map<String, dynamic>? parameters]) async {
    final url = _makeUri(path, parameters);
    try {
      final request = await _client.getUrl(url);
      final response = await request.close();
      final dynamic json = await _jsonParse(response);
      _validateResponse(response, json);
      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (_) {
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

Future<T> post<T>(
    String path,
    T Function(dynamic json) parser,
    Map<String, dynamic>? bodyParameters, [
    Map<String, dynamic>? urlParameters,
  ]) async {
    try {
      final url = _makeUri(path, urlParameters);
      final request = await _client.postUrl(url);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(bodyParameters));
      final response = await request.close();

      final dynamic json = await _jsonParse(response);
      _validateResponse(response, json);

      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (_) {
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  void _validateResponse(HttpClientResponse response, dynamic json) {
    if (response.statusCode == 401) {
      final dynamic status = json['status_code'];
      final code = status is int ? status : 0;
      if (code == 30) {
        throw ApiClientException(ApiClientExceptionType.auth);
      } else if (code == 3) {
        throw ApiClientException(ApiClientExceptionType.sessionExpired);
      } else {
        throw ApiClientException(ApiClientExceptionType.other);
      }
    }
  }

  Future<dynamic> _jsonParse(HttpClientResponse response) async {
    return await response
        .transform(utf8.decoder)
        .toList()
        .then((value) => value.join())
        .then<dynamic>((val) => jsonDecode(val));
  }
}