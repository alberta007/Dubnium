import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoggedInWidget extends StatelessWidget {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Logged In'),
          centerTitle: true,
          actions: [
            TextButton(
              child: Text('Logout'),
              onPressed: () {},
            )
          ],
        ),
        body: Container(
            alignment: Alignment.center,
            color: Colors.blueGrey.shade900,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Profile',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            )));
  }
}
