import 'package:flutter/material.dart';

import 'main2.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHome());
  }
}

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.green.shade800,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 300),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey.shade400),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.green.shade800),
                    minimumSize: MaterialStateProperty.all(Size(200, 100))),
                child: Text(
                  "Go!",
                  style: TextStyle(fontSize: 40),
                ),
                onPressed: () => MyCustomClass.openNewScreen(context)),
          ),
        ),
      ),
    );
  }
}
