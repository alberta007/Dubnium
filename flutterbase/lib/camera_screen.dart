import 'package:flutter/material.dart';
import 'package:flutterbase/Widgets/menu_widget.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutterbase/Widgets/scanned_product.dart';
import 'package:flutterbase/main.dart';

class cameraScreen extends StatefulWidget {
  const cameraScreen({Key? key}) : super(key: key);

  @override
  State<cameraScreen> createState() => cameraScreenState();
}

class cameraScreenState extends State<cameraScreen> with RouteAware {
  String barCode = '';
  MobileScannerController controller = MobileScannerController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(
        this, ModalRoute.of(context)! as PageRoute<dynamic>);
  }

  @override
  void didPushNext() {
    // Closes scanner when leaving route
    controller.stop();
    super.didPushNext();
  }

  @override
  void didPopNext() {
    // Restarts scanner when coming back to route
    // BUG: Doesn't work when coming from another scanner route, starts scanner and instantly closes
    controller.dispose();
    controller.start();
    super.didPopNext();
  }

  @override
  void dispose() {
    controller.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 12,
            child: menuTopBar(),
          ),
          Expanded(
            flex: 76,
            child: MobileScanner(
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
            ),
          ),
          Expanded(
            flex: 12,
            child: menuBottomBar(),
          ),
        ],
      ),
    );
  }
}
