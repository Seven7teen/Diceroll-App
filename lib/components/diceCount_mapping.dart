import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:diceroll/components/Mapping.dart';

class WinData {
  int cnt;
  String userEmail;

  WinData({this.cnt, this.userEmail});

  Future paddToCloud() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('Win');
    var map;
    await ref.doc('winner').get().then((value) {
      map = value['gameWinner'];
    });
    // if (map[userEmail] == 0)
    if (map.containsKey(userEmail.toLowerCase())) {
      if (map[userEmail.toLowerCase()] > cnt)
        map[userEmail.toLowerCase()] = cnt;
    } else
      map[userEmail.toLowerCase()] = cnt;
    // else {
    //   if (map[userEmail] > cnt) map[userEmail] = cnt;
    // }
    print(map);
    await ref.doc('winner').update({
      'gameWinner': map,
    });
  }
}
