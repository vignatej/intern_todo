import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intern_todo/screens/login_screen.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  String _phot = "";
  String _name = "";
  String _mobile = "";
  String _email = "";

  Future<String?> a(_auth, _firestore, CurrentUser) async => await _firestore
          .collection('Users')
          .doc(CurrentUser.uid)
          .get()
          .then((value) {
        setState(() {
          _phot = value["photoUrl"];
          _name = value["Username"];
          _mobile = value["MobileNum"];
          _email = value["email"];
        });
      });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User CurrentUser = _auth.currentUser!;
    a(_auth, _firestore, CurrentUser);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Profile",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          child: Column(
            children: [
              Flexible(child: Container(), flex: 2),
              CircleAvatar(
                backgroundImage: NetworkImage(_phot),
                radius: 100,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "${_name}",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "${_email}",
                style: TextStyle(fontSize: 15),
              ),
              Text(
                "${_mobile}",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.signOut().then((value) => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => loginScreen()),(route) => false)); 
                },
                child: Container(
                  child: Center(child: Text("logout")),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.purple,
                  ),
                  width: 100,
                  height: 50,
                ),
              ),
              Flexible(child: Container(), flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
