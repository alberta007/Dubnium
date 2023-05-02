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

  @override
  Widget build(BuildContext context) {
    // Keep track of which button is active
    return Scaffold(
      backgroundColor: Color(0xFFEAF5E4),
      body: Center(
        child: Container(
          height: 563,
          width: 300,
          color: Color(0xFFEAF5E4),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Members',
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Friends',
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                ),
              ),
              Positioned(
                top: 60,
                right: 3,
                child: Container(
                  width: 290,
                  height: 3,
                  decoration: const BoxDecoration(
                    color: Color(0xFF87A330),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 400,
                  width: 290,
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
                                              await addMemberToList(
                                                  newMemberName);
                                          setState(() {
                                            activemembers = updatedMembersList;
                                          });
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
                          minimumSize: MaterialStateProperty.all(Size(380, 50)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        child: const Text('Add member',
                            style: TextStyle(
                                fontSize: 24,
                                color: Color.fromARGB(255, 255, 255, 255))),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 280,
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
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 290,
                          height: 3,
                          decoration: const BoxDecoration(
                            color: Color(0xFF87A330),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 280,
                          height: 40,
                          color: Color(0xFFEAF5E4),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: TextButton(
                                  onPressed: () async {
                                    List<String> fetchedActiveMembers =
                                        await fetchActiveMemberList();
                                    isActive = true;

                                    setState(() {
                                      activemembers = fetchedActiveMembers;
                                      isActive = true;
                                      onOff = "Off";
                                    });
                                  },
                                  child: Text(
                                    'Active',
                                    style: TextStyle(
                                      fontSize: 25,
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
                                    });
                                  },
                                  child: Text(
                                    'Unactive',
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
                alignment: Alignment.bottomCenter,
                child: Container(
                    width: 280,
                    height: 290,
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
                              minimumSize:
                                  MaterialStateProperty.all(Size(55, 40)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
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
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xFF87A330))),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    String updatedMemberName =
                                        activemembers[index];
                                    String oldName = updatedMemberName;
                                    return AlertDialog(
                                      title: const Text('Edit member'),
                                      content: TextField(
                                        onChanged: (value) {
                                          updatedMemberName = value;
                                        },
                                        decoration: const InputDecoration(
                                          hintText:
                                              'Enter the updated member name',
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
                                                                        MaterialStateProperty.all(
                                                                            Colors.red)),
                                                                child:
                                                                    const Text(
                                                                        'No'),
                                                              ),
                                                              SizedBox(
                                                                width: 100,
                                                              ),
                                                              ElevatedButton(
                                                                onPressed:
                                                                    () async {
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
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          Color(
                                                                              0xFF87A330)),
                                                                ),
                                                                child:
                                                                    const Text(
                                                                        'Yes'),
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
                                                                        MaterialStateProperty.all(
                                                                            Colors.red)),
                                                                child:
                                                                    const Text(
                                                                        'No'),
                                                              ),
                                                              SizedBox(
                                                                width: 100,
                                                              ),
                                                              ElevatedButton(
                                                                onPressed:
                                                                    () async {
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
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          Color(
                                                                              0xFF87A330)),
                                                                ),
                                                                child:
                                                                    const Text(
                                                                        'Yes'),
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
          ),
        ),
      ),
    );
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
