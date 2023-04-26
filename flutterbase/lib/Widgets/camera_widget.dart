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
      MobileScannerController(autoStart: false);
  bool isScanning = true;

  @override
  void didChangeDependencies() {
    controller.stop();
    controller.start();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
            controller.stop();
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ScannedProduct(barCode)))
                .then((value) {
              controller.start();
            });
          }
        }
      },
    );
  }
}
