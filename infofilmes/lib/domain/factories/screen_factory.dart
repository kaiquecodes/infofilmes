import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infofilmes/presentation/ui/widgets/auth/auth_model.dart';
import 'package:infofilmes/presentation/ui/widgets/auth/auth_widget.dart';
import 'package:infofilmes/presentation/ui/widgets/favorites/favorite_model.dart';
import 'package:infofilmes/presentation/ui/widgets/favorites/favorite_widget.dart';
import 'package:infofilmes/presentation/ui/widgets/loader/loader_model.dart';
import 'package:infofilmes/presentation/ui/widgets/loader/loader_widget.dart';

import 'package:infofilmes/presentation/ui/widgets/movie_details/movie_details_model.dart';
import 'package:infofilmes/presentation/ui/widgets/movie_details/movie_details_widget.dart';
import 'package:infofilmes/presentation/ui/widgets/movie_list/movie_search_model.dart';
import 'package:infofilmes/presentation/ui/widgets/movie_list/movie_search_widget.dart';
import 'package:infofilmes/presentation/ui/widgets/main_ui/main_screen_model.dart';
import 'package:infofilmes/presentation/ui/widgets/main_ui/main_screen_widget.dart';
import '../../presentation/ui/widgets/bottom-navigation/bottom_navigation_widget.dart';

class ScreenFactory {
  Widget makeLoader() {
    return Provider(
      create: (context) => LoaderModel(context),
      child: const LoaderWidget(),
      lazy: false,
    );
  }

  Widget makeAuth() {
    return ChangeNotifierProvider(
      create: (_) => AuthModel(),
      child: const AuthWidget(),
    );
  }

  Widget makeMainScreen() {
    return const  BottomNavigationWidget();
  }

  Widget makeMovieDetails(int movieId) {
    return ChangeNotifierProvider(
      create: (_) => MovieDetailsModel(movieId: movieId),
      child: const MovieDetailsWidget(),
    );
  }

  Widget makeNewsList() {
    return ChangeNotifierProvider(
      create: (_) => MainScreenModel(),
      child: const MainScreenWidget(),
    );
  }

  Widget makeMovieList() {
    return ChangeNotifierProvider(
      create: (_) => MovieSearchModel(),
      child: const MovieSearchWidget(),
    );
  }

  Widget makeFavorite() {
    return ChangeNotifierProvider(
      create: (_) => FavoriteModel(),
      child: const FavoriteWidget(),
    );
  }
}
