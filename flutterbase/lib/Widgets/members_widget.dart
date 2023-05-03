import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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
  int numberOffActive = 0, numberOfUnactive = 0;

  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  Future<void> fetchMembers() async {
    List<String> fetchedActiveMembers = await fetchActiveMemberList();
    List<String> fetchedUnactiveMembers = await fetchUnActiveMemberList();

    numberOffActive = fetchedActiveMembers.length;
    numberOfUnactive = fetchedUnactiveMembers.length;

    setState(() {
      activemembers = fetchedActiveMembers;
      activemembersSorted = activemembers;

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
                              isActive = true;

                              setState(() {
                                activemembers = fetchedActiveMembers;
                                isActive = true;
                                onOff = "Off";
                                numberOffActive = fetchedActiveMembers.length;
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
                              List<String> fetchedUnActiveMembers =
                                  await fetchUnActiveMemberList();
                              setState(() {
                                activemembers = fetchedUnActiveMembers;
                                isActive = false;
                                onOff = "On";
                                numberOfUnactive =
                                    fetchedUnActiveMembers.length;
                              });
                            },
                            child: Text(
                              'Unactive($numberOfUnactive)',
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
                          await changeToUnactive(activemembers[index]);
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
        .child('${user.displayName}/ActiveAndUnactive/Members/Active')
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
    Map<dynamic, dynamic> membersMap = activeSnapshot.value as Map;
    if (membersMap != null) {
      membersMap.forEach((key, value) {
        activeMembers.add(key);
      });
    }

    print("People: $activeMembers");
    return activeMembers;
  }

  Future<List<String>> fetchUnActiveMemberList() async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance
        .reference()
        .child('Users/${user.displayName}/Members');

    final activeSnapshot = await userRef.child('Unactive').get();

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

    final preferenceUnactiveSnapshot = await userRef
        .child('${user.displayName}/Members/Unactive/$oldName/Preferences')
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
    } else if (preferenceUnactiveSnapshot.exists) {
      List<String> preferenceList =
          await databaseList(preferenceUnactiveSnapshot);

      await userRef.update({
        '${user.displayName}/Members/Unactive/$oldName': null,
        '${user.displayName}/Members/Unactive/$newName/Preferences':
            preferenceList,
      });
    } else {
      final ActiveSnapshot = await userRef
          .child('${user.displayName}/Members/Active/$oldName')
          .get();

      final UnactiveSnapshot = await userRef
          .child('${user.displayName}/Members/Unactive/$oldName')
          .get();

      if (ActiveSnapshot.exists) {
        await userRef.update({
          '${user.displayName}/Members/Active/$oldName': null,
          '${user.displayName}/Members/Active/$newName': newName,
        });
      } else if (UnactiveSnapshot.exists) {
        await userRef.update({
          '${user.displayName}/Members/Unactive/$oldName': null,
          '${user.displayName}/Members/Unactive/$newName': newName,
        });
      }
    }
/*
    final activeSnapshot =
        await userRef.child('${user.displayName}/Members/Active').get();

    List<String> activeMembersList = await databaseList(activeSnapshot);

    List<String> updatedList;

    if (activeMembersList.contains(oldName)) {
      int index = activeMembersList.indexOf(oldName);
      activeMembersList[index] = newName;

      await userRef.update({
        '${user.displayName}/ActiveAndUnactive/Members/Active':
            activeMembersList,
        '${user.displayName}/Members/$oldName': null,
        '${user.displayName}/Members/$newName': newName,
      });
      updatedList = activeMembersList;
    } else {
      final unActivesnapshot = await userRef
          .child('${user.displayName}/ActiveAndUnactive/Members/Unactive')
          .get();

      List<String> unActiveMembersList = await databaseList(unActivesnapshot);

      int index = unActiveMembersList.indexOf(oldName);
      unActiveMembersList[index] = newName;

      await userRef.update({
        '${user.displayName}/ActiveAndUnactive/Members/Unactive':
            unActiveMembersList,
        '${user.displayName}/Members/$oldName': null,
        '${user.displayName}/Members/$newName': newName,
      });
      updatedList = unActiveMembersList;
    }
 */
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

    final UnactiveSnapshot = await userRef
        .child('${user.displayName}/Members/Unactive/$memberName')
        .get();

    if (ActiveSnapshot.exists) {
      await userRef.update({
        '${user.displayName}/Members/Active/$memberName': null,
      });
    } else if (UnactiveSnapshot.exists) {
      await userRef.update({
        '${user.displayName}/Members/Unactive/$memberName': null,
      });
    }

    return updatedList;
  }

  Future<List<String>> changeToUnactive(String change) async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance
        .reference()
        .child('Users/${user.displayName}/ActiveAndUnactive/Members');

    final snapshotActive = await userRef.child('Active').get();

    List<String> newList = [];

    if (snapshotActive.value != null) {
      List<String> membersActiveList = await databaseList(snapshotActive);

      membersActiveList.remove(change);

      List<String> newUnActiveList = [change];

      newList = membersActiveList;

      final snapshotUnactive = await userRef.child('Unactive').get();

      if (snapshotUnactive.exists) {
        List<String> membersUnactiveList = await databaseList(snapshotUnactive);

        membersUnactiveList.add(change);

        await userRef.update({
          'Active': membersActiveList,
          'Unactive': membersUnactiveList,
        });
      } else {
        List<String> newUnactiveList = [change];
        await userRef.update({
          'Active': membersActiveList,
          'Unactive': newUnactiveList,
        });
      }
    }

    return newList;
  }

  Future<List<String>> changeToActive(String change) async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance
        .reference()
        .child('Users/${user.displayName}/ActiveAndUnactive/Members');

    final snapshotUnactive = await userRef.child('Unactive').get();

    List<String> newList = [];

    if (snapshotUnactive.value != null) {
      List<String> membersUnactiveList = await databaseList(snapshotUnactive);

      membersUnactiveList.remove(change);

      List<String> newUnActiveList = [change];

      newList = membersUnactiveList;

      final snapshotActive = await userRef.child('Active').get();

      if (snapshotActive.exists) {
        List<String> membersActiveList = await databaseList(snapshotActive);

        membersActiveList.add(change);

        await userRef.update({
          'Active': membersActiveList,
          'Unactive': membersUnactiveList,
        });
      } else {
        List<String> newUnactiveList = [change];
        await userRef.update({
          'Active': membersUnactiveList,
          'Unactive': newUnactiveList,
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
  int numberOffActive = 0, numberOfUnactive = 0;

  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  Future<void> fetchMembers() async {
    List<String> fetchedActiveMembers = await fetchActiveMemberList();
    List<String> fetchedUnactiveMembers = await fetchUnActiveMemberList();

    numberOffActive = fetchedActiveMembers.length;
    numberOfUnactive = fetchedUnactiveMembers.length;

    setState(() {
      activeFriends = fetchedActiveMembers;
      activeFriendsSorted = activeFriends;

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
                                    List<String> updatedMembersList =
                                        await addMemberToList(newMemberName);
                                    setState(() {
                                      activeFriends = updatedMembersList;
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
                              List<String> fetchedActiveMembers =
                                  await fetchActiveMemberList();
                              isActive = true;

                              setState(() {
                                activeFriends = fetchedActiveMembers;
                                isActive = true;
                                onOff = "Off";
                                numberOffActive = fetchedActiveMembers.length;
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
                              List<String> fetchedUnActiveMembers =
                                  await fetchUnActiveMemberList();
                              setState(() {
                                activeFriends = fetchedUnActiveMembers;
                                isActive = false;
                                onOff = "On";
                                numberOfUnactive =
                                    fetchedUnActiveMembers.length;
                              });
                            },
                            child: Text(
                              'Unactive($numberOfUnactive)',
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
                          await changeToUnactive(activeFriends[index]);
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
                                                            await deleteMember(
                                                              activeFriends[
                                                                  index],
                                                            );

                                                            setState(() {
                                                              activeFriends
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
                                                                activeFriends[
                                                                    index],
                                                                updatedMemberName);

                                                            setState(() {
                                                              activeFriends[
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

  Future<String> sendFriendRequest(String friendName) async {
    final user = FirebaseAuth.instance.currentUser!;

    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('Users');

    final snapshot = await userRef.child(friendName).get();

    if (snapshot.exists) {
      await userRef.update({'${friendName}/Friendrequests': user.displayName});
    }
    return friendName;
  }

  Future<List<String>> fetchActiveFriendList() async {
    DatabaseReference userRef = await fetchFriendHelper();
    final snapshot = await userRef.child('Active').get();

    List<String> membersList = await databaseList(snapshot);

    return membersList;
  }

  Future<List<String>> fetchUnActiveFriendList() async {
    DatabaseReference userRef = await fetchFriendHelper();

    final snapshot = await userRef.child('Unactive').get();
    List<String> UnactiveList;

    if (snapshot.exists) {
      List<String> membersList = await databaseList(snapshot);

      UnactiveList = membersList;
    } else {
      UnactiveList = [];
    }

    return UnactiveList;
  }

  Future<DatabaseReference> fetchFriendHelper() async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance
        .reference()
        .child('Users/${user.displayName}/ActiveAndUnactive/Friends');
    return userRef;
  }

  Future<List<String>> addMemberToList(String newMember) async {
    final user = FirebaseAuth.instance.currentUser!;

    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('Users');
    final snapshot = await userRef
        .child('${user.displayName}/ActiveAndUnactive/Members/Active')
        .get();

    await userRef
        .child('${user.displayName}/Members/$newMember')
        .set(newMember);

    List<String> membersList = await databaseList(snapshot);

    membersList.add(newMember);

    await userRef.update(
        {'${user.displayName}/ActiveAndUnactive/Members/Active': membersList});

    return membersList;
  }

  Future<List<String>> fetchActiveMemberList() async {
    DatabaseReference userRef = await fetcMemberHelper();
    final snapshot = await userRef.child('Active').get();

    List<String> membersList = await databaseList(snapshot);

    return membersList;
  }

  Future<List<String>> fetchUnActiveMemberList() async {
    DatabaseReference userRef = await fetcMemberHelper();

    final snapshot = await userRef.child('Unactive').get();
    List<String> UnactiveList;

    if (snapshot.exists) {
      List<String> membersList = await databaseList(snapshot);

      UnactiveList = membersList;
    } else {
      UnactiveList = [];
    }

    return UnactiveList;
  }

  Future<DatabaseReference> fetcMemberHelper() async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance
        .reference()
        .child('Users/${user.displayName}/ActiveAndUnactive/Members');
    return userRef;
  }

  Future<List<String>> updateMemberName(String oldName, String newName) async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('Users');
    final activeSnapshot = await userRef
        .child('${user.displayName}/ActiveAndUnactive/Members/Active')
        .get();

    List<String> activeMembersList = await databaseList(activeSnapshot);

    List<String> updatedList;

    if (activeMembersList.contains(oldName)) {
      int index = activeMembersList.indexOf(oldName);
      activeMembersList[index] = newName;

      await userRef.update({
        '${user.displayName}/ActiveAndUnactive/Members/Active':
            activeMembersList,
        '${user.displayName}/Members/$oldName': null,
        '${user.displayName}/Members/$newName': newName,
      });
      updatedList = activeMembersList;
    } else {
      final unActivesnapshot = await userRef
          .child('${user.displayName}/ActiveAndUnactive/Members/Unactive')
          .get();

      List<String> unActiveMembersList = await databaseList(unActivesnapshot);

      int index = unActiveMembersList.indexOf(oldName);
      unActiveMembersList[index] = newName;

      await userRef.update({
        '${user.displayName}/ActiveAndUnactive/Members/Unactive':
            unActiveMembersList,
        '${user.displayName}/Members/$oldName': null,
        '${user.displayName}/Members/$newName': newName,
      });
      updatedList = unActiveMembersList;
    }

    return updatedList;
  }

  Future<List<String>> deleteMember(String memberName) async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('Users');

    final activeSnapshot = await userRef
        .child('${user.displayName}/ActiveAndUnactive/Members/Active')
        .get();

    List<String> activeMembersList = await databaseList(activeSnapshot);

    List<String> updatedList;

    if (activeMembersList.contains(memberName)) {
      activeMembersList.remove(memberName);
      await userRef.update({
        '${user.displayName}/ActiveAndUnactive/Members/Active':
            activeMembersList,
        '${user.displayName}/Members/$memberName': null,
      });
      updatedList = activeMembersList;
    } else {
      final unActiveSnapshot = await userRef
          .child('${user.displayName}/ActiveAndUnactive/Members/Unactive')
          .get();

      List<String> unActiveMembersList = await databaseList(unActiveSnapshot);

      unActiveMembersList.remove(memberName);

      await userRef.update({
        '${user.displayName}/ActiveAndUnactive/Members/Unactive':
            unActiveMembersList,
        '${user.displayName}/Members/$memberName': null,
      });
      updatedList = unActiveMembersList;
    }
    return updatedList;
  }

  Future<List<String>> changeToUnactive(String change) async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance
        .reference()
        .child('Users/${user.displayName}/ActiveAndUnactive/Members');

    final snapshotActive = await userRef.child('Active').get();

    List<String> newList = [];

    if (snapshotActive.value != null) {
      List<String> membersActiveList = await databaseList(snapshotActive);

      membersActiveList.remove(change);

      List<String> newUnActiveList = [change];

      newList = membersActiveList;

      final snapshotUnactive = await userRef.child('Unactive').get();

      if (snapshotUnactive.exists) {
        List<String> membersUnactiveList = await databaseList(snapshotUnactive);

        membersUnactiveList.add(change);

        await userRef.update({
          'Active': membersActiveList,
          'Unactive': membersUnactiveList,
        });
      } else {
        List<String> newUnactiveList = [change];
        await userRef.update({
          'Active': membersActiveList,
          'Unactive': newUnactiveList,
        });
      }
    }

    return newList;
  }

  Future<List<String>> changeToActive(String change) async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance
        .reference()
        .child('Users/${user.displayName}/ActiveAndUnactive/Members');

    final snapshotUnactive = await userRef.child('Unactive').get();

    List<String> newList = [];

    if (snapshotUnactive.value != null) {
      List<String> membersUnactiveList = await databaseList(snapshotUnactive);

      membersUnactiveList.remove(change);

      List<String> newUnActiveList = [change];

      newList = membersUnactiveList;

      final snapshotActive = await userRef.child('Active').get();

      if (snapshotActive.exists) {
        List<String> membersActiveList = await databaseList(snapshotActive);

        membersActiveList.add(change);

        await userRef.update({
          'Active': membersActiveList,
          'Unactive': membersUnactiveList,
        });
      } else {
        List<String> newUnactiveList = [change];
        await userRef.update({
          'Active': membersUnactiveList,
          'Unactive': newUnactiveList,
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
