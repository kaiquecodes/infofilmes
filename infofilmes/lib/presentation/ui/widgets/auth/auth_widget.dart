import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:infofilmes/presentation/ui/widgets/auth/auth_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/constants/constants.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tertiary,
      body: SingleChildScrollView(child: SafeArea(
          child: Container(
            child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                _FormWidget()
              ],
            ),
          )
        ),
      ),
    ));
  }
}


class _FormWidget extends StatelessWidget {
  const _FormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AuthModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.height/1.5,
          height: MediaQuery.of(context).size.width/1.5,
          child: SvgPicture.asset("assets/images/logo_login.svg"),
        ),
        const SizedBox(height: 5),
        TextField(
          style: const TextStyle(color: tertiaryText),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            hintStyle: const TextStyle(color: tertiaryText),
            hintText: 'Login',
            prefixIcon: Icon(
              Icons.person,
              color: black.withOpacity(.8),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          controller: model.loginTextController,
        ),
        const SizedBox(height: 10),
        TextField(
          style: const TextStyle(color: tertiaryText),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            hintText: 'Senha',
            hintStyle: const TextStyle(color: secondaryText),
            prefixIcon: Icon(Icons.lock, color: black.withOpacity(.8)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          obscureText: true,
          controller: model.passwordTextController,
        ),
        const SizedBox(height: 20),
        const _AuthButtonWidget(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AppText(
              size: 16,
              text: 'Ainda não tem uma conta?',
              color: tertiaryText,
            ),
            TextButton(
              onPressed: () async {
                const url = "https://www.themoviedb.org/signup";
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  showSnackBar(
                      context, 'Problema com a URL',
                      color: Colors.red);
                }
              },
              child: AppText(
                isBold: FontWeight.bold,
                color: const Color(0xff0245b6),
                size: 16,
                text: 'Criar conta',
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _AuthButtonWidget extends StatelessWidget {
  const _AuthButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AuthModel>();
    final onPressed = model.canStartAuth ? () => model.auth(context) : null;
    final btnBackground = model.isAuthProgress
        ? MaterialStateProperty.all(buttonColor.withOpacity(.5))
        : MaterialStateProperty.all(buttonColor);
    final child = model.isAuthProgress
        ? const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              color: white,
              strokeWidth: 2,
            ),
          )
        : AppText(
            isBold: FontWeight.bold,
            size: 16,
            text: 'Entrar',
            color: white,
          );
    return SizedBox(
      width: double.maxFinite,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
          backgroundColor: btnBackground,
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 15)),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
