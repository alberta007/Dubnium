import 'package:flutter/material.dart';

class SettingsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade400,
      title: Text('Settings'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              child: Text('General'),
              onPressed: () {
                // Navigate to general settings screen
              },
            ),
            ElevatedButton(
              child: Text('General'),
              onPressed: () {
                // Navigate to general settings screen
              },
            ),
            Divider(),
            ElevatedButton(
              child: Icon(Icons.settings_applications_sharp),
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(10, 50))),
              onPressed: () {
                // Navigate to general settings screen
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
