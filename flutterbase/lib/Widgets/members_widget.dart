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
  int totMembers = 0;
  int totFriends = 0;
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
      totMembers = fetchedActiveMembers.length + fetchedInactiveMembers.length;
      totFriends = fetchedInactiveFriends.length + fetchedActiveFriends.length;
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
              TabBar(labelColor: Colors.black, tabs: [
                Tab(child: Text("Members ($totMembers)", style: TextStyle(fontSize: 20))),
                Tab(child: Text("Friends ($totFriends)", style: TextStyle(fontSize: 20))),
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
                                            title: const Text('Add a new member'),
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
                                                //mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                                    width: 100,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      await addMemberToList(newMemberName);
                                                      List<String> updatedMembersList = await fetchActiveMemberList();

                                                      setState(() {
                                                        totMembers = totMembers + 1;
                                                        activemembers = updatedMembersList;
                                                      });
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor: MaterialStateProperty.all(const Color(0xFF87A330)),
                                                    ),
                                                    child: const Text(
                                                      'Add',
                                                    ),
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
                                      minimumSize: MaterialStateProperty.all(const Size(380, 60)),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.add_rounded,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    label: const Text('Add member', style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 255, 255, 255))),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 0, left: 25, right: 25, bottom: 25),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: 'Search Members',
                                        prefixIcon: const Icon(Icons.search, size: 24),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(width: 2.0),
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
                            Tab(child: Text("Active (${activemembers.length})", style: const TextStyle(fontSize: 18))),
                            Tab(child: Text("Inactive (${inactiveMembers.length})", style: const TextStyle(fontSize: 18))),
                          ]),
                          Expanded(
                            child: TabBarView(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(top: 0),
                                  itemCount: activemembers.length,
                                  //alignment: Alignment.topCenter,
                                  itemBuilder: (BuildContext context, int index) {
                                    final memberName = activemembers[index];
                                    return Container(
                                      margin: const EdgeInsets.only(top: 25, right: 25, left: 25, bottom: 0),
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black, width: 2),
                                        borderRadius: BorderRadius.circular(10.0),
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
                                                                                      totMembers = totMembers - 1;
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
                                                                style: ButtonStyle(
                                                                  backgroundColor: MaterialStateProperty.all(const Color(0xFF87A330)),
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
                                                child: Text(
                                                  memberName,
                                                  style: const TextStyle(fontSize: 20, color: Colors.black),
                                                )),
                                          ),
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  await changeToInactive(activemembers[index]);
                                                  List<String> updatedActiveMembers = await fetchActiveMemberList();
                                                  List<String> updatedInactiveMembers = await fetchUnActiveMemberList();
                                                  setState(() {
                                                    activemembers = updatedActiveMembers;
                                                    inactiveMembers = updatedInactiveMembers;
                                                  });
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 168, 32, 32)),
                                                  minimumSize: MaterialStateProperty.all(const Size(100, 40)),
                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                  ),
                                                ),
                                                child: const Text(
                                                  "Deactivate",
                                                  style: TextStyle(color: Colors.black),
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
                                  itemBuilder: (BuildContext context, int index) {
                                    final memberName = inactiveMembers[index];
                                    return Container(
                                      margin: const EdgeInsets.only(top: 25, right: 25, left: 25, bottom: 0),
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black, width: 2),
                                        borderRadius: BorderRadius.circular(10.0),
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
                                                      String updatedMemberName = inactiveMembers[index];
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
                                                          controller: TextEditingController(text: inactiveMembers[index]),
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
                                                                style: ButtonStyle(
                                                                  backgroundColor: MaterialStateProperty.all(const Color(0xFF87A330)),
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
                                                child: Text(
                                                  memberName,
                                                  style: const TextStyle(fontSize: 20, color: Colors.black),
                                                )),
                                          ),
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  await changeToActive(inactiveMembers[index]);
                                                  List<String> updatedActiveMembers = await fetchActiveMemberList();
                                                  List<String> updatedInactiveMembers = await fetchUnActiveMemberList();
                                                  setState(() {
                                                    activemembers = updatedActiveMembers;
                                                    inactiveMembers = updatedInactiveMembers;
                                                  });
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty.all(const Color(0xFF87A330)),
                                                  minimumSize: MaterialStateProperty.all(const Size(100, 40)),
                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                  ),
                                                ),
                                                child: const Text(
                                                  "Activate",
                                                  style: TextStyle(color: Colors.black),
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
                                                      style: TextStyle(color: Colors.red),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 100,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      String test = await sendFriendRequest(newMemberName);

                                                      if (test == "No") {
                                                        Fluttertoast.showToast(msg: 'Username doesnt exist', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Color(0xFF87A330), fontSize: 20.0);
                                                      }
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
                                      minimumSize: MaterialStateProperty.all(const Size(380, 60)),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.mail,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    label: const Text('Add Friend', style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 255, 255, 255))),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 0, left: 25, right: 25, bottom: 25),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: 'Search Friends',
                                        prefixIcon: const Icon(Icons.search, size: 24),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(width: 2.0),
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
                            Tab(child: Text("Active (${activefriends.length})", style: const TextStyle(fontSize: 18))),
                            Tab(child: Text("Inactive (${inactiveFriends.length})", style: const TextStyle(fontSize: 18))),
                          ]),
                          Expanded(
                            child: TabBarView(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(top: 0),
                                  itemCount: activefriends.length,
                                  //alignment: Alignment.topCenter,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      margin: const EdgeInsets.only(top: 25, right: 25, left: 25, bottom: 0),
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(activefriends[index], style: const TextStyle(fontSize: 20, color: Colors.black)),
                                          ),
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  await changeFriendToInactive(activefriends[index]);
                                                  List<String> updatedActiveFriends = await fetchActiveFriendList();
                                                  List<String> updatedInactiveFriends = await fetchUnActiveFriendsList();
                                                  setState(() {
                                                    activefriends = updatedActiveFriends;
                                                    inactiveFriends = updatedInactiveFriends;
                                                  });
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 168, 32, 32)),
                                                  minimumSize: MaterialStateProperty.all(const Size(100, 40)),
                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                  ),
                                                ),
                                                child: const Text(
                                                  "Deactivate",
                                                  style: TextStyle(color: Colors.black),
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
                                  itemCount: inactiveFriends.length,
                                  //alignment: Alignment.topCenter,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      margin: const EdgeInsets.only(top: 25, right: 25, left: 25, bottom: 0),
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(inactiveFriends[index], style: const TextStyle(fontSize: 20, color: Colors.black)),
                                          ),
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  await changeFriendToActive(inactiveFriends[index]);
                                                  List<String> updatedActiveFriends = await fetchActiveFriendList();
                                                  List<String> updatedInactiveFriends = await fetchUnActiveFriendsList();
                                                  setState(() {
                                                    activefriends = updatedActiveFriends;
                                                    inactiveFriends = updatedInactiveFriends;
                                                  });
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty.all(Color(0xFF87A330)),
                                                  minimumSize: MaterialStateProperty.all(const Size(100, 40)),
                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                  ),
                                                ),
                                                child: const Text(
                                                  "Activate",
                                                  style: TextStyle(color: Colors.black),
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

// Add members to the database
  Future<String> addMemberToList(String newMember) async {
    final user = FirebaseAuth.instance.currentUser!; // get the current user

    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('Users'); // get database reference

    await userRef.child('${user.displayName}/Members/Active/$newMember').set(newMember); // create a new user under active members using the string newMember

    return newMember;
  }

  // Fetches a list of active members from the database
  Future<List<String>> fetchActiveMemberList() async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('Users/${user.displayName}/Members');

    final activeSnapshot = await userRef.child('Active').get(); // get snapshot of all active members

    List<String> activeMembers = [];

    if (activeSnapshot.exists) {
      // check if there are any active members in the database
      Map<dynamic, dynamic> membersMap = activeSnapshot.value as Map; // map the active members

      if (membersMap != null) {
        membersMap.forEach((key, value) {
          activeMembers.add(key); // create a list from the map
        });
      }
    } else {
      // if there are no active members, we return an empty list
      activeMembers = [];
    }

    return activeMembers;
  }

  // Fetches a list of inactive members from the database
  Future<List<String>> fetchUnActiveMemberList() async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('Users/${user.displayName}/Members');

    final inActiveSnapshot = await userRef.child('Inactive').get(); // get snapshot of all inactive members

    List<String> activeMembers = [];

    if (inActiveSnapshot.exists) {
      // check if there are any inactive members in the database

      Map<dynamic, dynamic> membersMap = inActiveSnapshot.value as Map; // map the inactive members
      if (membersMap != null) {
        membersMap.forEach((key, value) {
          activeMembers.add(key); // create a list from the map
        });
      } else {
        // if there are no inactive members, we return an empty list
        activeMembers = [];
      }
    } else {
      // if there are no inactive members, we return an empty list

      activeMembers = [];
    }

    return activeMembers;
  }

//updates a members name in the database
  Future<List<String>> updateMemberName(String oldName, String newName) async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('Users');

    final preferenceActiveSnapshot = await userRef.child('${user.displayName}/Members/Active/$oldName/Preferences').get(); // get snapshot of active member preferences

    final preferenceInactiveSnapshot = await userRef.child('${user.displayName}/Members/Inactive/$oldName/Preferences').get(); // get snapshot of inactive member preferences

    List<String> updatedList = [];

    if (preferenceActiveSnapshot.exists) {
      //check if active member preferences exists
      List<String> preferenceList = await databaseList(preferenceActiveSnapshot); // create a list of the active member preferences

      await userRef.update({
        '${user.displayName}/Members/Active/$oldName': null, // set the old name to null
        '${user.displayName}/Members/Active/$newName/Preferences': preferenceList, // set the new name with preferences
      });
    } else if (preferenceInactiveSnapshot.exists) {
      //check if inactive member preferences exists
      List<String> preferenceList = await databaseList(preferenceInactiveSnapshot); // create a list of the inactive member preferences

      await userRef.update({
        '${user.displayName}/Members/Inactive/$oldName': null, // set the old name to null
        '${user.displayName}/Members/Inactive/$newName/Preferences': preferenceList, // set the new name with preferences
      });
    } else {
      // if the members doesn't have any preferences
      final ActiveSnapshot = await userRef // snapshot to check if active
          .child('${user.displayName}/Members/Active/$oldName')
          .get();

      final InactiveSnapshot = await userRef // snapshot to check if inactive
          .child('${user.displayName}/Members/Inactive/$oldName')
          .get();

      if (ActiveSnapshot.exists) {
        // if active
        await userRef.update({
          '${user.displayName}/Members/Active/$oldName': null, // set the old name to null
          '${user.displayName}/Members/Active/$newName': newName, // set the new name
        });
      } else if (InactiveSnapshot.exists) {
        // if inactive
        await userRef.update({
          '${user.displayName}/Members/Inactive/$oldName': null, // set the old name to null
          '${user.displayName}/Members/Inactive/$newName': newName, // set the new name
        });
      }
    }

    return updatedList;
  }

// deletes a member from the database
  Future<List<String>> deleteMember(String memberName) async {
    final user = FirebaseAuth.instance.currentUser!;

    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('Users');

    List<String> updatedList = [];

    final ActiveSnapshot = await userRef.child('${user.displayName}/Members/Active/$memberName').get(); // snapshot of active members

    final InactiveSnapshot = await userRef.child('${user.displayName}/Members/Inactive/$memberName').get(); // snapshot of inactive members

    if (ActiveSnapshot.exists) {
      // if active
      await userRef.update({
        '${user.displayName}/Members/Active/$memberName': null, // set the name to null
      });
    } else if (InactiveSnapshot.exists) {
      // if inactive
      await userRef.update({
        '${user.displayName}/Members/Inactive/$memberName': null, // set the name to null
      });
    }

    return updatedList;
  }

// changes the member from active to inactive
  Future<List<String>> changeToInactive(String change) async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('Users/${user.displayName}/Members');

    final snapshotActive = await userRef.child('Active/$change').get(); // get snapshot of member

    List<String> newList = [];

    if (snapshotActive.exists) {
      // check if member exists
      final snapshotActivePreferences = await userRef.child('Active/$change/Preferences').get(); // get snapshot of the preferences of the member

      if (snapshotActivePreferences.exists) {
        // if the member has preferences
        List<String> membersInactiveList = await databaseList(snapshotActivePreferences); // create list of preferences

        await userRef.update({
          'Active/$change': null, // set the value to null in the members active position
          'Inactive/$change/Preferences': membersInactiveList, // create a new value in inactive with the list of preferences
        });
      } else {
        await userRef.update({
          'Active/$change': null, // set the value to null in the members active position
          'Inactive/$change': change, // create a new value in inactive
        });
      }
    }
    return newList;
  }
// changes the member from active to active

  Future<List<String>> changeToActive(String change) async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('Users/${user.displayName}/Members');

    final snapshotInactive = await userRef.child('Inactive/$change').get(); // get snapshot of member

    List<String> newList = [];

    if (snapshotInactive.exists) {
      // check if member exists

      final snapshotActivePreferences = await userRef.child('Inactive/$change/Preferences').get(); // get snapshot of the preferences of the member

      if (snapshotActivePreferences.exists) {
        // if the member has preferences
        List<String> membersInactiveList = await databaseList(snapshotActivePreferences); // create list of preferences

        await userRef.update({
          'Inactive/$change': null, // set the value to null in the members inactive position
          'Active/$change/Preferences': membersInactiveList, // create a new value in active with the list of preferences
        });
      } else {
        await userRef.update({
          'Inactive/$change': null, // set the value to null in the members inactive position
          'Active/$change': change, // create a new value in active
        });
      }
    }
    return newList;
  }

  //Functions for friends

//sends a friendrequest to friend
  Future<String> sendFriendRequest(String friendName) async {
    final user = FirebaseAuth.instance.currentUser!;

    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('Users');

    final snapshot = await userRef.child(friendName).get(); // get a snapshot of the friends username position in the database

    List<String> requestList = [];

    if (snapshot.exists) {
      // check if username exists
      final friendRequestsExist = await userRef.child('${friendName}/Friendrequests').get(); // get snapshot of the friendrequests

      if (friendRequestsExist.exists) {
        // check if the friendrequests exists
        List<dynamic> friendRequestListDynamic = friendRequestsExist.value as List<dynamic>; //fetch a list of the friendrequests

        List<String> friendRequestList = friendRequestListDynamic.map((member) => member.toString()).toList();

        friendRequestList.add('${user.displayName}'); // add the current users username to the list of friendrequests

        await userRef.update({
          '$friendName/Friendrequests': friendRequestList, // update the friendrequests in the database
        });
        requestList = friendRequestList;
      } else {
        // if it doesn't exist any previous friend requests
        requestList = ['${user.displayName}']; // create a list of the user who's trying to add
        await userRef.update({
          '$friendName/Friendrequests': requestList, // add that list the friend
        });
      }
    } else {
      friendName = "No";
    }
    return friendName;
  }

//Fetch all the friendrequests
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

// accepts friend requests
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
    await userRef.child('${user.displayName}/Friends/Active/$friendName').set(friendName);
    await userRef.child('$friendName/Friends/Active/${user.displayName}').set(user.displayName);
  }

// fetch a list of active friends
  Future<List<String>> fetchActiveFriendList() async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('Users/${user.displayName}/Friends');

    final activeSnapshot = await userRef.child('Active').get(); // get snapshot of active friends

    List<String> activeMembers = [];

    if (activeSnapshot.exists) {
      // if active friends snapshot exists
      Map<dynamic, dynamic> membersMap = activeSnapshot.value as Map; // map all active friends

      if (membersMap != null) {
        membersMap.forEach((key, value) {
          activeMembers.add(key); // add active friends to a list
        });
      }
    } else {
      // if active friends snapshot doesn't exist
      activeMembers = []; // empty list
    }

    print("People: $activeMembers");
    return activeMembers;
  }
// fetch a list of inactive friends

  Future<List<String>> fetchUnActiveFriendsList() async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('Users/${user.displayName}/Friends');

    final activeSnapshot = await userRef.child('Inactive').get(); // get snapshot of inactive friends

    List<String> unactiveMembers = [];

    if (activeSnapshot.exists) {
      // if inactive friends snapshot exists

      Map<dynamic, dynamic> membersMap = activeSnapshot.value as Map; // map all inactive friends
      if (membersMap != null) {
        membersMap.forEach((key, value) {
          unactiveMembers.add(key); // add inactive friends to a list
        });
      } else {
        unactiveMembers = [];
      }
    } else {
      // if inactive friends snapshot doesn't exist

      unactiveMembers = []; // empty list
    }

    print("People: $unactiveMembers");
    return unactiveMembers;
  }

// changes friend from active to inactive
  Future<List<String>> changeFriendToInactive(String change) async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('Users/${user.displayName}/Friends');

    final snapshotActive = await userRef.child('Active/$change').get(); // get snapshot of active friend

    List<String> newList = [];

    if (snapshotActive.exists) {
      // check if snapshot exists
      await userRef.update({
        'Active/$change': null, // set active to null
        'Inactive/$change': change, // update to inactive
      });
    }
    return newList;
  }
// changes friend from inactive to active

  Future<List<String>> changeFriendToActive(String change) async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('Users/${user.displayName}/Friends');

    final snapshotActive = await userRef.child('Inactive/$change').get(); // get snapshot of active friend

    List<String> newList = [];

    if (snapshotActive.exists) {
      // check if snapshot exists

      await userRef.update({
        'Inactive/$change': null, // set inactive to null
        'Active/$change': change, // update to active
      });
    }
    return newList;
  }

// takes a snapshot and creates a list of that snapshot(if it can)
  Future<List<String>> databaseList(DataSnapshot snapshot) async {
    List<dynamic> databaseListDynamic = snapshot.value as List<dynamic>;

    List<String> dataBaseList = databaseListDynamic.map((member) => member.toString()).toList();

    return dataBaseList;
  }
}
