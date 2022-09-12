import 'package:flutter/material.dart';
import 'package:intern_todo/resources/AuthMethods.dart';
import 'package:intern_todo/resources/widgets.dart';
import 'package:intern_todo/screens/home.dart';
import 'package:intern_todo/screens/mobile_login.dart';
import 'package:intern_todo/screens/signup_screen.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var _isLoading = false;

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().login(
        email: _emailController.text, Password: _passwordController.text);
    if (res == 'Sucess') {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Hello()));
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 4 / 5,
            height: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(),
                  flex: 1,
                ),
                Center(
                  child: Text(
                    "LOGIN FORM",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Flexible(
                  child: Container(),
                  flex: 1,
                ),
                Text("Enter your email"),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                  child: TextFieldInput(
                      textEditingController: _emailController,
                      hintText: "abd1233@email.com",
                      textInputType: TextInputType.emailAddress),
                ),
                Text('enter your password'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                  child: TextFieldInput(
                    textEditingController: _passwordController,
                    hintText: "password",
                    textInputType: TextInputType.text,
                    isPass: true,
                  ),
                ),
                InkWell(
                  onTap: () {
                    loginUser();
                  },
                  child: Container(
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                        : Text(
                            "log in",
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
                Flexible(
                  child: Container(),
                  flex: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text("Don't have any account? "),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SignupScreen()));
                      },
                      child: Container(
                        child: const Text(
                          "SignUp",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const mobileLoginPafe()));
                  },
                  child: Center(
                    child: Container(
                      child: const Text(
                        "use mobile num login",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
