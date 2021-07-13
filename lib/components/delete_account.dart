import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Del_user {
  String email;
  Del_user(this.email);

  Future delCloud() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('map');
    Map map;
    await ref.doc('mapping').get().then((value) {
      map = value['mp'];
    });
    print(map);
    map.remove(email.toLowerCase());
    print(map);
    await ref.doc('mapping').update({
      'mp': map,
    });

    CollectionReference refer = FirebaseFirestore.instance.collection('Win');
    var mapp;
    await refer.doc('winner').get().then((value) {
      mapp = value['gameWinner'];
    });
    if (mapp.containsKey(email.toLowerCase())) {
      mapp.remove(email.toLowerCase());
    }
    print(mapp);
    await refer.doc('winner').update({
      'gameWinner': mapp,
    });
  }
}
