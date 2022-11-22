import 'package:flutter/cupertino.dart';
import 'package:infofilmes/data/repositories/auth_repository.dart';
import 'package:infofilmes/presentation/ui/navigation/main_navigation.dart';

class LoaderModel {
  final BuildContext context;
  final _authService = AuthRepository();

  LoaderModel(this.context) {
    asyncInit();
  }

  Future<void> asyncInit() async {
    await checkAuth();
  }

  Future<void> checkAuth() async {
    final isAuth = await _authService.isAuth();
    final nextScreen = isAuth
        ? MainNavigationRouteNames.mainScreen
        : MainNavigationRouteNames.auth;
    Navigator.of(context).pushReplacementNamed(nextScreen);
  }
}
