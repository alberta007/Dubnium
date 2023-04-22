import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutterbase/Widgets/mainmenu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class menuTopBar extends StatelessWidget {
  const menuTopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
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
            width: 300,
            height: 90,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 3.0,
                  color: Color(0xFF87A330),
                ),
              ),
            ),
          )
        )
                 
      )
      
    );
  }
}
