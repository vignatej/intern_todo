import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intern_todo/resources/storageMethods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String,dynamic>> getUserDetails() async {
    User CurrentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('Users').doc(CurrentUser.uid).get();
    return {"Username":snap["Username"],
          "password":snap["Password"],
          "email":snap["email"],
          "photourl":snap["photoUrl"]
          };
  }

  Future<String> SignUpUser({
    required String Username,
    required String Password,
    required String email,
    required String MobileNum,
    required Uint8List profilepic,
  }) async {
    String res = "initial one";
    try {
      if (email.isNotEmpty && Password.isNotEmpty && Username.isNotEmpty && MobileNum.isNotEmpty && profilepic!=Null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: Password);
        String PhotoUrl = await StorageMethods().UploadImageToStorage("profilePic", profilepic);
        
        await _firestore.collection("Users").doc(cred.user!.uid).set({
          "Username": Username,
          "Password": Password,
          "email": email,
          "MobileNum":MobileNum,
          "photoUrl": PhotoUrl,
        });
        res = "Sucess";
      } else {
        return "please enter all the fields";
      }
    } catch (e) {
      res = e.toString();
      print(res);
    }
    return res;
  }

  Future<String> login(
      {required String email, required String Password}) async {
    String res;
    try {
      if (email.isNotEmpty || Password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: Password);
        res = 'Sucess';
      } else {
        res = 'please enter all the fields';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
