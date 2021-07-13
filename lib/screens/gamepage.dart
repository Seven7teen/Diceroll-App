import 'package:diceroll/components/input_text.dart';
import 'package:diceroll/screens/loginpage.dart';
import 'package:diceroll/screens/registrationpage.dart';
import 'package:flutter/material.dart';
import 'package:diceroll/screens/splashpage.dart';
import 'dart:math';
import 'package:diceroll/components/DiceImages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:diceroll/screens/winnerpage.dart';
import 'package:diceroll/components/diceCount_mapping.dart';
import 'package:diceroll/screens/welcomepage.dart';
import 'package:diceroll/components/Mapping.dart';
import 'package:diceroll/components/delete_account.dart';

User loggedInUser;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int dicecount = 0;
  int p = 0, q = 0;
  int f = 1;
  int t = 1;
  int r, s;

  final _auth = FirebaseAuth.instance;
  List<List<String>> gridState = [
    ['P1', '', '', '', '', '', '', ''],
    ['', '', 'x', '', '', '', '', ''],
    ['', 'x', 'x', '', '', 'x', '', ''],
    ['', '', '', '', '', 'x', '', ''],
    ['', '', 'x', '', '', 'x', '', ''],
    ['', '', '', '', '', '', '', ''],
    ['x', '', '', '', '', '', '', ''],
    ['', '', 'x', '', '', 'x', '', 'P2'],
  ];
  List<List<String>> constgridState = [
    ['', '', '', '', '', '', '', ''],
    ['', '', 'x', '', '', '', '', ''],
    ['', 'x', 'x', '', '', 'x', '', ''],
    ['', '', '', '', '', 'x', '', ''],
    ['', '', 'x', '', '', 'x', '', ''],
    ['', '', '', '', '', '', '', ''],
    ['x', '', '', '', '', '', '', ''],
    ['', '', 'x', '', '', 'x', '', 'P2'],
  ];

  void restart() {
    setState(() {
      gridState[p][q] = 'P2';
      dicecount = 0;
      p = 0;
      q = 0;
      f = 1;
      t = 1;
      gridState[p][q] = 'P1';
    });
  }

  void updateGrid() {
    // new Future.delayed(const Duration(seconds: 2), () {
    setState(() {
      r = p;
      s = q;
      if (q + t >= gridState.length && p == gridState.length - 1) {
        p = 0;
        q = 0;
      } else if (q + t >= gridState.length) {
        if (gridState[p + 1][q + t - gridState.length] == 'x') {
          p = 0;
          q = 0;
        } else {
          p += 1;
          q = q + t - gridState.length;
        }
        // else if (gridState[p][q] == 'o') {
        //   q = gridState.length - 1;
        // }
      } else {
        q += t;
      }
      gridState[p][q] = 'P1';
      gridState[r][s] = constgridState[r][s];
      dicecount++;
    });
    if (p == gridState.length - 1 && q == gridState.length - 1) {
      // new Future.delayed(const Duration(seconds: 2), () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SplashScreen(dicecount)));
      // });
    }
    // });
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
    restart();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // backgroundColor: Colors.yellow[100],
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('DICEROLL'),
              Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.refresh_outlined,
                      ),
                      iconSize: 30,
                      onPressed: () {
                        restart();
                      }),
                  IconButton(
                    icon: Icon(
                      Icons.info_rounded,
                    ),
                    iconSize: 30,
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title:
                            const Text('Do you want to delete your account?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () async {
                              Del_user del_user =
                                  new Del_user(loggedInUser.email);
                              await del_user.delCloud();
                              UserData userdata = new UserData();
                              await userdata.deleteAccount();
                              Navigator.popUntil(
                                context,
                                ModalRoute.withName(LoginScreen.id),
                              );
                            },
                            child: const Text('Delete'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('No'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.leaderboard,
                    ),
                    iconSize: 30,
                    onPressed: () async {
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
                          builder: (context) => WinnerScreen(winmap, mapp),
                        ),
                      );
                    },
                  ),
                  // SizedBox(width: 5.0),
                  IconButton(
                    icon: Icon(
                      Icons.power_settings_new_outlined,
                    ),
                    iconSize: 30,
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Do you want to Sign Out?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.popUntil(
                                  context, ModalRoute.withName(LoginScreen.id));
                            },
                            child: const Text('Sign Out'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('No'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 50),
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/gamegif.gif'), fit: BoxFit.cover)),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                height: 400,
                width: 500,
                color: Colors.white,
                child: Container(child: buildGameBody()),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    child: DiceImage(f: f),
                    onTap: () {
                      setState(() {
                        f = 7;
                        t = Random().nextInt(6) + 1;
                      });
                      updateGrid();
                      // new Future.delayed(const Duration(seconds: 2), () {
                      setState(() {
                        f = t;
                        // });
                      });
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => SplashScreen()));
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: Text(
                      '$dicecount',
                      style: TextStyle(fontSize: 50),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
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
        return Icon(
          Icons.circle,
          size: 40.0,
          color: Colors.yellow[700],
        );
        break;
      case 'P2':
        return Icon(
          Icons.flag,
          size: 40.0,
          color: Colors.red,
        );
        break;
      case 'x':
        return Icon(
          Icons.warning_rounded,
          size: 40.0,
          color: Colors.red,
        );
        break;
      // case 'o':
      //   return Icon(
      //     Icons.data_usage,
      //     size: 30.0,
      //     color: Colors.green,
      //   );
      //   break;
      default:
        return Text(gridState[x][y].toString());
    }
  }
}
