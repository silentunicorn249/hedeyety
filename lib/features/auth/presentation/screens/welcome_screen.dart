import 'package:flutter/material.dart';
import 'package:hedeyety/features/auth/presentation/widgets/main_button.dart';

import '../../../../core/routes/routes.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Image.asset('images/logo.jpg'),
                  height: 80,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Hedeyety",
                  style: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            MainButton(
              text: "Log in",
              clbFn: () {
                Navigator.pushNamed(context, AppRoutes.login);
              },
              color: Colors.lightBlueAccent,
            ),
            MainButton(
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
