
import 'package:flutter/material.dart';
import 'package:frontend/overlays/settings.dart';

class products {
  static SettingsDialog dialog = SettingsDialog();

  static void openNewscreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.green.shade800,
        body: Center(
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, top: 16),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey.shade400),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.green.shade800),
                        minimumSize: MaterialStateProperty.all(Size(70, 70)),
                      ),
                      child: const Icon(Icons.person_outlined),
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
                        foregroundColor:
                            MaterialStateProperty.all(Colors.green.shade800),
                        minimumSize: MaterialStateProperty.all(Size(70, 70)),
                      ),
                    ),
                  )),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 400,
                  width: 300,
                  decoration: BoxDecoration(
                      border:
                          Border.all(width: 4, color: Colors.grey.shade400)),
                ),
              )
            ],
          ),
        ),
      );
    }));
  }
}
