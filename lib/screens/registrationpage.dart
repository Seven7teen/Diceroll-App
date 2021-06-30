import 'package:diceroll/screens/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:diceroll/constants.dart';
import 'package:diceroll/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diceroll/components/Mapping.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  static var map_email_username = {};
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  String username;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ProgressHUD(
        child: Builder(
          builder: (context) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/dice roll.gif'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  onChanged: (value) {
                    username = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your username',
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your email',
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password',
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  colour: Colors.blueAccent,
                  text: 'Register',
                  onPressed: () async {
                    final progress = ProgressHUD.of(context);
                    setState(() {
                      progress.show();
                    });
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      if (newUser != null) {
                        UserData userdata = new UserData(
                          username: username,
                          userEmail: email,
                        );
                        await userdata.addToCloud();

                        RegistrationScreen.map_email_username[email] = username;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      }
                      setState(() {
                        progress.dismiss();
                      });
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Text('Already registered!'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
