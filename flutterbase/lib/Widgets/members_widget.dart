import 'package:flutter/material.dart';

class MembersList extends StatefulWidget {
  @override
  _MembersListState createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
  List<String> members = []; // initialize an empty list of members

  @override
  Widget build(BuildContext context) {
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
                          // show a dialog to add a new member
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
                                  decoration: InputDecoration(
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
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 120,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            members.add(newMemberName);
                                          });
                                          Navigator.pop(context);
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
                        child: const TextField(
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
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    width: 280,
                    height: 325,
                    color: const Color(0xFFEAF5E4),
                    child: ListView.builder(
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            members[index],
                            style: TextStyle(color: Colors.black, fontSize: 32),
                          ),
                          trailing: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFF87A330))),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  String updatedMemberName = members[index];
                                  return AlertDialog(
                                    title: Text('Edit member'),
                                    content: TextField(
                                      onChanged: (value) {
                                        updatedMemberName = value;
                                      },
                                      decoration: const InputDecoration(
                                        hintText:
                                            'Enter the updated member name',
                                      ),
                                      controller: TextEditingController(
                                          text: members[index]),
                                    ),
                                    actions: [
                                      Row(
                                        children: [
                                          SizedBox(width: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                members.removeAt(index);
                                              });
                                              Navigator.pop(context);
                                            },
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.red)),
                                            child: const Text('Delete'),
                                          ),
                                          const SizedBox(width: 110),
                                          ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                members[index] =
                                                    updatedMemberName;
                                              });
                                              Navigator.pop(context);
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
}