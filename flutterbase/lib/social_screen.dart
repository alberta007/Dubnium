import 'package:flutter/material.dart';
import 'package:flutterbase/Widgets/menu_widget.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'camera_screen.dart';
import 'Widgets/members_widget.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({Key? key}) : super(key: key);

  @override
  State<SocialScreen> createState() => _SocialScreen();
}

class _SocialScreen extends State<SocialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(
            flex: 12,
            child: menuTopBar(),
          ),
          Expanded(
            flex: 76,
            child: Container(
              child: MembersList(),
            ),
          ),
          const Expanded(
            flex: 12,
            child: menuBottomBar(),
          ),
        ],
      ),
    );
  }
}
