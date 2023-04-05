
import 'package:flutter/material.dart';
import 'package:frontend/mainmenu.dart';

class SettingsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade400,
      title: Text('Menu'),
      content: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: Column(children: [
                ElevatedButton(
                  child: Text('General'),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.green.shade800),
                      foregroundColor:
                          MaterialStateProperty.all(Colors.grey.shade400),
                      minimumSize: MaterialStateProperty.all(Size(200, 50))),
                  onPressed: () {
                    // Navigate to general settings screen
                  },
                ),
                Divider(),
                ElevatedButton(
                  child: Text('Main menu'),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.green.shade800),
                      foregroundColor:
                          MaterialStateProperty.all(Colors.grey.shade400),
                      minimumSize: MaterialStateProperty.all(Size(200, 50))),
                  onPressed: () {
                    MyCustomClass.openNewScreen(context);
                  },
                ),
              ]),
            )
          ],
        ),
      ),
      actions: [
        Row(children: [
          Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 1, top: 1),
                child: IconButton(
                  iconSize: 50,
                  icon: Icon(Icons.settings_applications_sharp),
                  color: Colors.green.shade800,
                  onPressed: () {
                    // Navigate to general settings screen
                  },
                ),
              )),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(left: 120, top: 1),
              child: ElevatedButton(
                child: Text('Close'),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.red.shade900)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ])
      ],
    );
  }
}
