import 'package:flutter/material.dart';
import 'package:frontend/overlays/scannedoverlay.dart';
import 'overlays/settings.dart';
import 'other/products.dart';
import 'other/scan.dart';

class MyCustomClass {
  static SettingsDialog dialog = SettingsDialog();
  static ScanBarcode scanBarcode = ScanBarcode();
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
                        padding: const EdgeInsets.only(left: 16, top: 16),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey.shade400),
                            foregroundColor: MaterialStateProperty.all(
                                Colors.green.shade800),
                            minimumSize:
                                MaterialStateProperty.all(Size(70, 70)),
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
                            foregroundColor: MaterialStateProperty.all(
                                Colors.green.shade800),
                            minimumSize:
                                MaterialStateProperty.all(Size(70, 70)),
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
                            foregroundColor: MaterialStateProperty.all(
                                Colors.green.shade800),
                            minimumSize:
                                MaterialStateProperty.all(Size(200, 100)),
                          ),
                          child: const Text('Scan products',
                              style: TextStyle(fontSize: 24)),
                        ),
                        SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            // Do something when the second button is pressed
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey.shade400),
                            foregroundColor: MaterialStateProperty.all(
                                Colors.green.shade800),
                            minimumSize:
                                MaterialStateProperty.all(Size(200, 100)),
                          ),
                          child: const Text('Something...',
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
                            foregroundColor: MaterialStateProperty.all(
                                Colors.green.shade800),
                            minimumSize:
                                MaterialStateProperty.all(Size(200, 100)),
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
        },
      ),
    );
  }
}
