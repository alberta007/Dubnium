import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterbase/Widgets/members_widget.dart';
import 'package:flutterbase/Widgets/menu_widget.dart';
import 'package:flutterbase/other/firebase_functions.dart';
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
  late List<String> allMembers;
  late List<String> allFriends;
  late List<List<String>> allMembersPreferences;
  late List<List<String>> allFriendsPreferences;

  List<String> allPreferencesList = [
    "Nötter",
    "Mjölk",
    "Laktos",
    "Råg",
    "Vete",
    "Sesamfrön",
    "Sojabönor",
    "Spannmål som innehåller gluten",
    "Havre"
  ];

  List<String> filteredList = [
    "Nötter",
    "Mjölk",
    "Laktos",
    "Råg",
    "Vete",
    "Sesamfrön",
    "Sojabönor",
    "Spannmål som innehåller gluten",
    "Havre"
  ];

  List<String> profilePreferences = ["Nötter", "Mjölk"];

  @override
  void initState() {
    setup();
    super.initState();
  }

  void setup() async {
    List<String> allPreferences = await FirebaseFunctions().allPreferences();
    debugPrint('Here1');

    List<String> allMembers = await FirebaseFunctions().allMembers();
    allMembers.remove('You');

    List<String> allFriends = await FirebaseFunctions().allFriends();

    List<String> youPreferences =
        await FirebaseFunctions().fetchMembersPreferences('You');
    debugPrint('youPreferences: $youPreferences');

    List<List<String>> membersPreferences = [];
    List<List<String>> friendsPreferences = [];

    for (String member in allMembers) {
      List<String> preferences =
          await FirebaseFunctions().fetchMembersPreferences(member);

      membersPreferences.add(preferences);
    }

    for (String friend in allFriends) {
      List<String> preferences =
          await FirebaseFunctions().fetchFriendsPreferences(friend);

      friendsPreferences.add(preferences);
    }

    setState(() {
      this.allPreferencesList = allPreferences;
      this.filteredList = List.from(allPreferences);
      this.profilePreferences = youPreferences;
      this.allMembers = allMembers;
      this.allFriends = allFriends;
      this.allMembersPreferences = membersPreferences;
      this.allFriendsPreferences = friendsPreferences;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(flex: 12, child: menuTopBar()),
          Expanded(
            flex: 76,
            child: DefaultTabController(
              length: 3,
              child: Scaffold(
                backgroundColor: Color(0xFFEAF5E4),
                body: Column(
                  children: [
                    TabBar(
                      labelColor: Color(0xFF3C2615),
                      tabs: [
                        Tab(
                            child: Text("Your (${profilePreferences.length})",
                                style: TextStyle(fontSize: 20))),
                        Tab(
                            child:
                                Text("Other", style: TextStyle(fontSize: 20))),
                        Tab(
                            child: Text("All (${allPreferencesList.length})",
                                style: TextStyle(fontSize: 20))),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Search',
                            suffixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                        onChanged: (value) {
                          setState(
                            () {
                              filteredList = allPreferencesList
                                  .where((string) => string
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                            },
                          );
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
                                              color: Color.fromARGB(
                                                  255, 222, 124, 117),
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
                            child: DefaultTabController(
                              length: 2,
                              child: Scaffold(
                                body: Column(
                                  children: [
                                    Container(
                                      color: Color(0xFFEAF5E4),
                                      child: TabBar(
                                        tabs: [
                                          Tab(
                                              child: Text("Members",
                                                  style:
                                                      TextStyle(fontSize: 20))),
                                          Tab(
                                              child: Text("Friends",
                                                  style:
                                                      TextStyle(fontSize: 20)))
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        children: [
                                          Container(
                                            color: Color(0xFFEAF5E4),
                                            child: ListView.builder(
                                              itemCount: filteredList.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return ListTile(
                                                  title: Align(
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      width: 300,
                                                      height: 120,
                                                      decoration: BoxDecoration(
                                                        //color: Colors.blue,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Expanded(
                                                            child: Icon(
                                                                Icons.circle,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        222,
                                                                        124,
                                                                        117),
                                                                size: 90),
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  filteredList[
                                                                      index],
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xFF3C2615),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                      fontSize:
                                                                          26,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis),
                                                                ),
                                                                Text(
                                                                  "Tap for info >",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFF3C2615),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .bottomRight,
                                                              child: SizedBox(
                                                                width: 120,
                                                                height: 35,
                                                                child:
                                                                    TextButton(
                                                                  style:
                                                                      ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all<
                                                                            Color>(
                                                                      Color(
                                                                          0xFF87A330),
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          AddPreferenceOverlay(),
                                                                    );
                                                                  },
                                                                  child: Text(
                                                                    "Remove",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18,
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
                                          ),
                                          Container(
                                            color: Color(0xFFEAF5E4),
                                            child: ListView.builder(
                                              itemCount: filteredList.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return ListTile(
                                                  title: Align(
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      width: 300,
                                                      height: 120,
                                                      decoration: BoxDecoration(
                                                        //color: Colors.blue,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Expanded(
                                                            child: Icon(
                                                                Icons.circle,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        222,
                                                                        124,
                                                                        117),
                                                                size: 90),
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  filteredList[
                                                                      index],
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xFF3C2615),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                      fontSize:
                                                                          26,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis),
                                                                ),
                                                                Text(
                                                                  "Tap for info >",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFF3C2615),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .bottomRight,
                                                              child: SizedBox(
                                                                width: 120,
                                                                height: 35,
                                                                child:
                                                                    TextButton(
                                                                  style:
                                                                      ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all<
                                                                            Color>(
                                                                      Color(
                                                                          0xFF87A330),
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          AddPreferenceOverlay(),
                                                                    );
                                                                  },
                                                                  child: Text(
                                                                    "Remove",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18,
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
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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
                                              color: Color.fromARGB(
                                                  255, 222, 124, 117),
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
                                                    overflow:
                                                        TextOverflow.ellipsis),
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
                                                    builder: (BuildContext
                                                            context) =>
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
                  ],
                ),
              ),
            ),
          ),
          Expanded(flex: 12, child: menuBottomBar()),
        ],
      ),
    );
  }
}
