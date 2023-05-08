import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  final usernameController = TextEditingController();
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
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            'assets/images/drPreference.png',
                          ),
                          TextFormField(
                            controller: usernameController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              prefixIcon: const Icon(Icons.person, size: 24),
                              border: OutlineInputBorder(),
                              hintText: 'Enter username...',
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          TextFormField(
                            controller: emailController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              prefixIcon: const Icon(Icons.email_rounded, size: 24),
                              border: OutlineInputBorder(),
                              hintText: 'Enter email...',
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          TextFormField(
                            controller: passwordController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              prefixIcon: const Icon(Icons.lock, size: 24),
                              border: OutlineInputBorder(),
                              hintText: 'Enter password...',
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              signUp();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF87A330)),
                              minimumSize: MaterialStateProperty.all<Size>(Size.fromHeight(60)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                              ),
                            ),
                            icon: (Icon(Icons.lock_open, size: 32, color: Colors.white)),
                            label: Text(
                              'Sign up',
                              style: TextStyle(fontSize: 24, color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          RichText(text: TextSpan(style: TextStyle(color: Color(0xFF87A330)), text: 'Already have an account?  ', children: [TextSpan(recognizer: TapGestureRecognizer()..onTap = widget.onClickSignIn, text: 'Sign in', style: TextStyle(decoration: TextDecoration.underline, color: Colors.black))]))
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      );
  Future<void> signUp() async {
    try {
      // Store the user's data in the Firebase Realtime Database.
      final databaseReference = FirebaseDatabase.instance.reference();
      String username;
      // Check if the chosen username already exists in the database
      final usernameExistsSnapshot = await databaseReference.child('usernames/${usernameController.text.trim()}').once();
      if (usernameExistsSnapshot.snapshot.value != null) {
        // If the username already exists, show an error message.
        Fluttertoast.showToast(msg: 'The chosen username is already taken.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Color(0xFF87A330), fontSize: 20.0);
      } else {
        // If the username doesn't already exist, create the email and password and add the user's data to the database.
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim()).then((value) async {
          final user = FirebaseAuth.instance.currentUser!;
          await user.updateDisplayName(usernameController.text.trim());

          // Set the global variable with the created username

          await databaseReference.child('Users/${usernameController.text.trim()}').set({
            'Userdetails': {
              'Email': user.email,
              'user-id': user.uid,
            },
            'Members': {
              'Active': {
                'You': {
                  'Preferences': ['Ägg'],
                },
                'Am': {
                  'Preferences': ['Ägg', 'Cola'],
                }
              }
            },
            'Friends': {},
          });
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: 'The email address is already in use.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Color(0xFF87A330), fontSize: 20.0);
      } else if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: 'The password is too short.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Color(0xFF87A330), fontSize: 20.0);
      }
    }
  }
}
