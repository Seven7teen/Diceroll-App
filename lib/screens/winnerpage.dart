import 'package:diceroll/screens/registrationpage.dart';
import 'package:flutter/material.dart';
import 'package:diceroll/components/Mapping.dart';

var mp = RegistrationScreen.map_email_username;

class WinnerScreen extends StatelessWidget {
  var mapp;
  WinnerScreen(this.mapp);
  @override
  Widget build(BuildContext context) {
    print(mapp);

    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: Center(
        child: Text(
          'winners',
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}
