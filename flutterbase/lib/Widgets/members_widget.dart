import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MembersList extends StatefulWidget {
  @override
  _MembersListState createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
  List<String> activemembers = [];
  List<String> activemembersSorted = [];
  final user = FirebaseAuth.instance.currentUser!;
  bool isActive = true;
  String onOff = "Off";
  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  Future<void> fetchMembers() async {
    List<String> fetchedActiveMembers = await fetchActiveMemberList();

    setState(() {
      activemembers = fetchedActiveMembers;
      activemembersSorted = activemembers;

      fetchedActiveMembers.sort((a, b) => b.compareTo(a));
    });
  }

  List<String> activeMembers = ["Abbe", "Julle", "Simon"];

  List<String> unactiveMembers = ["Martin", "Tilde"];

  List<String> activeFriends = ["Arne", "Big Mac"];

  List<String> unactiveFriends = ["Calle"];

  @override
  Widget build(BuildContext context) {
    // Keep track of which button is active
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Color(0xFFEAF5E4),
          body: Column(
            children: [
              TabBar(labelColor: Colors.black, tabs: [
                Tab(child: Text("Members ()", style: TextStyle(fontSize: 20))),
                Tab(child: Text("Friends ()", style: TextStyle(fontSize: 20))),
              ]),
              Expanded(
                child: TabBarView(
                  children: [
                    DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(25),
                                  child: ElevatedButton.icon(
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
                                                      List<String> updatedMembersList = await addMemberToList(newMemberName);
                                                      setState(() {
                                                        activemembers = updatedMembersList;
                                                      });
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor: MaterialStateProperty.all(Color(0xFF87A330)),
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
                                      backgroundColor: MaterialStateProperty.all(const Color(0xFF87A330)),
                                      minimumSize: MaterialStateProperty.all(Size(380, 60)),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                    icon: Icon(
                                      Icons.add_rounded,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    label: Text('Add member', style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 255, 255, 255))),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 0, left: 25, right: 25, bottom: 25),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: 'Search Members',
                                        prefixIcon: Icon(Icons.search, size: 24),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                          borderRadius: BorderRadius.circular(10.0),
                                        )),
                                    onChanged: (value) {
                                      setState(() {
                                        activemembers = activemembersSorted.where((string) => string.toLowerCase().contains(value.toLowerCase())).toList();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TabBar(labelColor: Colors.black, tabs: [
                            Tab(child: Text("Active (${activeMembers.length})", style: TextStyle(fontSize: 20))),
                            Tab(child: Text("Unactive (${unactiveMembers.length})", style: TextStyle(fontSize: 20))),
                          ]),
                          Expanded(
                            child: TabBarView(
                              children: [
                                Text(activeMembers.first),
                                Text(unactiveMembers.first),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(25),
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(const Color(0xFF87A330)),
                                      minimumSize: MaterialStateProperty.all(Size(380, 60)),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                    icon: Icon(
                                      Icons.mail,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    label: Text('Add Friend', style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 255, 255, 255))),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 0, left: 25, right: 25, bottom: 25),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: 'Search Friends',
                                        prefixIcon: Icon(Icons.search, size: 24),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                          borderRadius: BorderRadius.circular(10.0),
                                        )),
                                    onChanged: (value) {
                                      setState(() {
                                        activemembers = activemembersSorted.where((string) => string.toLowerCase().contains(value.toLowerCase())).toList();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TabBar(labelColor: Colors.black, tabs: [
                            Tab(child: Text("Active (${activeFriends.length})", style: TextStyle(fontSize: 20))),
                            Tab(child: Text("Unactive (${unactiveFriends.length})", style: TextStyle(fontSize: 20))),
                          ]),
                          Expanded(
                            child: TabBarView(
                              children: [
                                Text(activeFriends.first),
                                Text(unactiveFriends.first),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Future<List<String>> addMemberToList(String newMember) async {
    final user = FirebaseAuth.instance.currentUser!;

    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('Users');
    final snapshot = await userRef.child('${user.displayName}/ActiveAndUnactive/Members/Active').get();

    await userRef.child('${user.displayName}/Members/$newMember').set(newMember);

    List<String> membersList = await databaseList(snapshot);

    membersList.add(newMember);

    await userRef.update({'${user.displayName}/ActiveAndUnactive/Members/Active': membersList});

    return membersList;
  }

  Future<List<String>> fetchActiveMemberList() async {
    DatabaseReference userRef = await fetcHelper();
    final snapshot = await userRef.child('Active').get();

    List<String> membersList = await databaseList(snapshot);

    return membersList;
  }

  Future<List<String>> fetchUnActiveMemberList() async {
    DatabaseReference userRef = await fetcHelper();

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

  Future<DatabaseReference> fetcHelper() async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('Users/${user.displayName}/ActiveAndUnactive/Members');
    return userRef;
  }

  Future<List<String>> updateMemberName(String oldName, String newName) async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('Users');
    final activeSnapshot = await userRef.child('${user.displayName}/ActiveAndUnactive/Members/Active').get();

    List<String> activeMembersList = await databaseList(activeSnapshot);

    List<String> updatedList;

    if (activeMembersList.contains(oldName)) {
      int index = activeMembersList.indexOf(oldName);
      activeMembersList[index] = newName;

      await userRef.update({
        '${user.displayName}/ActiveAndUnactive/Members/Active': activeMembersList,
        '${user.displayName}/Members/$oldName': null,
        '${user.displayName}/Members/$newName': newName,
      });
      updatedList = activeMembersList;
    } else {
      final unActivesnapshot = await userRef.child('${user.displayName}/ActiveAndUnactive/Members/Unactive').get();

      List<String> unActiveMembersList = await databaseList(unActivesnapshot);

      int index = unActiveMembersList.indexOf(oldName);
      unActiveMembersList[index] = newName;

      await userRef.update({
        '${user.displayName}/ActiveAndUnactive/Members/Unactive': unActiveMembersList,
        '${user.displayName}/Members/$oldName': null,
        '${user.displayName}/Members/$newName': newName,
      });
      updatedList = unActiveMembersList;
    }

    return updatedList;
  }

  Future<List<String>> deleteMember(String memberName) async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('Users');

    final activeSnapshot = await userRef.child('${user.displayName}/ActiveAndUnactive/Members/Active').get();

    List<String> activeMembersList = await databaseList(activeSnapshot);

    List<String> updatedList;

    if (activeMembersList.contains(memberName)) {
      activeMembersList.remove(memberName);
      await userRef.update({
        '${user.displayName}/ActiveAndUnactive/Members/Active': activeMembersList,
        '${user.displayName}/Members/$memberName': null,
      });
      updatedList = activeMembersList;
    } else {
      final unActiveSnapshot = await userRef.child('${user.displayName}/ActiveAndUnactive/Members/Unactive').get();

      List<String> unActiveMembersList = await databaseList(unActiveSnapshot);

      unActiveMembersList.remove(memberName);

      await userRef.update({
        '${user.displayName}/ActiveAndUnactive/Members/Unactive': unActiveMembersList,
        '${user.displayName}/Members/$memberName': null,
      });
      updatedList = unActiveMembersList;
    }
    return updatedList;
  }

  Future<List<String>> changeToUnactive(String change) async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('Users/${user.displayName}/ActiveAndUnactive/Members');

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
    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('Users/${user.displayName}/ActiveAndUnactive/Members');

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

    List<String> dataBaseList = databaseListDynamic.map((member) => member.toString()).toList();

    return dataBaseList;
  }
}
/* 
                          Align(
                              alignment: Alignment.center,
                              child: ListView.builder(
                                itemCount: activeMembers.length,
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
                                        backgroundColor: MaterialStateProperty.all((Colors.amber)),
                                        minimumSize: MaterialStateProperty.all(Size(55, 40)),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xFF87A330))),
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
                                                  controller: TextEditingController(text: activemembers[index]),
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
                                                                  title: const Text('Are you sure?'),
                                                                  actions: [
                                                                    Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          width: 20,
                                                                        ),
                                                                        ElevatedButton(
                                                                          onPressed: () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                                                                          child: const Text('No'),
                                                                        ),
                                                                        SizedBox(
                                                                          width: 100,
                                                                        ),
                                                                        ElevatedButton(
                                                                          onPressed: () async {
                                                                            await deleteMember(
                                                                              activemembers[index],
                                                                            );

                                                                            setState(() {
                                                                              activemembers.removeAt(index);
                                                                            });
                                                                            Navigator.pop(context);

                                                                            Navigator.pop(context);
                                                                          },
                                                                          style: ButtonStyle(
                                                                            backgroundColor: MaterialStateProperty.all(Color(0xFF87A330)),
                                                                          ),
                                                                          child: const Text('Yes'),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                );
                                                              });
                                                        },
                                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                                                        child: const Text('Delete'),
                                                      ),
                                                      const SizedBox(width: 110),
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          showDialog(
                                                              context: context,
                                                              builder: (context) {
                                                                return AlertDialog(
                                                                  title: const Text('Are you sure?'),
                                                                  actions: [
                                                                    Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          width: 20,
                                                                        ),
                                                                        ElevatedButton(
                                                                          onPressed: () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                                                                          child: const Text('No'),
                                                                        ),
                                                                        SizedBox(
                                                                          width: 100,
                                                                        ),
                                                                        ElevatedButton(
                                                                          onPressed: () async {
                                                                            await updateMemberName(activemembers[index], updatedMemberName);

                                                                            setState(() {
                                                                              activemembers[index] = updatedMemberName;
                                                                            });
                                                                            Navigator.pop(context);
                                                                            Navigator.pop(context);
                                                                          },
                                                                          style: ButtonStyle(
                                                                            backgroundColor: MaterialStateProperty.all(Color(0xFF87A330)),
                                                                          ),
                                                                          child: const Text('Yes'),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                );
                                                              });
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all(Color(0xFF87A330)),
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
                              )),*/