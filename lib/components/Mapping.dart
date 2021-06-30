import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  String username;
  String userEmail;

  UserData({this.username, this.userEmail});

  Future addToCloud() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('map');
    var map;
    await ref.doc('mapping').get().then((value) {
      map = value['mp'];
    });
    print(map);
    map[userEmail] = username;
    print(map);
    await ref.doc('mapping').update({
      'mp': map,
    });
  }

  // Future getlist() async {
  //   CollectionReference ref = FirebaseFirestore.instance.collection('map');
  //   var mapp;
  //   await ref.doc('mapping').get().then((value) {
  //     mapp = value['mp'];
  //   });
  //   print(mapp);
  //   return mapp;
  // }

  Future deleteAccount() async {
    User user = await FirebaseAuth.instance.currentUser;
    user.delete();
  }

  Future changePassword(String password) async {
    User user = await FirebaseAuth.instance.currentUser;
    //Pass in the password to updatePassword.
    user.updatePassword(password).then((_) {
      print("Successfully changed password");
    }).catchError((error) {
      print("Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
    // }
  }
}
