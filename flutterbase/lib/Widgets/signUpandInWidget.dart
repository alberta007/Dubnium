import 'package:flutter/cupertino.dart';
import 'package:flutterbase/Widgets/loginwidget.dart';
import 'package:flutterbase/Widgets/registerwidget.dart';

class SignUpandInWidget extends StatefulWidget {
  @override
  _SignUpandInWidget createState() => _SignUpandInWidget();
}

class _SignUpandInWidget extends State<SignUpandInWidget> {
  bool loggedIn = true;

  @override
  Widget build(BuildContext context) => loggedIn
      ? LoginWidget(onClickSignUp: toggle)
      : registerWidget(onClickSignIn: toggle);

  void toggle() => setState(() => loggedIn = !loggedIn);
}
