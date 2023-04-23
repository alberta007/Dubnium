import 'package:flutter/material.dart';
import 'package:flutterbase/Widgets/scanned_product.dart';
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
      fit: BoxFit.fitHeight,
      onDetect: (capture) {
        if (ModalRoute.of(context)!.isCurrent) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            debugPrint('Barcode found! ${barcode.rawValue}');
            barCode = barcode.displayValue!;
            while (barCode.length < 14) {
              barCode = '0$barCode'; //Add zeros to increase length
            }
            
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ScannedProduct(barCode)));
          }
        }
      },
    );
  }
}
