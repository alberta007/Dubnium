import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutterbase/Widgets/mainmenu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutterbase/camera_screen.dart';
import 'package:flutterbase/social_screen.dart';
import 'package:flutterbase/Widgets/preferences.dart';

class menuTopBar extends StatelessWidget {
  const menuTopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        height: 120,
        padding: EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Color(0xFFEAF5E4),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                  width: 320,
                  height: 90,
                  padding: EdgeInsets.all(4.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 3.0,
                        color: Color(0xFF87A330),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SocialScreen(),
                              ),
                            );
                          },
                          iconSize: 40,
                          style: IconButton.styleFrom(
                            highlightColor: Colors.green.withOpacity(0.2),
                          ),
                          icon: Icon(
                            Icons.diversity_3,
                            semanticLabel: 'Text to announce in accessibility modes',
                          )),
                      //Spacer(),
                      Text(
                        "Dr.Preference",

                        //overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.normal, fontSize: 30),
                      ),
                      //Spacer(),
                      IconButton(
                          iconSize: 40,
                          style: IconButton.styleFrom(
                            highlightColor: Colors.green.withOpacity(0.2),
                          ),
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                          },
                          icon: Icon(
                            Icons.menu,
                          )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class menuBottomBar extends StatelessWidget {
  const menuBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: const BoxDecoration(
          color: Color(0xFFEAF5E4),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: 320,
            height: 120,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 3.0,
                  color: Color(0xFF87A330),
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 0.0,
              horizontal: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    iconSize: 60,
                    style: IconButton.styleFrom(
                      backgroundColor: Color(0xFFEAF5E4),
                      highlightColor: Colors.green.withOpacity(0.2),
                      elevation: 2,
                      shadowColor: Color.fromARGB(255, 0, 0, 0),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => cameraScreen()),
                        ),
                      );
                    },
                    icon: const ImageIcon(
                      AssetImage("assets/images/scan-28.png"),
                      //semanticLabel: 'Text to announce in accessibility modes',
                    ),
                  ),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Color(0xFFEAF5E4),
                      highlightColor: Colors.green.withOpacity(0.2),
                      elevation: 2,
                      shadowColor: Color.fromARGB(255, 0, 0, 0),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    iconSize: 60,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyCustomClass2(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.flatware,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
