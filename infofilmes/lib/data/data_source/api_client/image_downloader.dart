import 'package:infofilmes/data/core/api_configurations.dart';

class ImageDownloader {
  static String imageUrl(String path) => ApiConfiguration.imageUrl + path;
}
