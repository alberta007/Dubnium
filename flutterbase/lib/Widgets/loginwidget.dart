import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutterbase/main.dart';
import 'package:flutterbase/Widgets/mainmenu.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickSignUp;

  const LoginWidget({
    Key? key,
    required this.onClickSignUp,
  }) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
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
            color: Colors.green.shade600, // set background color here
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
                              'Sign in',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          RichText(
                              text: TextSpan(
                                  style: TextStyle(color: Colors.white),
                                  text: 'No account?  ',
                                  children: [
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = widget.onClickSignUp,
                                    text: 'Sign up',
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

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        Fluttertoast.showToast(
            msg: 'Invalid email or password',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 20.0);
      }
    }
  }
}
