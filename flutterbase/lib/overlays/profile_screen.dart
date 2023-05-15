import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutterbase/main.dart';
import '../Widgets/loginwidget.dart';
import '../Widgets/menu_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileOverlay extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!; // get the current user

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAF5E4),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const Expanded(
            flex: 12,
            child: menuTopBar(),
          ),
          Expanded(
            flex: 76,
            child: Container(
              color: Color(0xFFEAF5E4),
              width: 320,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'assets/images/drPreference.png',
                      scale: 1,
                      width: 250,
                      height: 250,
                    ),
                  ),
                  Align(
                    alignment: Alignment(0.4, 2),
                    child: Container(
                      width: 320,
                      height: 400,
                      child: Column(
                        children: [
                          Container(
                            width: 340,
                            height: 3,
                            color: Color(0xFF87A330).withOpacity(0.5),
                          ),
                          Row(
                            children: [
                              Container(
                                  width: 310,
                                  height: 70,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15))),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Username: ${user.displayName}",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(
                                        width: 90,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            Fluttertoast.showToast(msg: 'Not yet implemented', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.black, fontSize: 20.0);
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.black,
                                          )),
                                    ],
                                  ))
                            ],
                          ),
                          Container(
                            width: 320,
                            height: 3,
                            color: Color(0xFF87A330).withOpacity(0.5),
                          ),
                          Row(children: [
                            Container(
                                width: 310,
                                height: 70,
                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15))),
                                child: Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: OverflowBox(
                                        maxWidth: 290,
                                        child: AutoSizeText(
                                          "E-mail: ${user.email}",
                                          style: TextStyle(fontSize: 20),
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    IconButton(
                                        onPressed: () {
                                          Fluttertoast.showToast(msg: 'Not yet implemented', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.black, fontSize: 20.0);
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                        )),
                                  ],
                                ))
                          ]),
                          Container(
                            width: 320,
                            height: 3,
                            color: Color(0xFF87A330).withOpacity(0.5),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: 320,
                            height: 100,
                            child: Stack(children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(const Color(0xFF87A330)),
                                      minimumSize: MaterialStateProperty.all(const Size(300, 40)),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: Text(
                                      "Change password",
                                      style: TextStyle(fontSize: 20, color: Colors.white),
                                    )),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(const Color(0xFF87A330)),
                                      minimumSize: MaterialStateProperty.all(const Size(300, 40)),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      FirebaseAuth.instance.signOut();
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => MyHome()),
                                      );
                                    },
                                    child: const Text(
                                      "Sign Out",
                                      style: TextStyle(fontSize: 20, color: Colors.white),
                                    )),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ]),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const Expanded(
            flex: 12,
            child: menuBottomBar(),
          ),
        ],
      ),
    );
  }
}
