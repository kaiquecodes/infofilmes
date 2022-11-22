import 'package:flutter/material.dart';
import 'package:infofilmes/data/repositories/auth_repository.dart';
import 'package:infofilmes/presentation/ui/navigation/main_navigation.dart';
import '../../../../data/core/api_client_exception.dart';
import '../../../common/constants/constants.dart';

class AuthModel extends ChangeNotifier {
  final _authService = AuthRepository();
  //conta cadastrada no TMBD para testes
  final loginTextController = TextEditingController(text: 'kaiquered');
  final passwordTextController = TextEditingController(text: '2307');

  bool _isAuthProgress = false;
  bool get isAuthProgress => _isAuthProgress;
  bool get canStartAuth => !_isAuthProgress;

  bool _isValid(String login, String password) =>
      login.isNotEmpty && password.isNotEmpty;

  Future<void> _login(
    String login,
    String password,
    BuildContext context,
  ) async {
    try {
      await _authService.login(login, password);
    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.network:
          showSnackBar(
              context, 'O servidor não está disponível. Verifique a sua conexão com a internet.',
              color: Colors.red);
          break;
        case ApiClientExceptionType.auth:
          showSnackBar(context, 'Nome de usuário e senha estão incorretos', color: Colors.red);
          break;
        case ApiClientExceptionType.other:
          showSnackBar(context, 'Ocorreu um erro. Tente novamente.',
              color: Colors.red);
          break;
        case ApiClientExceptionType.sessionExpired:
      }
    } catch (e) {
      showSnackBar(context, 'Erro desconhecido.', color: Colors.red);
    }
  }

  Future<void> auth(BuildContext context) async {
    final login = loginTextController.text;
    final password = passwordTextController.text;

    if (!_isValid(login, password)) {
      showSnackBar(context, 'Digite seu login e senha', color: Colors.red);
      notifyListeners();
      return;
    }

    _isAuthProgress = true;
    notifyListeners();
    await _login(login, password, context);

    _isAuthProgress = false;
    notifyListeners();
    MainNavigation.resetNavigation(context);
  }
}
