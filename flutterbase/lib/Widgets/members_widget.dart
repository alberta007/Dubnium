import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MembersList extends StatefulWidget {
  @override
  _MembersListState createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
  List<String> activemembers = [], inactiveMembers = [];
  List<String> activefriends = [], inactiveFriends = [];
  List<String> activemembersSorted = [];
  final user = FirebaseAuth.instance.currentUser!;
  bool isActive = true;
  String onOff = "Off";
  int numberOfActive = 0;
  int numberOfInactive = 0;
  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  Future<void> fetchMembers() async {
    List<String> fetchedActiveMembers = await fetchActiveMemberList();
    List<String> fetchedInactiveMembers = await fetchUnActiveMemberList();
    List<String> fetchedActiveFriends = await fetchActiveFriendList();
    List<String> fetchedInactiveFriends = await fetchUnActiveFriendsList();

    setState(() {
      activemembers = fetchedActiveMembers;
      inactiveMembers = fetchedInactiveMembers;
      activefriends = fetchedActiveFriends;
      inactiveFriends = fetchedInactiveFriends;
      activemembersSorted = activemembers;

      numberOfActive = fetchedActiveMembers.length;
      numberOfInactive = fetchedInactiveMembers.length;

      fetchedActiveMembers.sort((a, b) => b.compareTo(a));
    });
  }

  @override
  Widget build(BuildContext context) {
    // Keep track of which button is active
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: const Color(0xFFEAF5E4),
          body: Column(
            children: [
              const TabBar(labelColor: Colors.black, tabs: [
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
                                  padding: const EdgeInsets.all(25),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          String newMemberName = '';
                                          return AlertDialog(
                                            title:
                                                const Text('Add a new member'),
                                            content: TextField(
                                              onChanged: (value) {
                                                newMemberName = value;
                                              },
                                              decoration: const InputDecoration(
                                                hintText:
                                                    'Enter the new member name',
                                              ),
                                            ),
                                            actions: [
                                              Row(
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      print(
                                                          "Längd: ${activemembers} ");

                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 120,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      await addMemberToList(
                                                          newMemberName);
                                                      List<String>
                                                          updatedMembersList =
                                                          await fetchActiveMemberList();
                                                      setState(() {
                                                        activemembers =
                                                            updatedMembersList;
                                                      });
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(const Color(
                                                                  0xFF87A330)),
                                                    ),
                                                    child: const Text('Add'),
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
                                          MaterialStateProperty.all(
                                              const Color(0xFF87A330)),
                                      minimumSize: MaterialStateProperty.all(
                                          const Size(380, 60)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.add_rounded,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    label: const Text('Add member',
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255))),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 0, left: 25, right: 25, bottom: 25),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: 'Search Members',
                                        prefixIcon:
                                            const Icon(Icons.search, size: 24),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              const BorderSide(width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        )),
                                    onChanged: (value) {
                                      setState(() {
                                        activemembers = activemembersSorted
                                            .where((string) => string
                                                .toLowerCase()
                                                .contains(value.toLowerCase()))
                                            .toList();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TabBar(labelColor: Colors.black, tabs: [
                            Tab(
                                child: Text("Active (${activemembers.length})",
                                    style: const TextStyle(fontSize: 18))),
                            Tab(
                                child: Text(
                                    "Inactive (${inactiveMembers.length})",
                                    style: const TextStyle(fontSize: 18))),
                          ]),
                          Expanded(
                            child: TabBarView(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(top: 0),
                                  itemCount: activemembers.length,
                                  //alignment: Alignment.topCenter,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final memberName = activemembers[index];
                                    return Container(
                                      margin: const EdgeInsets.only(
                                          top: 25,
                                          right: 25,
                                          left: 25,
                                          bottom: 0),
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: TextButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      String updatedMemberName =
                                                          activemembers[index];
                                                      String oldName =
                                                          updatedMemberName;
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Edit member'),
                                                        content: TextField(
                                                          onChanged: (value) {
                                                            updatedMemberName =
                                                                value;
                                                          },
                                                          decoration:
                                                              const InputDecoration(
                                                            hintText:
                                                                'Enter the updated member name',
                                                          ),
                                                          controller:
                                                              TextEditingController(
                                                                  text: activemembers[
                                                                      index]),
                                                        ),
                                                        actions: [
                                                          Row(
                                                            children: [
                                                              const SizedBox(
                                                                  width: 10),
                                                              ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              const Text('Are you sure?'),
                                                                          actions: [
                                                                            Row(
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 20,
                                                                                ),
                                                                                ElevatedButton(
                                                                                  onPressed: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                                                                                  child: const Text('No'),
                                                                                ),
                                                                                const SizedBox(
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
                                                                                    backgroundColor: MaterialStateProperty.all(const Color(0xFF87A330)),
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
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all(
                                                                            Colors.red)),
                                                                child: const Text(
                                                                    'Delete'),
                                                              ),
                                                              const SizedBox(
                                                                  width: 110),
                                                              ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              const Text('Are you sure?'),
                                                                          actions: [
                                                                            Row(
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 20,
                                                                                ),
                                                                                ElevatedButton(
                                                                                  onPressed: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                                                                                  child: const Text('No'),
                                                                                ),
                                                                                const SizedBox(
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
                                                                                    backgroundColor: MaterialStateProperty.all(const Color(0xFF87A330)),
                                                                                  ),
                                                                                  child: const Text('Yes'),
                                                                                ),
                                                                              ],
                                                                            )
                                                                          ],
                                                                        );
                                                                      });
                                                                },
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          const Color(
                                                                              0xFF87A330)),
                                                                ),
                                                                child:
                                                                    const Text(
                                                                        'Save'),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Text(
                                                  memberName,
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black),
                                                )),
                                          ),
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  await changeToInactive(
                                                      activemembers[index]);
                                                  List<String>
                                                      updatedActiveMembers =
                                                      await fetchActiveMemberList();
                                                  List<String>
                                                      updatedInactiveMembers =
                                                      await fetchUnActiveMemberList();
                                                  setState(() {
                                                    activemembers =
                                                        updatedActiveMembers;
                                                    inactiveMembers =
                                                        updatedInactiveMembers;
                                                  });
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Color.fromARGB(255,
                                                              168, 32, 32)),
                                                  minimumSize:
                                                      MaterialStateProperty.all(
                                                          const Size(100, 40)),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                  ),
                                                ),
                                                child: const Text(
                                                  "Deactivate",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              )),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(top: 0),
                                  itemCount: inactiveMembers.length,
                                  //alignment: Alignment.topCenter,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final memberName = inactiveMembers[index];
                                    return Container(
                                      margin: const EdgeInsets.only(
                                          top: 25,
                                          right: 25,
                                          left: 25,
                                          bottom: 0),
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: TextButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      String updatedMemberName =
                                                          inactiveMembers[
                                                              index];
                                                      String oldName =
                                                          updatedMemberName;
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Edit member'),
                                                        content: TextField(
                                                          onChanged: (value) {
                                                            updatedMemberName =
                                                                value;
                                                          },
                                                          decoration:
                                                              const InputDecoration(
                                                            hintText:
                                                                'Enter the updated member name',
                                                          ),
                                                          controller:
                                                              TextEditingController(
                                                                  text: inactiveMembers[
                                                                      index]),
                                                        ),
                                                        actions: [
                                                          Row(
                                                            children: [
                                                              const SizedBox(
                                                                  width: 10),
                                                              ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              const Text('Are you sure?'),
                                                                          actions: [
                                                                            Row(
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 20,
                                                                                ),
                                                                                ElevatedButton(
                                                                                  onPressed: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                                                                                  child: const Text('No'),
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 100,
                                                                                ),
                                                                                ElevatedButton(
                                                                                  onPressed: () async {
                                                                                    await deleteMember(
                                                                                      inactiveMembers[index],
                                                                                    );

                                                                                    setState(() {
                                                                                      inactiveMembers.removeAt(index);
                                                                                    });
                                                                                    Navigator.pop(context);

                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  style: ButtonStyle(
                                                                                    backgroundColor: MaterialStateProperty.all(const Color(0xFF87A330)),
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
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all(
                                                                            Colors.red)),
                                                                child: const Text(
                                                                    'Delete'),
                                                              ),
                                                              const SizedBox(
                                                                  width: 110),
                                                              ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              const Text('Are you sure?'),
                                                                          actions: [
                                                                            Row(
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 20,
                                                                                ),
                                                                                ElevatedButton(
                                                                                  onPressed: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                                                                                  child: const Text('No'),
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 100,
                                                                                ),
                                                                                ElevatedButton(
                                                                                  onPressed: () async {
                                                                                    await updateMemberName(inactiveMembers[index], updatedMemberName);

                                                                                    setState(() {
                                                                                      inactiveMembers[index] = updatedMemberName;
                                                                                    });
                                                                                    Navigator.pop(context);
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  style: ButtonStyle(
                                                                                    backgroundColor: MaterialStateProperty.all(const Color(0xFF87A330)),
                                                                                  ),
                                                                                  child: const Text('Yes'),
                                                                                ),
                                                                              ],
                                                                            )
                                                                          ],
                                                                        );
                                                                      });
                                                                },
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          const Color(
                                                                              0xFF87A330)),
                                                                ),
                                                                child:
                                                                    const Text(
                                                                        'Save'),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Text(
                                                  memberName,
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black),
                                                )),
                                          ),
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  await changeToActive(
                                                      inactiveMembers[index]);
                                                  List<String>
                                                      updatedActiveMembers =
                                                      await fetchActiveMemberList();
                                                  List<String>
                                                      updatedInactiveMembers =
                                                      await fetchUnActiveMemberList();
                                                  setState(() {
                                                    activemembers =
                                                        updatedActiveMembers;
                                                    inactiveMembers =
                                                        updatedInactiveMembers;
                                                  });
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          const Color(
                                                              0xFF87A330)),
                                                  minimumSize:
                                                      MaterialStateProperty.all(
                                                          const Size(100, 40)),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                  ),
                                                ),
                                                child: const Text(
                                                  "Activate",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              )),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Friends
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
                                  padding: const EdgeInsets.all(25),
                                  child: ElevatedButton.icon(
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
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 120,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      String test =
                                                          await sendFriendRequest(
                                                              newMemberName);

                                                      if (test == "No") {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'Username doesnt exist',
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            backgroundColor:
                                                                Colors.red,
                                                            textColor: Color(
                                                                0xFF87A330),
                                                            fontSize: 20.0);
                                                      }
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Color(
                                                                  0xFF87A330)),
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
                                          MaterialStateProperty.all(
                                              const Color(0xFF87A330)),
                                      minimumSize: MaterialStateProperty.all(
                                          const Size(380, 60)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.mail,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    label: const Text('Add Friend',
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255))),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 0, left: 25, right: 25, bottom: 25),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: 'Search Friends',
                                        prefixIcon:
                                            const Icon(Icons.search, size: 24),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              const BorderSide(width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        )),
                                    onChanged: (value) {
                                      setState(() {
                                        activemembers = activemembersSorted
                                            .where((string) => string
                                                .toLowerCase()
                                                .contains(value.toLowerCase()))
                                            .toList();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TabBar(labelColor: Colors.black, tabs: [
                            Tab(
                                child: Text("Active (${activefriends.length})",
                                    style: const TextStyle(fontSize: 18))),
                            Tab(
                                child: Text(
                                    "Inactive (${inactiveFriends.length})",
                                    style: const TextStyle(fontSize: 18))),
                          ]),
                          Expanded(
                            child: TabBarView(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(top: 0),
                                  itemCount: activefriends.length,
                                  //alignment: Alignment.topCenter,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final memberName = activefriends[index];
                                    return Container(
                                      margin: const EdgeInsets.only(
                                          top: 25,
                                          right: 25,
                                          left: 25,
                                          bottom: 0),
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(activefriends[index]),
                                          ),
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  await changeFriendToInactive(
                                                      activefriends[index]);
                                                  List<String>
                                                      updatedActiveFriends =
                                                      await fetchActiveFriendList();
                                                  List<String>
                                                      updatedInactiveFriends =
                                                      await fetchUnActiveFriendsList();
                                                  setState(() {
                                                    activefriends =
                                                        updatedActiveFriends;
                                                    inactiveMembers =
                                                        updatedInactiveFriends;
                                                  });
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Color.fromARGB(255,
                                                              168, 32, 32)),
                                                  minimumSize:
                                                      MaterialStateProperty.all(
                                                          const Size(100, 40)),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                  ),
                                                ),
                                                child: const Text(
                                                  "Deactivate",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              )),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(top: 0),
                                  itemCount: activefriends.length,
                                  //alignment: Alignment.topCenter,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      margin: const EdgeInsets.only(
                                          top: 25,
                                          right: 25,
                                          left: 25,
                                          bottom: 0),
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(inactiveFriends[index]),
                                          ),
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  await changeFriendToActive(
                                                      activefriends[index]);
                                                  List<String>
                                                      updatedActiveFriends =
                                                      await fetchActiveFriendList();
                                                  List<String>
                                                      updatedInactiveFriends =
                                                      await fetchUnActiveFriendsList();
                                                  setState(() {
                                                    activefriends =
                                                        updatedActiveFriends;
                                                    inactiveMembers =
                                                        updatedInactiveFriends;
                                                  });
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Color.fromARGB(255,
                                                              168, 32, 32)),
                                                  minimumSize:
                                                      MaterialStateProperty.all(
                                                          const Size(100, 40)),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                  ),
                                                ),
                                                child: const Text(
                                                  "Activate",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              )),
                                        ],
                                      ),
                                    );
                                  },
                                ),
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

  // FUNCTIONS FOR MEMBERS

  Future<String> addMemberToList(String newMember) async {
    final user = FirebaseAuth.instance.currentUser!;

    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('Users');

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

  //Functions for friends

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

  Future<List<String>> changeFriendToInactive(String change) async {
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

  Future<List<String>> changeFriendToActive(String change) async {
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
