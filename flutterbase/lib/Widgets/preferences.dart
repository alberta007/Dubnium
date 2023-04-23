import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterbase/overlays/addpreferenceoverlay.dart';
import 'package:flutterbase/overlays/scannedoverlay.dart';
import '../overlays/settings.dart';
import '../other/products.dart';
import '../other/scan.dart';
import 'package:flutterbase/overlays/profileoverlay.dart';
import 'package:firebase_database/firebase_database.dart';

class MyCustomClass2 extends StatefulWidget {
  static ProfileOverlay profile = ProfileOverlay();
  static SettingsDialog dialog = SettingsDialog();
  static ScanBarcode scanBarcode = ScanBarcode();

  MyCustomClass2({super.key});

  @override
  State<MyCustomClass2> createState() => _MyCustomClass2State();
}

class _MyCustomClass2State extends State<MyCustomClass2> {
  final user = FirebaseAuth.instance.currentUser!;

  List<String> allPreferencesList = [
    "Nuts",
    "Fish",
    "Apple",
    "Meat",
    "Vegan",
    "Vegetarian",
    "Chocolate",
    "Milk",
    "Banana"
  ];

  List<String> filteredList = [
    "Nuts",
    "Fish",
    "Apple",
    "Meat",
    "Vegan",
    "Vegetarian",
    "Chocolate",
    "Milk",
    "Banana"
  ];

  List<String> profilePreferences = ["Nuts", "Apple"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            backgroundColor: Color(0xFFEAF5E4),
            appBar: AppBar(
              backgroundColor: Color(0xFFEAF5E4),
              title:
                  const Text('NAV', style: TextStyle(color: Color(0xFF3C2615))),
              centerTitle: true,
              toolbarHeight: 100,
              bottom: TabBar(
                labelColor: Color(0xFF3C2615),
                tabs: [
                  Tab(text: "Your (${profilePreferences.length})"),
                  Tab(text: "Other ()"),
                  Tab(text: "All (${allPreferencesList.length})"),
                ],
              ),
            ),
            body: Column(children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Search',
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                  onChanged: (value) {
                    setState(() {
                      filteredList = allPreferencesList
                          .where((string) => string
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // First Tab View
                    ListView.builder(
                      itemCount: profilePreferences.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 300,
                              height: 120,
                              decoration: BoxDecoration(
                                //color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Icon(Icons.circle,
                                        color:
                                            Color.fromARGB(255, 222, 124, 117),
                                        size: 90),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          profilePreferences[index],
                                          style: TextStyle(
                                            color: Color(0xFF3C2615),
                                            fontWeight: FontWeight.w800,
                                            fontSize: 26,
                                          ),
                                        ),
                                        Text(
                                          "Tap for info >",
                                          style: TextStyle(
                                            color: Color(0xFF3C2615),
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: SizedBox(
                                        width: 120,
                                        height: 35,
                                        child: TextButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                              Color(0xFF87A330),
                                            ),
                                          ),
                                          onPressed: () {
                                            print("hello world");
                                          },
                                          child: Text(
                                            "Remove",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // Second Tab View
                    Center(
                      child: Text(
                        "Other ()",
                        style: TextStyle(
                          color: Color(0xFF3C2615),
                          fontWeight: FontWeight.w800,
                          fontSize: 36,
                        ),
                      ),
                    ),
                    ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 300,
                              height: 120,
                              decoration: BoxDecoration(
                                //color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Icon(Icons.circle,
                                        color:
                                            Color.fromARGB(255, 222, 124, 117),
                                        size: 90),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          filteredList[index],
                                          style: TextStyle(
                                            color: Color(0xFF3C2615),
                                            fontWeight: FontWeight.w800,
                                            fontSize: 26,
                                          ),
                                        ),
                                        Text(
                                          "Tap for info >",
                                          style: TextStyle(
                                            color: Color(0xFF3C2615),
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: SizedBox(
                                        width: 120,
                                        height: 35,
                                        child: TextButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                              Color(0xFF87A330),
                                            ),
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AddPreferenceOverlay(),
                                            );
                                          },
                                          child: Text(
                                            "Add",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ])));
  }
}
