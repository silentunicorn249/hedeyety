import 'package:flutter/material.dart';
import 'package:hedeyety/features/auth/presentation/widgets/main_button.dart';

import '../../../../core/routes/routes.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Image.asset('images/logo.png'),
                  height: 110,
                ),
                const SizedBox(
                  width: 1,
                ),
                const Text(
                  "Hedeyety",
                  style: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.black),
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            MainButton(
              key: const ValueKey("loginButton"),
              text: "Log in",
              clbFn: () {
                Navigator.pushNamed(context, AppRoutes.login);
              },
              color: Colors.lightBlueAccent,
            ),
            MainButton(
              key: const Key("signupButton"),
              clbFn: () {
                Navigator.pushNamed(context, AppRoutes.signup);
              },
              text: "Sign up",
              color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
