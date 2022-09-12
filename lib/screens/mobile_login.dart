import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intern_todo/resources/widgets.dart';
import 'package:intern_todo/screens/ask.dart';

class mobileLoginPafe extends StatefulWidget {
  const mobileLoginPafe({Key? key}) : super(key: key);

  @override
  State<mobileLoginPafe> createState() => _mobileLoginPafeState();
}

class _mobileLoginPafeState extends State<mobileLoginPafe> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  bool otpVisibility = false;

  String verificationID = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "mobile login",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFieldInput(
                  textEditingController: phoneController,
                  hintText: "mobile num",
                  textInputType: TextInputType.phone),
            ),

            Visibility(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFieldInput(
                    textEditingController: otpController,
                    hintText: "mobile num",
                    textInputType: TextInputType.phone),
              ),
              visible: otpVisibility,
            ),
            
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  if (otpVisibility) {
                    verifyOTP();
                  } else {
                    loginWithPhone();
                  }
                },
                child: Text(otpVisibility ? "Verify" : "Login")),
          ],
        ),
      ),
    );
  }

  void loginWithPhone() async {
    auth.verifyPhoneNumber(
      phoneNumber: phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {
          print("You are logged in successfully");
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        otpVisibility = true;
        verificationID = verificationId;
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otpController.text);

    await auth.signInWithCredential(credential).then((value) {
      print("You are logged in successfully");
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => askScreen(mobile: phoneController.text)));
    });
  }
}
