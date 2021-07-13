import 'package:diceroll/screens/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:diceroll/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:diceroll/components/Mapping.dart';
import 'dart:core';
import 'package:diceroll/components/input_text.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
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
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/login bc.gif'), fit: BoxFit.cover),
            ),
            child: ProgressHUD(
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
                        height: 30.0,
                      ),
                      InputText(
                        ontap: (value) {
                          username = value;
                        },
                        hintText: 'Enter your username',
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person_outline_outlined),
                      ),
                      InputText(
                        ontap: (value) {
                          email = value;
                        },
                        hintText: 'Enter your email',
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      InputText(
                        ontap: (value) {
                          password = value;
                        },
                        hintText: 'Enter your password',
                        labelText: 'password',
                        prefixIcon: Icon(Icons.vpn_key_outlined),
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
                              email: email,
                              password: password,
                            );
                            if (newUser != null) {
                              UserData userdata = new UserData(
                                username: username,
                                userEmail: email,
                              );
                              await userdata.addToCloud();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                            }
                            setState(() {
                              progress.dismiss();
                            });
                          } catch (e) {
                            String s = e.toString(), str = '';
                            int i = 0;
                            while (i < s.length && s[i] != ']') {
                              i++;
                            }
                            i += 2;
                            while (i < s.length) {
                              str += s[i];
                              i++;
                            }
                            print(str);
                            showDialog<String>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(str),
                                // content: const Text('Stay in Touch...'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            );
                            setState(() {
                              progress.dismiss();
                            });
                            print(e);
                          }
                        },
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Already have an account?',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    LoginScreen.id,
                                    ModalRoute.withName(RegistrationScreen.id));
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
