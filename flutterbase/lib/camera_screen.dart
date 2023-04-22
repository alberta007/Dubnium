import 'package:flutter/material.dart';
import 'package:flutterbase/Widgets/camera_widget.dart';
import 'package:flutterbase/Widgets/menu_widget.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class cameraScreen extends StatefulWidget {
  const cameraScreen({Key? key}) : super(key: key);

  @override
  State<cameraScreen> createState() => cameraScreenState();
}

class cameraScreenState extends State<cameraScreen> {
  MobileScannerController controller = MobileScannerController();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          const menuTopBar(),
          CameraWidget(),
          const menuBottomBar(),
        ],
      ),
    );
  }
}
