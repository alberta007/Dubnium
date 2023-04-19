import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutterbase/Widgets/mainmenu.dart';
import 'package:flutterbase/camera_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutterbase/social_screen.dart';

class menuBar extends StatelessWidget {
  const menuBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 395,
            height: 120,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF5E4),
            ),
            child: Stack(
              children: [
                Positioned(
                    top: 10,
                    left: 50,
                    child: Container(
                      width: 290,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: Color(0xFF87A330),
                      ),
                    )),
                Positioned(
                  bottom: 60,
                  right: 90,
                  child: IconButton(
                    icon: const Icon(
                      Icons.center_focus_weak_sharp,
                      size: 90,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => cameraScreen()),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 60,
                  left: 40,
                  child: IconButton(
                    icon: const Icon(
                      Icons.food_bank_outlined,
                      size: 90,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyCustomClass()),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 395,
            height: 120,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF5E4),
            ),
            child: Stack(
              children: [
                Positioned(
                    top: 100,
                    left: 53,
                    child: Container(
                      width: 290,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Color(0xFF87A330),
                      ),
                    )),
                Positioned(
                  bottom: 60,
                  right: 70,
                  child: IconButton(
                    icon: const Icon(
                      Icons.menu,
                      size: 70,
                    ),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                  ),
                ),
                Positioned(
                  bottom: 60,
                  left: 40,
                  child: IconButton(
                    icon: const Icon(
                      Icons.person_add_alt,
                      size: 70,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SocialScreen()),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),

        /*
        */
      ],
    );
  }
}
