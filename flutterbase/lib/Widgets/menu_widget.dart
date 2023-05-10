import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutterbase/camera_screen.dart';
import 'package:flutterbase/social_screen.dart';
import 'package:flutterbase/Widgets/preferences.dart';
import 'package:flutterbase/overlays/profile_screen.dart';
import 'package:flutterbase/Widgets/members_widget.dart';

import '../main.dart';

enum MenuItem {
  item1,
  item2,
  item3,
}

class menuTopBar extends StatelessWidget {
  Future<List<String>> fetchFriendRequests() async {
    final user = FirebaseAuth.instance.currentUser!;

    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('Users');

    final snapshotRequests = await userRef.child('${user.displayName}/Friendrequests').get(); // get snapshot of friendrequests

    List<String> temp = []; // list to return

    if (snapshotRequests.exists) {
      // if there exists any friendrequests
      List<dynamic> requestListDynamic = snapshotRequests.value as List<dynamic>; // creates a list of the friend requests

      List<String> requestList = requestListDynamic.map((member) => member.toString()).toList(); // creates a list of the friend requests

      temp = requestList; // list to return == the friend request list
    } else {
      // if friend request doesn't exist
      temp = []; // list to return is empty
    }

    print("Testar $temp");
    return temp;
  }

  Future<void> acceptFriendRequest(String friendName) async {
    final user = FirebaseAuth.instance.currentUser!;

    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('Users');

    final snapshotRequests = await userRef.child('${user.displayName}/Friendrequests').get(); // snapshot of friendrequest

    List<dynamic> requestListDynamic = snapshotRequests.value as List<dynamic>;

    List<String> requestList = requestListDynamic.map((member) => member.toString()).toList(); // creates a list of the friend requests

    requestList.remove(friendName);
    await userRef.update({
      '${user.displayName}/Friendrequests': requestList,
    });
    final snapshotActive = await userRef.child('${friendName}/Members/Active/You').get();

    final snapshotInactive = await userRef.child('${friendName}/Members/Inactive/You').get();

    if (snapshotActive.exists) {
      await userRef.child('${user.displayName}/Friends/Active/$friendName').set(friendName);
      await userRef.child('$friendName/Friends/Active/${user.displayName}').set(user.displayName);
    } else if (snapshotInactive.exists) {
      await userRef.child('${user.displayName}/Friends/Inactive/${user.displayName}').set(friendName);
      await userRef.child('$friendName/Friends/Inactive/$friendName').set(user.displayName);
    }
  }

  const menuTopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: double.infinity,
        height: 120,
        padding: EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Color(0xFFEAF5E4),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                  width: 320,
                  height: 90,
                  padding: EdgeInsets.all(4.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 3.0,
                        color: Color(0xFF87A330),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SocialScreen(),
                              ),
                            );
                          },
                          iconSize: 40,
                          style: IconButton.styleFrom(
                            highlightColor: Colors.green.withOpacity(0.2),
                          ),
                          icon: Icon(
                            Icons.diversity_3,
                            color: Color(0xff3c2615),
                            size: 40,
                            semanticLabel: 'Text to announce in accessibility modes',
                          )),
                      Spacer(),
                      Text(
                        "Dr.Preference",

                        //overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            //color: Color(0xFF87A330),
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            fontSize: 30,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: <Color>[
                                  Color(0xff3c2615),
                                  Color(0xFF87A330)
                                  //Color(0xffcad593)
                                  //add more color here.
                                ],
                              ).createShader(Rect.fromLTWH(120.0, 50.0, 200.0, 50.0))),
                      ),
                      //Spacer(),

                      PopupMenuButton<MenuItem>(
                        onSelected: (value) async {
                          if (value == MenuItem.item1) {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProfileOverlay(),
                            ));
                          } else if (value == MenuItem.item2) {
                            // add friend requests button
                            List<String> fetchedRequestList = await fetchFriendRequests();

                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Friend requests:"),
                                  actions: [
                                    Container(
                                      width: 320,
                                      height: 200,
                                      child: ListView.builder(
                                        itemCount: fetchedRequestList.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(
                                              fetchedRequestList[index],
                                              style: const TextStyle(fontSize: 25),
                                            ),
                                            trailing: Stack(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    acceptFriendRequest(fetchedRequestList[index]);
                                                    Navigator.pop(context);
                                                  },
                                                  icon: Icon(Icons.check),
                                                  color: Colors.green,
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          } else if (value == MenuItem.item3) {
                            FirebaseAuth.instance.signOut();

                            FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => MyHome()),
                            );
                          }
                        },
                        icon: Icon(
                          Icons.menu,
                          size: 40,
                          color: Color(0xFF87A330),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: MenuItem.item1,
                            child: Text('Profile'),
                          ),
                          PopupMenuItem(
                            value: MenuItem.item2,
                            child: Text('Friend requests'),
                          ),
                          PopupMenuItem(
                            value: MenuItem.item3,
                            child: Text('Sign Out'),
                          ),
                        ],
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.white,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class menuBottomBar extends StatelessWidget {
  const menuBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: const BoxDecoration(
          color: Color(0xFFEAF5E4),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: 320,
            height: 120,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 3.0,
                  color: Color(0xFF87A330),
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 0.0,
              horizontal: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    iconSize: 60,
                    style: IconButton.styleFrom(
                      backgroundColor: Color(0xFFEAF5E4),
                      highlightColor: Colors.green.withOpacity(0.2),
                      elevation: 2,
                      shadowColor: Color.fromARGB(255, 0, 0, 0),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => cameraScreen()),
                        ),
                      );
                    },
                    icon: const ImageIcon(
                      AssetImage("assets/images/scan-28.png"),
                      color: Colors.black,
                      //semanticLabel: 'Text to announce in accessibility modes',
                    ),
                  ),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Color(0xFFEAF5E4),
                      highlightColor: Colors.green.withOpacity(0.2),
                      elevation: 2,
                      shadowColor: Color.fromARGB(255, 0, 0, 0),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    iconSize: 60,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyCustomClass2(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.flatware,
                      color: Colors.black,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
