import 'package:flutter/material.dart';
import 'package:hedeyety/routes.dart';

import '../components/main_button.dart';

class LoginScreen extends StatefulWidget {
  static String id = "login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;

  void handleLogin() {
    Navigator.pushNamed(context, AppRoutes.homeStack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.jpg'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            MainTextInput(
              onChange: (value) {
                email = value;
              },
              hintText: "Enter your email",
            ),
            SizedBox(
              height: 8.0,
            ),
            MainTextInput(
              onChange: (value) {
                password = value;
              },
              hintText: "Enter your password",
              hidden: true,
            ),
            SizedBox(
              height: 24.0,
            ),
            MainButton(
              clbFn: handleLogin,
              color: Colors.lightBlueAccent,
              text: "Log in",
            ),
            MainButton(
              clbFn: () {
                //Implement registration functionality.
                Navigator.pop(context);
              },
              color: Colors.blueGrey,
              text: "Go Back",
            ),
          ],
        ),
      ),
    );
  }
}

class MainTextInput extends StatelessWidget {
  late ValueChanged<String> onChange;
  late String hintText;
  bool hidden = false;

  MainTextInput({
    required this.onChange,
    required this.hintText,
    this.hidden = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: hidden,
      keyboardType: TextInputType.emailAddress,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.black),
      onChanged: onChange,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
    );
  }
}
