import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutterbase/main.dart';
import 'package:flutterbase/Widgets/mainmenu.dart';

class registerWidget extends StatefulWidget {
  final VoidCallback onClickSignIn;

  const registerWidget({
    Key? key,
    required this.onClickSignIn,
  }) : super(key: key);

  @override
  _registerWidget createState() => _registerWidget();
}

class _registerWidget extends State<registerWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Container(
            color: Colors.green.shade600,
            child: Stack(
              children: [
                Container(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            'assets/images/Dr.Preferenec-removebg-preview.png',
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: emailController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter email...',
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: passwordController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter password...',
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              signIn();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.purple.shade400),
                              minimumSize: MaterialStateProperty.all<Size>(
                                  Size.fromHeight(50)),
                            ),
                            icon: (Icon(
                              Icons.lock_open,
                              size: 32,
                            )),
                            label: Text(
                              'Sign up',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          RichText(
                              text: TextSpan(
                                  style: TextStyle(color: Colors.white),
                                  text: 'Already have an account?  ',
                                  children: [
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = widget.onClickSignIn,
                                    text: 'Sign in',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.purple.shade400))
                              ]))
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      );

  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: 'The email address is already in use.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 20.0);
      } else if (e.code == 'weak-password') {
        Fluttertoast.showToast(
            msg: 'The password is to short',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 20.0);
      }
      print(e);
    }
  }
}
