import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterbase/other/firebase_functions.dart';

class AddPreferenceOverlay extends StatefulWidget {
  List<String> members;
  String preference;

  AddPreferenceOverlay(this.members, this.preference, {super.key});
  @override
  State<AddPreferenceOverlay> createState() =>
      _AddPreferenceOverlayState(members, preference);
}

class _AddPreferenceOverlayState extends State<AddPreferenceOverlay> {
  List<String> profileNames;
  String preference;
  List<bool> isChecked = [];

  _AddPreferenceOverlayState(this.profileNames, this.preference);

  @override
  void initState() {
    isChecked = List.filled(profileNames.length, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return AlertDialog(
      backgroundColor: Color(0xFFEAF5E4),
      actions: [
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Color(0xFF87A330),
            ),
          ),
          onPressed: () {
            for (int i = 0; i < profileNames.length; i++) {
              if (isChecked[i]) {
                FirebaseFunctions().addPreference(profileNames[i], preference);
              }
            }
          },
          child: Text(
            "Add",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ],
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
                                : Icons.check_box_outline_blank, size: 40
                          ),
                          onPressed: () {
                            setState(() {
                              isChecked[index] = !isChecked[index];
                            });
                          },
                        )
                      ],
                    )),
              ),
            );
          },
        ),
      ),
    );
  }
}
