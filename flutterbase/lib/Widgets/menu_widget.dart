import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutterbase/Widgets/mainmenu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class menuBar extends StatelessWidget {
  const menuBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /*
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
                    onPressed: () {},
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
        ),*/
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
                Align(
                  alignment: Alignment.center,
                  child: Container(
                      width: 300,
                      height: 90,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 3.0,
                            color: Color(0xFF87A330),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const <Widget>[
                          Icon(
                            Icons.person,
                            size: 40,
                            semanticLabel:
                                'Text to announce in accessibility modes',
                          ),
                          Spacer(),
                          Text(
                            "Dr.Preference",
                            textAlign: TextAlign.start,

                            //overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                fontSize: 30),
                          ),
                          Spacer(),
                          Icon(
                            Icons.menu,
                            size: 40,
                          ),
                        ],
                      )),
                ),
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
