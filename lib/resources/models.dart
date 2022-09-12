import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Task {
  final String Name;
  final String Description;
  final DateTime endDateTime;
  bool comp;

  Task({
    required String this.Name,
    required String this.Description,
    required DateTime this.endDateTime,
    this.comp=false,
  });

  Map<String, dynamic> toJson() => {
        "Name": Name,
        "Description": Description,
        "endDateTime": endDateTime,
        "Completed": comp,
      };

  Future<String> UploadTask() async {
    var res = "start";
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    res = "ins of auth and firestore created";

    User CurrentUser = _auth.currentUser!;
    try {
      await _firestore
          .collection('Users')
          .doc(CurrentUser.uid)
          .collection("tasks")
          .doc("${Name}")
          .set(toJson())
          .then((value) {
        res = "sucess";
      });
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}

