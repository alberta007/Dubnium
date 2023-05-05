import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Socials extends StatefulWidget {
  @override
  _SocialsState createState() => _SocialsState();
}

class _SocialsState extends State<Socials> {
  bool onMembersScreen = true, isActive = true;

  void initState() {
    super.initState();
    firstScreen();
  }

  Future<void> firstScreen() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFEAF5E4),
      body: Center(
        child: Container(
          height: 610,
          width: 320,
          color: Color(0xFFEAF5E4),
          child: Stack(
            children: [
              onMembersScreen ? MembersList() : FriendsList(),
              Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      onMembersScreen = true;
                      isActive = true;
                    });
                  },
                  child: Text(
                    'Members ',
                    style: TextStyle(
                        fontSize: 30,
                        color: isActive ? Colors.black : Colors.grey.shade600),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      onMembersScreen = false;
                      isActive = false;
                    });
                  },
                  child: Text(
                    'Friends',
                    style: TextStyle(
                        fontSize: 30,
                        color: isActive ? Colors.grey.shade600 : Colors.black),
                  ),
                ),
              ),
              Positioned(
                top: 60,
                child: Container(
                  width: 320,
                  height: 3,
                  decoration: const BoxDecoration(
                    color: Color(0xFF87A330),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MembersList extends StatefulWidget {
  const MembersList({super.key});

  @override
  State<MembersList> createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
  List<String> activemembers = [];
  List<String> activemembersSorted = [];
  final user = FirebaseAuth.instance.currentUser!;
  bool isActive = true;
  String onOff = "Off", memberOrFriend = "Add member";
  int numberOfActive = 0, numberOfInactive = 0;

  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  Future<void> fetchMembers() async {
    List<String> fetchedActiveMembers = await fetchActiveMemberList();
    List<String> fetchedInactiveMembers = await fetchUnActiveMemberList();

    setState(() {
      activemembers = fetchedActiveMembers;
      activemembersSorted = activemembers;

      numberOfActive = fetchedActiveMembers.length;
      numberOfInactive = fetchedInactiveMembers.length;

      fetchedActiveMembers.sort((a, b) => b.compareTo(a));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 470,
            width: 320,
            color: Color(0xFFEAF5E4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        String newMemberName = '';
                        return AlertDialog(
                          title: Text('Add a new member'),
                          content: TextField(
                            onChanged: (value) {
                              newMemberName = value;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Enter the new member name',
                            ),
                          ),
                          actions: [
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                const SizedBox(
                                  width: 120,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    String member =
                                        await addMemberToList(newMemberName);
                                    List<String> updatedMembersList =
                                        await fetchActiveMemberList();

                                    setState(() {
                                      activemembers = updatedMembersList;
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color(0xFF87A330)),
                                  ),
                                  child: Text('Add'),
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF87A330)),
                    minimumSize: MaterialStateProperty.all(Size(380, 50)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  child: Text(memberOrFriend,
                      style: TextStyle(
                          fontSize: 24,
                          color: Color.fromARGB(255, 255, 255, 255))),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 320,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        activemembers = activemembersSorted
                            .where((string) => string
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search member',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 320,
                    height: 3,
                    decoration: const BoxDecoration(
                      color: Color(0xFF87A330),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 320,
                    height: 43,
                    color: Color(0xFFEAF5E4),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () async {
                              List<String> fetchedActiveMembers =
                                  await fetchActiveMemberList();
                              List<String> fetchedInactiveMembers =
                                  await fetchActiveMemberList();
                              isActive = true;

                              setState(() {
                                activemembers = fetchedActiveMembers;
                                isActive = true;
                                onOff = "Off";
                                numberOfActive = fetchedActiveMembers.length;
                                numberOfInactive =
                                    fetchedInactiveMembers.length;
                              });
                            },
                            child: Text(
                              'Active($numberOfActive)',
                              style: TextStyle(
                                fontSize: 24,
                                color: isActive
                                    ? Colors.black
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            onPressed: () async {
                              List<String> fetchedActiveMembers =
                                  await fetchActiveMemberList();
                              List<String> fetchedUnActiveMembers =
                                  await fetchUnActiveMemberList();
                              setState(() {
                                activemembers = fetchedUnActiveMembers;
                                numberOfActive = fetchedActiveMembers.length;

                                isActive = false;
                                onOff = "On";
                                numberOfInactive =
                                    fetchedUnActiveMembers.length;
                              });
                            },
                            child: Text(
                              'Inactive($numberOfInactive)',
                              style: TextStyle(
                                fontSize: 25,
                                color: isActive
                                    ? Colors.grey.shade600
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment(0.0, 1),
          child: Container(
              width: 320,
              height: 370,
              color: const Color(0xFFEAF5E4),
              child: ListView.builder(
                itemCount: activemembers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: ElevatedButton(
                      onPressed: () async {
                        if (isActive) {
                          await changeToInactive(activemembers[index]);
                          setState(() {
                            activemembers.removeAt(index);
                          });
                        } else if (!isActive) {
                          await changeToActive(activemembers[index]);
                          setState(() {
                            activemembers.removeAt(index);
                          });
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all((Colors.amber)),
                        minimumSize: MaterialStateProperty.all(Size(55, 40)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      child: Text(onOff),
                    ),
                    title: Text(
                      activemembers[index],
                      style: TextStyle(color: Colors.black, fontSize: 25),
                    ),
                    trailing: Wrap(spacing: 5, children: <Widget>[
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFF87A330))),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              String updatedMemberName = activemembers[index];
                              String oldName = updatedMemberName;
                              return AlertDialog(
                                title: const Text('Edit member'),
                                content: TextField(
                                  onChanged: (value) {
                                    updatedMemberName = value;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Enter the updated member name',
                                  ),
                                  controller: TextEditingController(
                                      text: activemembers[index]),
                                ),
                                actions: [
                                  Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () async {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Are you sure?'),
                                                  actions: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .red)),
                                                          child:
                                                              const Text('No'),
                                                        ),
                                                        SizedBox(
                                                          width: 100,
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            await deleteMember(
                                                              activemembers[
                                                                  index],
                                                            );

                                                            setState(() {
                                                              activemembers
                                                                  .removeAt(
                                                                      index);
                                                            });
                                                            Navigator.pop(
                                                                context);

                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Color(
                                                                        0xFF87A330)),
                                                          ),
                                                          child:
                                                              const Text('Yes'),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.red)),
                                        child: const Text('Delete'),
                                      ),
                                      const SizedBox(width: 110),
                                      ElevatedButton(
                                        onPressed: () async {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Are you sure?'),
                                                  actions: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .red)),
                                                          child:
                                                              const Text('No'),
                                                        ),
                                                        SizedBox(
                                                          width: 100,
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            await updateMemberName(
                                                                activemembers[
                                                                    index],
                                                                updatedMemberName);

                                                            setState(() {
                                                              activemembers[
                                                                      index] =
                                                                  updatedMemberName;
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Color(
                                                                        0xFF87A330)),
                                                          ),
                                                          child:
                                                              const Text('Yes'),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Color(0xFF87A330)),
                                        ),
                                        child: const Text('Save'),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text('Edit'),
                      ),
                    ]),
                  );
                },
              )),
        )
      ],
    );
  }

  Future<String> addMemberToList(String newMember) async {
    final user = FirebaseAuth.instance.currentUser!;

    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('Users');

    final snapshot = await userRef
        .child('${user.displayName}/ActiveAndInactive/Members/Active')
        .get();

    await userRef
        .child('${user.displayName}/Members/Active/$newMember')
        .set(newMember);

    return newMember;
  }

  Future<List<String>> fetchActiveMemberList() async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance
        .reference()
        .child('Users/${user.displayName}/Members');

    final activeSnapshot = await userRef.child('Active').get();

    List<String> activeMembers = [];
    if (activeSnapshot.exists) {
      Map<dynamic, dynamic> membersMap = activeSnapshot.value as Map;

      if (membersMap != null) {
        membersMap.forEach((key, value) {
          activeMembers.add(key);
        });
      }
    } else {
      activeMembers = [];
    }

    print("People: $activeMembers");
    return activeMembers;
  }

  Future<List<String>> fetchUnActiveMemberList() async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance
        .reference()
        .child('Users/${user.displayName}/Members');

    final activeSnapshot = await userRef.child('Inactive').get();

    List<String> activeMembers = [];

    if (activeSnapshot.exists) {
      Map<dynamic, dynamic> membersMap = activeSnapshot.value as Map;
      if (membersMap != null) {
        membersMap.forEach((key, value) {
          activeMembers.add(key);
        });
      } else {
        activeMembers = [];
      }
    } else {
      activeMembers = [];
    }

    print("People: $activeMembers");
    return activeMembers;
  }

  Future<List<String>> updateMemberName(String oldName, String newName) async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('Users');

    final preferenceActiveSnapshot = await userRef
        .child('${user.displayName}/Members/Active/$oldName/Preferences')
        .get();

    final preferenceInactiveSnapshot = await userRef
        .child('${user.displayName}/Members/Inactive/$oldName/Preferences')
        .get();

    List<String> updatedList = [];

    if (preferenceActiveSnapshot.exists) {
      List<String> preferenceList =
          await databaseList(preferenceActiveSnapshot);

      await userRef.update({
        '${user.displayName}/Members/Active/$oldName': null,
        '${user.displayName}/Members/Active/$newName/Preferences':
            preferenceList,
      });
    } else if (preferenceInactiveSnapshot.exists) {
      List<String> preferenceList =
          await databaseList(preferenceInactiveSnapshot);

      await userRef.update({
        '${user.displayName}/Members/Inactive/$oldName': null,
        '${user.displayName}/Members/Inactive/$newName/Preferences':
            preferenceList,
      });
    } else {
      final ActiveSnapshot = await userRef
          .child('${user.displayName}/Members/Active/$oldName')
          .get();

      final InactiveSnapshot = await userRef
          .child('${user.displayName}/Members/Inactive/$oldName')
          .get();

      if (ActiveSnapshot.exists) {
        await userRef.update({
          '${user.displayName}/Members/Active/$oldName': null,
          '${user.displayName}/Members/Active/$newName': newName,
        });
      } else if (InactiveSnapshot.exists) {
        await userRef.update({
          '${user.displayName}/Members/Inactive/$oldName': null,
          '${user.displayName}/Members/Inactive/$newName': newName,
        });
      }
    }

    return updatedList;
  }

  Future<List<String>> deleteMember(String memberName) async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('Users');

    List<String> updatedList = [];
    final ActiveSnapshot = await userRef
        .child('${user.displayName}/Members/Active/$memberName')
        .get();

    final InactiveSnapshot = await userRef
        .child('${user.displayName}/Members/Inactive/$memberName')
        .get();

    if (ActiveSnapshot.exists) {
      await userRef.update({
        '${user.displayName}/Members/Active/$memberName': null,
      });
    } else if (InactiveSnapshot.exists) {
      await userRef.update({
        '${user.displayName}/Members/Inactive/$memberName': null,
      });
    }

    return updatedList;
  }

  Future<List<String>> changeToInactive(String change) async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance
        .reference()
        .child('Users/${user.displayName}/Members');

    final snapshotActive = await userRef.child('Active/$change').get();

    List<String> newList = [];

    if (snapshotActive.exists) {
      final snapshotActivePreferences =
          await userRef.child('Active/$change/Preferences').get();

      if (snapshotActivePreferences.exists) {
        List<String> membersInactiveList =
            await databaseList(snapshotActivePreferences);

        await userRef.update({
          'Active/$change': null,
          'Inactive/$change/Preferences': membersInactiveList,
        });
      } else {
        await userRef.update({
          'Active/$change': null,
          'Inactive/$change': change,
        });
      }
    }
    return newList;
  }

  Future<List<String>> changeToActive(String change) async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance
        .reference()
        .child('Users/${user.displayName}/Members');

    final snapshotActive = await userRef.child('Inactive/$change').get();

    List<String> newList = [];

    if (snapshotActive.exists) {
      final snapshotActivePreferences =
          await userRef.child('Inactive/$change/Preferences').get();

      if (snapshotActivePreferences.exists) {
        List<String> membersInactiveList =
            await databaseList(snapshotActivePreferences);

        await userRef.update({
          'Inactive/$change': null,
          'Active/$change/Preferences': membersInactiveList,
        });
      } else {
        await userRef.update({
          'Inactive/$change': null,
          'Active/$change': change,
        });
      }
    }
    return newList;
  }

  Future<List<String>> databaseList(DataSnapshot snapshot) async {
    List<dynamic> databaseListDynamic = snapshot.value as List<dynamic>;

    List<String> dataBaseList =
        databaseListDynamic.map((member) => member.toString()).toList();

    return dataBaseList;
  }
}

class FriendsList extends StatefulWidget {
  const FriendsList({super.key});

  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  List<String> activeFriends = [];
  List<String> activeFriendsSorted = [];

  final user = FirebaseAuth.instance.currentUser!;
  bool isActive = true;
  String onOff = "Off", memberOrFriend = "Add member";
  int numberOffActive = 0, numberOfInactive = 0;

  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  Future<void> fetchMembers() async {
    List<String> fetchedActiveFriends = await fetchActiveFriendList();
    List<String> fetchedInactiveFriends = await fetchUnActiveFriendsList();

    setState(() {
      numberOffActive = fetchedActiveFriends.length;
      numberOfInactive = fetchedInactiveFriends.length;

      activeFriends = fetchedActiveFriends;
      activeFriendsSorted = [];
/*    
      fetchedActiveMembers.sort((a, b) => b.compareTo(a));
  */
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 470,
            width: 320,
            color: Color(0xFFEAF5E4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 320,
                  height: 55,
                  child: Stack(children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: ElevatedButton(
                        onPressed: () async {
                          List<String> fetchedRequestList =
                              await fetchFriendRequests();

                          // ignore: use_build_context_synchronously
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
                                                  style: const TextStyle(
                                                      fontSize: 25)),
                                              trailing: Stack(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      acceptFriendRequest(
                                                          fetchedRequestList[
                                                              index]);
                                                      Navigator.pop(context);
                                                    },
                                                    icon: Icon(Icons.check),
                                                    color: Colors.green,
                                                  )
                                                ],
                                              ),
                                            );
                                          }),
                                    )
                                  ],
                                );
                              });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF87A330)),
                          minimumSize: MaterialStateProperty.all(Size(150, 50)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        child: const Text("Friend requests",
                            style: TextStyle(
                                fontSize: 17,
                                color: Color.fromARGB(255, 255, 255, 255))),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              String newMemberName = '';
                              return AlertDialog(
                                title: Text('Add a new friend'),
                                content: TextField(
                                  onChanged: (value) {
                                    newMemberName = value;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Enter friend name ',
                                  ),
                                ),
                                actions: [
                                  Row(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 120,
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          String test = await sendFriendRequest(
                                              newMemberName);

                                          if (test == "No") {
                                            Fluttertoast.showToast(
                                                msg: 'Username doesnt exist',
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Color(0xFF87A330),
                                                fontSize: 20.0);
                                          }
                                          setState(() {});
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Color(0xFF87A330)),
                                        ),
                                        child: Text('Add'),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            },
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF87A330)),
                          minimumSize: MaterialStateProperty.all(Size(150, 50)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        child: Text("Add new friend",
                            style: TextStyle(
                                fontSize: 17,
                                color: Color.fromARGB(255, 255, 255, 255))),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 320,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        activeFriends = activeFriendsSorted
                            .where((string) => string
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search member',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 320,
                    height: 3,
                    decoration: const BoxDecoration(
                      color: Color(0xFF87A330),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 320,
                    height: 43,
                    color: Color(0xFFEAF5E4),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () async {
                              List<String> fetchedActiveFriends =
                                  await fetchActiveFriendList();
                              isActive = true;

                              setState(() {
                                activeFriends = fetchedActiveFriends;
                                isActive = true;
                                onOff = "Off";
                                numberOffActive = fetchedActiveFriends.length;
                              });
                            },
                            child: Text(
                              'Active($numberOffActive)',
                              style: TextStyle(
                                fontSize: 24,
                                color: isActive
                                    ? Colors.black
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            onPressed: () async {
                              List<String> fetchedInactiveFriendsList =
                                  await fetchUnActiveFriendsList();
                              setState(() {
                                activeFriends = fetchedInactiveFriendsList;
                                isActive = false;
                                onOff = "On";
                                numberOfInactive =
                                    fetchedInactiveFriendsList.length;
                              });
                            },
                            child: Text(
                              'Inactive($numberOfInactive)',
                              style: TextStyle(
                                fontSize: 25,
                                color: isActive
                                    ? Colors.grey.shade600
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment(0.0, 1),
          child: Container(
              width: 320,
              height: 370,
              color: const Color(0xFFEAF5E4),
              child: ListView.builder(
                itemCount: activeFriends.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: ElevatedButton(
                      onPressed: () async {
                        if (isActive) {
                          await changeToInactive(activeFriends[index]);
                          setState(() {
                            activeFriends.removeAt(index);
                          });
                        } else if (!isActive) {
                          await changeToActive(activeFriends[index]);
                          setState(() {
                            activeFriends.removeAt(index);
                          });
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all((Colors.amber)),
                        minimumSize: MaterialStateProperty.all(Size(55, 40)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      child: Text(onOff),
                    ),
                    title: Text(
                      activeFriends[index],
                      style: TextStyle(color: Colors.black, fontSize: 25),
                    ),
                    trailing: Wrap(spacing: 5, children: <Widget>[
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFF87A330))),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              String updatedMemberName = activeFriends[index];
                              String oldName = updatedMemberName;
                              return AlertDialog(
                                title: const Text('Edit member'),
                                content: TextField(
                                  onChanged: (value) {
                                    updatedMemberName = value;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Enter the updated member name',
                                  ),
                                  controller: TextEditingController(
                                      text: activeFriends[index]),
                                ),
                                actions: [
                                  Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () async {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Are you sure?'),
                                                  actions: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .red)),
                                                          child:
                                                              const Text('No'),
                                                        ),
                                                        SizedBox(
                                                          width: 100,
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                                context);

                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Color(
                                                                        0xFF87A330)),
                                                          ),
                                                          child:
                                                              const Text('Yes'),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.red)),
                                        child: const Text('Delete'),
                                      ),
                                      const SizedBox(width: 110),
                                      ElevatedButton(
                                        onPressed: () async {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Are you sure?'),
                                                  actions: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .red)),
                                                          child:
                                                              const Text('No'),
                                                        ),
                                                        SizedBox(
                                                          width: 100,
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Color(
                                                                        0xFF87A330)),
                                                          ),
                                                          child:
                                                              const Text('Yes'),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Color(0xFF87A330)),
                                        ),
                                        child: const Text('Save'),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text('Edit'),
                      ),
                    ]),
                  );
                },
              )),
        )
      ],
    );
  }

  Future<String> sendFriendRequest(String friendName) async {
    final user = FirebaseAuth.instance.currentUser!;

    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('Users');

    final snapshot = await userRef.child(friendName).get();

    List<String> requestList = [];

    if (snapshot.exists) {
      final friendRequestsExist =
          await userRef.child('${friendName}/Friendrequests').get();

      if (friendRequestsExist.exists) {
        List<dynamic> friendRequestListDynamic =
            friendRequestsExist.value as List<dynamic>;

        List<String> friendRequestList = friendRequestListDynamic
            .map((member) => member.toString())
            .toList();

        friendRequestList.add('${user.displayName}');

        await userRef.update({
          '$friendName/Friendrequests': friendRequestList,
        });
        requestList = friendRequestList;
      } else {
        requestList = ['${user.displayName}'];
        await userRef.update({
          '$friendName/Friendrequests': requestList,
        });
      }
    } else {
      friendName = "No";
    }
    return friendName;
  }

  Future<List<String>> fetchFriendRequests() async {
    final user = FirebaseAuth.instance.currentUser!;

    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('Users');

    final snapshotRequests =
        await userRef.child('${user.displayName}/Friendrequests').get();

    List<String> temp = [];

    if (snapshotRequests.exists) {
      List<dynamic> requestListDynamic =
          snapshotRequests.value as List<dynamic>;

      List<String> requestList =
          requestListDynamic.map((member) => member.toString()).toList();
      temp = requestList;
    } else {
      temp = [];
    }

    print("Testar $temp");
    return temp;
  }

  Future<void> acceptFriendRequest(String friendName) async {
    final user = FirebaseAuth.instance.currentUser!;

    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('Users');

    final snapshotRequests =
        await userRef.child('${user.displayName}/Friendrequests').get();

    List<dynamic> requestListDynamic = snapshotRequests.value as List<dynamic>;

    List<String> requestList =
        requestListDynamic.map((member) => member.toString()).toList();

    requestList.remove(friendName);
    await userRef.update({
      '${user.displayName}/Friendrequests': requestList,
    });
    final snapshotActive =
        await userRef.child('${friendName}/Members/Active/You').get();

    final snapshotInactive =
        await userRef.child('${friendName}/Members/Inactive/You').get();

    if (snapshotActive.exists) {
      await userRef
          .child('${user.displayName}/Friends/Active/$friendName')
          .set(friendName);
      await userRef
          .child('$friendName/Friends/Active/${user.displayName}')
          .set(user.displayName);
    } else if (snapshotInactive.exists) {
      await userRef
          .child('${user.displayName}/Friends/Inactive/${user.displayName}')
          .set(friendName);
      await userRef
          .child('$friendName/Friends/Inactive/$friendName')
          .set(user.displayName);
    }
  }

  Future<List<String>> fetchActiveFriendList() async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance
        .reference()
        .child('Users/${user.displayName}/Friends');

    final activeSnapshot = await userRef.child('Active').get();

    List<String> activeMembers = [];
    if (activeSnapshot.exists) {
      Map<dynamic, dynamic> membersMap = activeSnapshot.value as Map;

      if (membersMap != null) {
        membersMap.forEach((key, value) {
          activeMembers.add(key);
        });
      }
    } else {
      activeMembers = [];
    }

    print("People: $activeMembers");
    return activeMembers;
  }

  Future<List<String>> fetchUnActiveFriendsList() async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance
        .reference()
        .child('Users/${user.displayName}/Friends');

    final activeSnapshot = await userRef.child('Inactive').get();

    List<String> unactiveMembers = [];

    if (activeSnapshot.exists) {
      Map<dynamic, dynamic> membersMap = activeSnapshot.value as Map;
      if (membersMap != null) {
        membersMap.forEach((key, value) {
          unactiveMembers.add(key);
        });
      } else {
        unactiveMembers = [];
      }
    } else {
      unactiveMembers = [];
    }

    print("People: $unactiveMembers");
    return unactiveMembers;
  }

  Future<List<String>> changeToInactive(String change) async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance
        .reference()
        .child('Users/${user.displayName}/Friends');

    final snapshotActive = await userRef.child('Active/$change').get();

    List<String> newList = [];

    if (snapshotActive.exists) {
      await userRef.update({
        'Active/$change': null,
        'Inactive/$change': change,
      });
    }
    return newList;
  }

  Future<List<String>> changeToActive(String change) async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance
        .reference()
        .child('Users/${user.displayName}/Friends');

    final snapshotActive = await userRef.child('Inactive/$change').get();

    List<String> newList = [];

    if (snapshotActive.exists) {
      await userRef.update({
        'Inactive/$change': null,
        'Active/$change': change,
      });
    }
    return newList;
  }

  Future<List<String>> databaseList(DataSnapshot snapshot) async {
    List<dynamic> databaseListDynamic = snapshot.value as List<dynamic>;

    List<String> dataBaseList =
        databaseListDynamic.map((member) => member.toString()).toList();

    return dataBaseList;
  }
}
