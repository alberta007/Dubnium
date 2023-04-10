import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterbase/provider/google_sign_in.dart';
import 'Widgets/signUpandInWidget.dart';
import 'Widgets/mainmenu.dart';
import 'package:provider/provider.dart';

import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(home: MyHome()));
  }
}

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
          body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return const MyCustomClass();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Something wrong!'),
            );
          } else {
            return SignUpandInWidget();
          }
        }),
      ));
}
