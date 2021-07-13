import 'dart:ui';

import 'package:diceroll/screens/winnerpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:diceroll/screens/gamepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diceroll/components/diceCount_mapping.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatelessWidget {
  int dicecount;
  SplashScreen(this.dicecount);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/Ace.gif'), fit: BoxFit.cover)),
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                constraints: BoxConstraints.tightFor(height: 230, width: 350),
                color: Colors.yellow[100],
                // decoration: BoxDecoration(
                //     image: DecorationImage(
                //         image: AssetImage('images/gamegif.gif'),
                //         fit: BoxFit.cover)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You Won',
                      style: TextStyle(
                          fontSize: 50,
                          color: Colors.red,
                          fontFamily: 'PermanentMarker'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'You took $dicecount steps to reach the 64th block.',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Restart'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            WinData windata = new WinData(
                                cnt: dicecount, userEmail: loggedInUser.email);
                            await windata.paddToCloud();
                            CollectionReference refer =
                                FirebaseFirestore.instance.collection('Win');
                            var winmap;
                            await refer.doc('winner').get().then((value) {
                              winmap = value['gameWinner'];
                            });
                            CollectionReference ref =
                                FirebaseFirestore.instance.collection('map');
                            var mapp;
                            await ref.doc('mapping').get().then((value) {
                              mapp = value['mp'];
                            });
                            print(winmap);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        WinnerScreen(winmap, mapp)));
                          },
                          child: Text('Leaderboard'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                          child: Text('Quit Game'),
                        ),
                      ],
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
