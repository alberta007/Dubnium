import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterbase/camera_screen.dart';
import 'package:flutterbase/overlays/scannedoverlay.dart';
import '../overlays/settings.dart';
import '../other/products.dart';
import '../other/scan.dart';
import 'package:flutterbase/overlays/profileoverlay.dart';
import 'package:firebase_database/firebase_database.dart';

class MyCustomClass extends StatelessWidget {
  static ProfileOverlay profile = ProfileOverlay();
  static SettingsDialog dialog = SettingsDialog();
  static ScanBarcode scanBarcode = ScanBarcode();

  MyCustomClass({super.key});
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: Color(0xFFEAF5E4),
      body: Center(
        child: Stack(
          children: [
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                    padding: const EdgeInsets.only(left: 40, bottom: 50),
                    child: IconButton(
                      icon: const Icon(
                        Icons.person_outline_outlined,
                        size: 70,
                      ),
                      onPressed: () {},
                    ))),
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                    padding: const EdgeInsets.only(right: 80, bottom: 50),
                    child: IconButton(
                      icon: const Icon(
                        Icons.qr_code_scanner_outlined,
                        size: 70,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ))),
            const Align(
                alignment: Alignment.topCenter,
                child: Padding(
                    padding: EdgeInsets.only(right: 0, top: 100),
                    child: Text(
                      'Dr.Preference',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3C2615)),
                    ))),
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(right: 0, top: 190),
                  child: ElevatedButton(
                    onPressed: () async {},
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFF87A330)),
                      foregroundColor:
                          MaterialStateProperty.all(Colors.green.shade600),
                      minimumSize: MaterialStateProperty.all(Size(300, 60)),
                    ),
                    child: const Text('Preferences',
                        style:
                            TextStyle(fontSize: 24, color: Color(0xFF3C2615))),
                  ),
                )),
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(right: 0, top: 270),
                  child: ElevatedButton(
                    onPressed: () async {},
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFF87A330)),
                      foregroundColor:
                          MaterialStateProperty.all(Colors.green.shade600),
                      minimumSize: MaterialStateProperty.all(Size(300, 60)),
                    ),
                    child: const Text('Social',
                        style:
                            TextStyle(fontSize: 24, color: Color(0xFF3C2615))),
                  ),
                )),
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(right: 0, top: 350),
                  child: ElevatedButton(
                    onPressed: () async {},
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFF87A330)),
                      foregroundColor:
                          MaterialStateProperty.all(Colors.green.shade600),
                      minimumSize: MaterialStateProperty.all(Size(300, 60)),
                    ),
                    child: const Text('Create meal',
                        style:
                            TextStyle(fontSize: 24, color: Color(0xFF3C2615))),
                  ),
                )),
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: const EdgeInsets.only(right: 0, bottom: 130),
                    child: Container(
                      width: 300,
                      height: 230,
                      decoration: BoxDecoration(
                        color: Color(0xFF87A330),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 16.0),
                                Text(
                                  'Username: ${user.displayName}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFF3C2615),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 30.0),
                                Text(
                                  'Userid: ${user.displayName}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFF3C2615),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 16.0,
                            right: 16.0,
                            child: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      ProfileOverlay(),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ))),
          ],
        ),
      ),
    );
  }
}
