import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intern_todo/screens/home.dart';
import '../resources/AuthMethods.dart';
import '../resources/widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mobilenumController = TextEditingController();
  var _isLoading = false;
  Uint8List? _image;

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

  void SignupUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().SignUpUser(
      Username: _usernameController.text,
      Password: _passwordController.text,
      email: _emailController.text,
      MobileNum: _mobilenumController.text,
      profilepic: _image!,
    );
    setState(() {
      _isLoading = false;
    });
    if (res == "Sucess") {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Hello()));
    } else {
      showSnackBar(res, context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _mobilenumController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  Text('enter your password'),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                    child: TextFieldInput(
                      textEditingController: _passwordController,
                      hintText: "password",
                      textInputType: TextInputType.text,
                      isPass: true,
                    ),
                  ),
                  Text('enter your mobile number'),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                    child: TextFieldInput(
                      textEditingController: _mobilenumController,
                      hintText: "mobilenumber",
                      textInputType: TextInputType.phone,
                    ),
                  ),
                  InkWell(
                    onTap: SignupUser,
                    child: Container(
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                              color: Colors.white,
                            ))
                          : Text(
                              "Sign Up",
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
