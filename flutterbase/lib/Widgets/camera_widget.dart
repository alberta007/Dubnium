import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutterbase/overlays/scannedoverlay.dart';

class CameraWidget extends StatefulWidget {
  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  String barCode = '';
  MobileScannerController controller = MobileScannerController();
  bool isDialogShowing = false;

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: controller,
      onDetect: (capture) {
        if (!isDialogShowing) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            debugPrint('Barcode found! ${barcode.rawValue}');
            barCode = barcode.rawValue!;
            setState(() {
              isDialogShowing = true;
            });
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => MyDialog(
                title: 'Scanned product: ',
                message: barCode,
              ),
            ).then((_) {
              setState(() {
                isDialogShowing = false;
              });
            });
          }
        }
      },
    );
  }
}
