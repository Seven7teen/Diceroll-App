import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WinnerScreen extends StatefulWidget {
  var winmap;
  var mapp;

  WinnerScreen(this.winmap, this.mapp);

  @override
  _WinnerScreenState createState() => _WinnerScreenState();
}

class _WinnerScreenState extends State<WinnerScreen> {
  // List<Card> list = [];

  // CollectionReference refer = FirebaseFirestore.instance.collection('map');
  //

  //
  // void getmap() async {
  //   await refer.doc('mapping').get().then((value) {
  //     mapp = value['mp'];
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // getmap();
    // print(mapp);
  }

  @override
  Widget build(BuildContext context) {
    var winList = widget.winmap.entries.toList();
    int itemCount = winList.length;
    print(itemCount);
    print(widget.winmap);
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: itemCount > 0
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: itemCount,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(
                    Icons.auto_awesome,
                    size: 20.0,
                    color: Colors.pink,
                  ),
                  title: Text(
                    '${widget.mapp[winList[index].key]}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  subtitle: Text(
                    '${winList[index].key}',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 15,
                        color: Colors.blueGrey),
                  ),
                  trailing: Text(
                    '${winList[index].value}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.red),
                  ),
                );
              },
            )
          : const Center(child: Text('No items')),
    );
  }
}
