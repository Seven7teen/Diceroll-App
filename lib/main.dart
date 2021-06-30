import 'package:diceroll/screens/loginpage.dart';
import 'package:diceroll/screens/registrationpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:diceroll/screens/gamepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: RegistrationScreen(),
  ));
}
