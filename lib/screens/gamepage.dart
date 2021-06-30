import 'package:flutter/material.dart';
import 'package:diceroll/screens/splashpage.dart';
import 'dart:math';
import 'package:diceroll/components/DiceImages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:diceroll/screens/registrationpage.dart';

User loggedInUser;
var mp = RegistrationScreen.map_email_username;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int dicecount = 0;
  int p = 0, q = 0;
  int f = 1;
  int t = 1;
  final _auth = FirebaseAuth.instance;
  List<List<String>> gridState = [
    ['P1', 'T', '', '', '', '', '', ''],
    ['', '', '', 'T', '', '', '', ''],
    ['B', 'T', '', '', '', 'B', '', ''],
    ['', '', '', 'T', '', '', '', ''],
    ['', '', '', 'T', '', '', '', ''],
    ['', '', '', 'T', '', '', '', ''],
    ['', '', '', 'T', '', '', '', ''],
    ['', '', '', 'T', '', '', '', 'P2'],
  ];

  Future onGoBack(dynamic value) {
    setState(() {
      gridState[p][q] = '';
      dicecount = 0;
      p = 0;
      q = 0;
      f = 1;
      t = 1;
      gridState[p][q] = 'P1';
    });
  }

  void updateGrid() {
    new Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        gridState[p][q] = '';
      });
      // if (q + t >= gridState.length && p == gridState.length - 1) {
      //   p = 0;
      //   q = 0;
      // } else if (q + t >= gridState.length) {
      //   p += 1;
      //   q = q + t - gridState.length;
      // } else {
      //   q += t;
      // }
      p = gridState.length - 1;
      q = gridState.length - 1;
      setState(() {
        gridState[p][q] = 'P1';
        dicecount++;
      });
      new Future.delayed(const Duration(seconds: 1), () {
        if (p == gridState.length - 1 && q == gridState.length - 1) {
          Route route =
              MaterialPageRoute(builder: (context) => SplashScreen(dicecount));
          Navigator.push(context, route).then(onGoBack);
        }
      });
    });
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('LUDO'),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: DiceImage(f: f),
                onTap: () {
                  setState(() {
                    f = 7;
                    t = Random().nextInt(6) + 1;
                    updateGrid();
                  });
                  new Future.delayed(const Duration(seconds: 2), () {
                    setState(() {
                      f = t;
                    });
                  });
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => SplashScreen()));
                },
              ),
              Container(
                child: Text(
                  '$t',
                  style: TextStyle(fontSize: 50),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                height: 500,
                width: 500,
                color: Colors.green,
                child: Container(child: buildGameBody()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGameBody() {
    int gridStateLength = gridState.length;
    return Column(children: <Widget>[
      AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2.0)),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridStateLength,
            ),
            itemBuilder: buildGridItems,
            itemCount: gridStateLength * gridStateLength,
          ),
        ),
      ),
    ]);
  }

  Widget buildGridItems(BuildContext context, int index) {
    // print(index);
    int gridStateLength = gridState.length;
    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    return GridTile(
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
        child: Center(
          child: buildGridItem(x, y),
        ),
      ),
    );
  }

  Widget buildGridItem(int x, int y) {
    switch (gridState[x][y]) {
      case '':
        return Text('');
        break;
      case 'P1':
        return Container(
          color: Colors.blue,
        );
        break;
      case 'P2':
        return Container(
          color: Colors.yellow,
        );
        break;
      case 'T':
        return Icon(
          Icons.terrain,
          size: 40.0,
          color: Colors.red,
        );
        break;
      case 'B':
        return Icon(Icons.remove_red_eye, size: 40.0);
        break;
      default:
        return Text(gridState[x][y].toString());
    }
  }
}
