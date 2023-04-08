import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterbase/overlays/scannedoverlay.dart';
import '../overlays/settings.dart';
import '../other/products.dart';
import '../other/scan.dart';
import 'package:flutterbase/overlays/profileoverlay.dart';

class MyCustomClass extends StatelessWidget {
  static SettingsDialog dialog = SettingsDialog();
  static ScanBarcode scanBarcode = ScanBarcode();

  const MyCustomClass({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      backgroundColor: Colors.green.shade600,
      body: Center(
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => ProfileOverlay());
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey.shade400),
                      foregroundColor:
                          MaterialStateProperty.all(Colors.green.shade600),
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
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey.shade400),
                      foregroundColor:
                          MaterialStateProperty.all(Colors.green.shade600),
                      minimumSize: MaterialStateProperty.all(Size(70, 70)),
                    ),
                    child: Icon(Icons.menu),
                  ),
                )),
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      String? barcode = await scanBarcode.scanBarcode();
                      if (barcode != null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => MyDialog(
                            title: 'Scanned product: ',
                            message: barcode,
                          ),
                        );
                      } else {
                        const Text('Something wrong!');
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey.shade400),
                      foregroundColor:
                          MaterialStateProperty.all(Colors.green.shade600),
                      minimumSize: MaterialStateProperty.all(Size(200, 100)),
                    ),
                    child: const Text('Scan products',
                        style: TextStyle(fontSize: 24)),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      products.openNewscreen(context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey.shade400),
                      foregroundColor:
                          MaterialStateProperty.all(Colors.green.shade600),
                      minimumSize: MaterialStateProperty.all(Size(200, 100)),
                    ),
                    child: const Text('See products',
                        style: TextStyle(fontSize: 24)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
