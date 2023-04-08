import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterbase/Widgets/mainmenu.dart';

class ProfileOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text('Profile'),
      content: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(text: 'Logged in as:\n'),
                        TextSpan(text: '${user.email!}'),
                      ],
                    ),
                  ),
                  SizedBox(width: 7),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                    },
                    child: Text('Log out'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
