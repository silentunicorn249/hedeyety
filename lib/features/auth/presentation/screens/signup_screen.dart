import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../core/routes/routes.dart';
import '../../data/models/user_model.dart';
import '../widgets/main_button.dart';
import '../widgets/main_textinput.dart';

class SignupScreen extends StatefulWidget {
  static String id = "register_screen";

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool showSpin = false;
  late String email;
  late String name;
  late String password;
  late String phoneNo;

  void handleSignup() async {
    print("Email $email, password: $password");
    setState(() {
      showSpin = true;
    });
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final custUser = UserModel(
        id: newUser.user!.uid,
        name: name,
        phoneNo: phoneNo,
        email: email,
        preferences: {},
      );
      await _firestore
          .collection('users')
          .doc(custUser.id)
          .set(custUser.toJson());
      Navigator.pushNamed(context, AppRoutes.homeStack);
      setState(() {
        showSpin = false;
      });
      // newUser.
    } on FirebaseAuthException catch (e) {
      print("Error: ${e.code}");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
      setState(() {
        showSpin = false;
      });
    } catch (e) {
      print("Else");
      setState(() {
        showSpin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpin,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: "logo",
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.jpg'),
                  ),
                ),
              ),
              const SizedBox(height: 48.0),
              MainTextInput(
                hintText: "Enter your email",
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => email = value,
              ),
              const SizedBox(height: 8.0),
              MainTextInput(
                hintText: "Enter your name",
                onChanged: (value) => name = value,
              ),
              const SizedBox(height: 8.0),
              MainTextInput(
                hintText: "Enter your phone number",
                keyboardType: TextInputType.phone,
                onChanged: (value) => phoneNo = value,
              ),
              const SizedBox(height: 8.0),
              MainTextInput(
                hintText: "Enter your password",
                isObscure: true,
                onChanged: (value) => password = value,
              ),
              const SizedBox(height: 24.0),
              MainButton(
                clbFn: handleSignup,
                color: Colors.blueAccent,
                text: "Register",
              ),
              MainButton(
                clbFn: () {
                  Navigator.pop(context);
                },
                color: Colors.blueGrey,
                text: "Go Back",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
