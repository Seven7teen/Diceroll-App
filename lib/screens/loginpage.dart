import 'package:diceroll/screens/gamepage.dart';
import 'package:flutter/material.dart';
import 'package:diceroll/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:diceroll/components/input_text.dart';
import 'package:diceroll/screens/registrationpage.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;

  final email_c = TextEditingController();
  final pass_c = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 50),
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
                            height: 200,
                            child: Image.asset('images/dice roll.gif')),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    InputText(
                      controller: email_c,
                      ontap: (value) {
                        email = value;
                      },
                      hintText: 'Enter your email',
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    InputText(
                      controller: pass_c,
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
                      colour: Colors.lightBlueAccent,
                      text: 'Log In',
                      onPressed: () async {
                        final progress = ProgressHUD.of(context);
                        setState(() {
                          email_c.clear();
                          pass_c.clear();
                          // showSpinner = true;
                          progress.showWithText('...Loading');
                        });
                        try {
                          final user = await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                          if (user != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyApp()));
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
                                  onPressed: () => Navigator.pop(context, 'OK'),
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
                            'Dont have an account?',
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
                                  RegistrationScreen.id,
                                  ModalRoute.withName(LoginScreen.id));
                            },
                            child: Text(
                              'Register',
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
    );
  }
}
