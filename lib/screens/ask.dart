import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../resources/storageMethods.dart';
import '../resources/widgets.dart';
import 'home.dart';

class askScreen extends StatefulWidget {
  const askScreen({Key? key, required String this.mobile}) : super(key: key);
  final String mobile;
  @override
  State<askScreen> createState() => _askScreenState();
}

class _askScreenState extends State<askScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  var _isLoading = false;
  Uint8List? _image;
  var _isgetting = false;

  void selectImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? _imagexfile = await _picker.pickImage(source: ImageSource.gallery);
    if (_imagexfile != Null) {
      var a = await _imagexfile?.readAsBytes();
      setState(() {
        _image = a;
      });
    }
  }

  Future<String> uploadDetails() async {
    if ((_image != null) &&
        (_usernameController.text.isNotEmpty) &&
        (_emailController.text.isNotEmpty)) {
      String res = "initial";
      try {
        final FirebaseAuth _auth = FirebaseAuth.instance;
        final FirebaseFirestore _firestore = FirebaseFirestore.instance;
        String PhotoUrl =
            await StorageMethods().UploadImageToStorage("profilePic", _image!);
        User CurrentUser = _auth.currentUser!;
        await _firestore.collection("Users").doc(CurrentUser.uid).set({
          "Username": _usernameController.text,
          "Password": "no password",
          "email": _emailController.text,
          "MobileNum": widget.mobile,
          "photoUrl": PhotoUrl,
        });
        res = "sucess";
      } catch (e) {
        res = e.toString();
      }
      return res;
    }
    return "enter all fields and image";
  }

  Future<String> getttt() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User CurrentUser = _auth.currentUser!;
    try {
      await _firestore
          .collection('Users')
          .doc(CurrentUser.uid)
          .get()
          .then((value) {
        if (value.exists) {
          print("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");
          
          return "Yes";
          
        } else {
          return "No";
        }
      });
    } catch (e) {
      return "No";
    }
    return "No";
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _usernameController.dispose();
  }

  Future<String> do_stg() async {
    setState(() {
      _isgetting = true;
    });

    String a = await getttt();
    if (a == "Yes") {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Hello()));
    }

    setState(() {
      _isgetting = false;
    });
    return "asdfg";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    do_stg();
  }

  @override
  Widget build(BuildContext context) {
    if (_isgetting) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    var a = MediaQuery.of(context).size.height;
    print("height is:${a}");
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 4 / 5,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 80,
                  ),
                  Center(
                    child: Stack(
                      children: [
                        (_image != null)
                            ? CircleAvatar(
                                backgroundImage: MemoryImage(_image!),
                                radius: 70,
                              )
                            : const CircleAvatar(
                                radius: 70,
                                backgroundColor: Colors.red,
                                backgroundImage: AssetImage("images/prof.png"),
                              ),
                        Positioned(
                          bottom: -10,
                          left: 100,
                          child: IconButton(
                            icon: Icon(
                              Icons.photo_camera,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              print(a);
                              selectImage();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 80,
                  ),
                  Text("Enter your email"),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                    child: TextFieldInput(
                        textEditingController: _emailController,
                        hintText: "abd1233@email.com",
                        textInputType: TextInputType.emailAddress),
                  ),
                  Text('enter your username'),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                    child: TextFieldInput(
                      textEditingController: _usernameController,
                      hintText: "name please ...",
                      textInputType: TextInputType.text,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      String res = await uploadDetails();
                      setState(() {
                        _isLoading = false;
                      });
                      if (res == "sucess") {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => Hello()));
                      } else {
                        showSnackBar("an eoor occured", context);
                      }
                    },
                    child: Container(
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                              color: Colors.white,
                            ))
                          : Text(
                              "next",
                              style: TextStyle(color: Colors.white),
                            ),
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Container(
                    height: 80,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
