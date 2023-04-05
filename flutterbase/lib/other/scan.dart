
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanBarcode {
  Future<String?> scanBarcode() async {
    String? barcode;
    try {
      barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Color for the scanner overlay
        'Cancel', // Text for the cancel button
        true, // Whether to show the flash button
        ScanMode.BARCODE, // What type of codes to scan for
      );
    } on PlatformException {
      barcode = "Failed";
    }
    return barcode;
  }
}
