import 'package:diceroll/screens/winnerpage.dart';
import 'package:flutter/material.dart';
import 'package:diceroll/screens/gamepage.dart';
import 'package:diceroll/screens/registrationpage.dart';
import 'package:diceroll/components/Mapping.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// var mp = map_email_username;

class SplashScreen extends StatelessWidget {
  int dicecount;
  SplashScreen(this.dicecount);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.lightBlueAccent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'you won',
                style: TextStyle(fontSize: 60),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('press'),
              ),
              Text(
                '$dicecount ${loggedInUser.email} ',
                // ${mp[loggedInUser.email]}
                style: TextStyle(fontSize: 60),
              ),
              ElevatedButton(
                onPressed: () async {
                  // UserData userdata;
                  // var mapp = await userdata.getList();
                  CollectionReference ref =
                      FirebaseFirestore.instance.collection('map');
                  var map;
                  await ref.doc('mapping').get().then((value) {
                    map = value['mp'];
                  });
                  print(map);
                  var entryList = map.entries.toList();
                  print(entryList[0].key);
                  print(entryList[0].value);
                  print(entryList[1].key);
                  print(entryList[1].value);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WinnerScreen(map)));
                },
                child: Text('Leaderboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
