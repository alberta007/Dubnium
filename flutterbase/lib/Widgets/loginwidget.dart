import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterbase/provider/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutterbase/main.dart';
import 'package:flutterbase/Widgets/mainmenu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

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
            color: Color(0xFFEAF5E4),
            child: Stack(
              children: [
                Container(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(25),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            'assets/images/drPreference.png',
                          ),
                          TextFormField(
                            controller: emailController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon:
                                  const Icon(Icons.email_rounded, size: 24),
                              hintText: 'Enter email...',
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          TextFormField(
                            controller: passwordController,
                            textInputAction: TextInputAction.next,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.lock, size: 24),
                              hintText: 'Enter password...',
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              signIn();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFF87A330)),
                              minimumSize: MaterialStateProperty.all<Size>(
                                  Size.fromHeight(60)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                              ),
                            ),
                            icon: (Icon(
                              Icons.lock_open,
                              size: 32,
                              color: Colors.white,
                            )),
                            label: Text(
                              'Sign in',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          RichText(
                              text: TextSpan(
                                  style: TextStyle(color: Colors.black),
                                  text: 'No account?  ',
                                  children: [
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = widget.onClickSignUp,
                                    text: 'Sign up',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Color(0xFF87A330)))
                              ])),
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Expanded(
                                child: Divider(
                                  color: Color(0xFF87A330),
                                  thickness: 1,
                                  indent: 10,
                                  endIndent: 10,
                                ),
                              ),
                              Text(
                                'Or',
                                style: TextStyle(
                                  color: Color(0xFF87A330),
                                  fontSize: 20,
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Color(0xFF87A330),
                                  thickness: 1,
                                  indent: 10,
                                  endIndent: 10,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 33,
                          ),
                          ElevatedButton.icon(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFF87A330)),
                              minimumSize: MaterialStateProperty.all<Size>(
                                  Size.fromHeight(60)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                              ),
                            ),
                            icon: FaIcon(
                              FontAwesomeIcons.google,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              final provider =
                                  Provider.of<GoogleSignInProvider>(context,
                                      listen: false);
                              provider.googleLogin();
                            },
                            label: Text('Sign in with Google',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                          ),
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
      if (e.code == 'wrong-password' ||
          e.code == 'invalid-email' ||
          e.code == 'user-not-found') {
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
