import 'package:json_annotation/json_annotation.dart';
import 'package:infofilmes/domain/entity/movie.dart';

part 'movie_response.g.dart';

@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class MovieResponse {
  final int page;
  @JsonKey(name: 'results')
  final List<Movie> movies;
  final int totalResults;
  final int totalPages;

  MovieResponse({
    required this.movies,
    required this.page,
    required this.totalPages,
    required this.totalResults,
  });
  factory MovieResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieResponseToJson(this);
}
