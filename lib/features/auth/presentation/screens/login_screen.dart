import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedeyety/core/routes/routes.dart';
import 'package:hedeyety/features/auth/data/datasources/user_repo_local.dart';
import 'package:hedeyety/features/events/data/datasources/event_repo_local.dart';
import 'package:hedeyety/features/events/data/datasources/event_repo_remote.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../events/presentation/providers/friends_provider.dart';
import '../../../profile/data/datasources/friends_repo_remote.dart';
import '../widgets/main_button.dart';
import '../widgets/main_textinput.dart';

class LoginScreen extends StatefulWidget {
  static String id = "login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  final _auth = FirebaseAuth.instance;
  bool showSpin = false;

  void handleLogin() async {
    print("Email $email, password: $password");
    setState(() {
      showSpin = true;
    });
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final remo = FriendRepoRemote();
      final local = UserRepoLocal();
      var userId = user.user!.uid;
      final friends = await remo.getFriendsAsUsers(userId);
      final friendsProvider =
          Provider.of<FriendsProvider>(context, listen: false);

      for (var friend in friends) {
        debugPrint("${friend.id} > ${friend.email}");
        await friendsProvider.addUser(friend);
      }

      final remoEve = EventRepoRemote();
      final remoEvs = await remoEve.getEventsByUserId(userId);
      final localEve = EventRepoLocal();

      for (var event in remoEvs) {
        localEve.saveEvent(event);
      }

      final res = await local.getALlUsers();
      for (var r in res) {
        debugPrint("${r.id} > ${r.phoneNo}");
      }
      Navigator.pushNamed(context, AppRoutes.homeStack);
    } on FirebaseAuthException catch (e) {
      print("Error: ${e.code}");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
      setState(() {
        showSpin = false;
      });
    } catch (e) {
      print(e);
    } finally {
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
              const SizedBox(
                height: 48.0,
              ),
              MainTextInput(
                hintText: "Enter your email",
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => email = value,
              ),
              const SizedBox(
                height: 8.0,
              ),
              MainTextInput(
                hintText: "Enter your password",
                isObscure: true,
                onChanged: (value) => password = value,
              ),
              const SizedBox(
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
      ),
    );
  }
}
