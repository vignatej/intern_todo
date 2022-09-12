import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intern_todo/resources/AuthMethods.dart';

import 'models.dart' as model;
import 'models.dart';

Future<List<model.Task>> get_tasks() async {
  List<model.Task> list = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User CurrentUser = _auth.currentUser!;
  String res;
  DocumentSnapshot? snap = await _firestore
      .collection('Users')
      .doc(CurrentUser.uid)
      .collection('tasks')
      .get()
      .then((value) {
    print("value is:");
    print(value.toString());
    for (var doc in value.docs) {
      var temp = doc.data();
      model.Task t = model.Task(
          Name: temp["Name"],
          Description: temp["Description"],
          endDateTime: DateTime.fromMicrosecondsSinceEpoch(
              temp["endDateTime"].seconds * 1000000 +
                  (temp["endDateTime"].nanoseconds / 1000).toInt()),
          comp: temp["Completed"]
        );
      list.add(t);
    }
  });
  print(list);
  return list;
}
