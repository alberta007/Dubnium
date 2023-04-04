import 'package:flutter/material.dart';
import 'overlays/settings.dart';

class MyCustomClass {
  static SettingsDialog dialog = SettingsDialog();
  static void openNewScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.green.shade800,
            body: Center(
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16, top: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            // Do something when the button is pressed
                          },
                          child: Icon(Icons.person_outlined),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey.shade400),
                            foregroundColor: MaterialStateProperty.all(
                                Colors.green.shade800),
                            minimumSize:
                                MaterialStateProperty.all(Size(70, 70)),
                          ),
                        ),
                      )),
                  Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 16, top: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context, builder: (context) => dialog);
                          },
                          child: Icon(Icons.menu),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey.shade400),
                            foregroundColor: MaterialStateProperty.all(
                                Colors.green.shade800),
                            minimumSize:
                                MaterialStateProperty.all(Size(70, 70)),
                          ),
                        ),
                      )),
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Do something when the first button is pressed
                          },
                          child: Text('Scan product',
                              style: TextStyle(fontSize: 24)),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey.shade400),
                            foregroundColor: MaterialStateProperty.all(
                                Colors.green.shade800),
                            minimumSize:
                                MaterialStateProperty.all(Size(200, 100)),
                          ),
                        ),
                        SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            // Do something when the second button is pressed
                          },
                          child: Text('Something...',
                              style: TextStyle(fontSize: 24)),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey.shade400),
                            foregroundColor: MaterialStateProperty.all(
                                Colors.green.shade800),
                            minimumSize:
                                MaterialStateProperty.all(Size(200, 100)),
                          ),
                        ),
                        SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            // Do something when the third button is pressed
                          },
                          child: Text('See products',
                              style: TextStyle(fontSize: 24)),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey.shade400),
                            foregroundColor: MaterialStateProperty.all(
                                Colors.green.shade800),
                            minimumSize:
                                MaterialStateProperty.all(Size(200, 100)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
