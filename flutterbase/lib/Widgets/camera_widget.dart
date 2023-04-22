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
  MobileScannerController controller =
      MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);
  bool isDialogShowing = false;

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: controller,
      fit: BoxFit.fitHeight,
      onDetect: (capture) {
        if (!isDialogShowing) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            debugPrint('Barcode found! ${barcode.rawValue}');
            barCode = barcode.displayValue!;
            while (barCode.length < 14) {
              barCode = '0$barCode'; //Add zeros to increase length
            }
            debugPrint(
                'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA ${barCode.length}');
            /*
            setState(() {
              isDialogShowing = true;
            });
            */
            debugPrint(
                '!!!!!!!!!!!!!!!!!!!!!!!! ${barcode.displayValue}, ---------- ${barcode.rawValue}, eeeeeeeeeeeeeeee ${barcode.format}');
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ScannedProduct(barCode)));

            /*
            
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
            */
          }
        }
      },
    );
  }
}
