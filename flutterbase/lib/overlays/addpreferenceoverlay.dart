import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterbase/Widgets/mainmenu.dart';

class AddPreferenceOverlay extends StatefulWidget {
  @override
  State<AddPreferenceOverlay> createState() => _AddPreferenceOverlayState();
}

class _AddPreferenceOverlayState extends State<AddPreferenceOverlay> {
  List<String> profileNames = [
    "Martin",
    "Marcus",
    "Simon",
    "Tilde",
    "Julius",
    "Albert"
  ];

  List<bool> isChecked = [false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return AlertDialog(
      backgroundColor: Color(0xFFEAF5E4),
      title: Text(
        'Add To:',
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        height: 350,
        width: 400,
        child: ListView.builder(
          itemCount: profileNames.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 200,
                  height: 70,
                  decoration: BoxDecoration(
                    //color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(profileNames[index],
                          style: TextStyle(
                              color: Color(0xFF3C2615),
                              fontWeight: FontWeight.w800,
                              fontSize: 30)),
                      IconButton(
                        icon: Icon(
                            isChecked[index]
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            size: 40),
                        onPressed: () {
                          setState(
                            () {
                              isChecked[index] = !isChecked[index];
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
