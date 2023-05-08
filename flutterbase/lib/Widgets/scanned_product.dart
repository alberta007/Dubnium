import 'package:flutter/material.dart';
import 'package:flutterbase/Widgets/menu_widget.dart';
import 'package:flutterbase/other/dabas_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterbase/Widgets/members_widget.dart';
import 'package:flutterbase/other/firebase_functions.dart';

class ScannedProduct extends StatefulWidget {
  final String gtin;

  ScannedProduct(this.gtin);
  @override
  _ScannedProduct createState() => _ScannedProduct(gtin);
}

class _ScannedProduct extends State<ScannedProduct>
    with TickerProviderStateMixin {
  final String gtin;
  late Future<Product?> product;
  late Future<List<String>> preferences;
  late AnimationController animationController;
  late Animation<double> animation;

  _ScannedProduct(this.gtin);

  bool isAllergensGood(Product? product, List<String> preferences) {
    bool isGood = true;
    List<String> allergens = product!.allergens.map((e) => e.allergen).toList();

    allergens.forEach((element) {
      if (preferences.contains(element)) {
        isGood = false;
      }
    });

    return isGood;
  }

  Widget goodOrBadProduct(Product? product, List<String> preferences) {
    animationController.forward();
    if (isAllergensGood(product, preferences)) {
      return Column(
        children: [
          Expanded(
              flex: 8,
              child: ScaleTransition(
                  scale: animation,
                  child: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 99, 221, 33),
                    radius: double.infinity,
                    child: Icon(
                      Icons.check,
                      size: 150,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ))),
          Expanded(
              flex: 2,
              child: Center(
                child: Text('This is suitable for your preferences!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 99, 221, 33),
                        fontWeight: FontWeight.bold)),
              )),
        ],
      );
    } else {
      return Column(
        children: [
          Expanded(
              flex: 8,
              child: ScaleTransition(
                  scale: animation,
                  child: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 221, 34, 34),
                    radius: double.infinity,
                    child: Icon(
                      Icons.close,
                      size: 150,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ))),
          Expanded(
              flex: 2,
              child: Center(
                child: Text('This is NOT suitable for your preferences!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 221, 34, 34),
                        fontWeight: FontWeight.bold)),
              )),
        ],
      );
    }
  }

  @override
  void initState() {
    super.initState();
    product = GetProduct().fetchProduct(gtin);
    preferences = getPreferences();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    animation = CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<List<String>> getPreferences() async {
    List<String> preferences;
    final user = FirebaseAuth.instance.currentUser!;

    DatabaseReference userRef = FirebaseDatabase.instance
        .reference()
        .child('Users/${user.displayName}'); // Get reference for current user

    DataSnapshot activeMembersSnapshot = await userRef
        .child('Members/Active')
        .get(); // Snapshot of active members
    DataSnapshot activeFriendsSnapshot = await userRef
        .child('Friends/Active')
        .get(); // Snapshot of active friends
    List<String> activeMembersPreferences = getMembersPreferences(
        activeMembersSnapshot); // Get preferences from snapshot
    List<String> activeFriendsPreferences = await getFriendsPreferences(
        activeFriendsSnapshot); // Get friends from snapshot

    List<String> combineLists = new List.from(activeMembersPreferences);
    combineLists.addAll(activeFriendsPreferences);

    preferences = combineLists.toSet().toList(); // Remove duplicates
    return preferences;
  }

  Future<List<String>> getFriendsPreferences(DataSnapshot snapshot) async {
    List<String> result = [];

    if (snapshot.exists) {
      Map<dynamic, dynamic> databaseMapDynamic = snapshot.value as Map;
      List<String> friends = [];

      await Future.forEach(databaseMapDynamic.entries, (entry) async {
        // For each friend
        DatabaseReference friendRef = FirebaseDatabase.instance
            .reference()
            .child('Users/${entry.key}/Members'); //Get reference

        DataSnapshot activeList =
            await friendRef.child('Active/You').get(); //Get friend if active
        DataSnapshot inactiveList = await friendRef
            .child('Inactive/You')
            .get(); //Get friend if inactive

        if (activeList.exists) {
          // If active
          Map<dynamic, dynamic> friendMap = activeList.value as Map;

          friendMap.forEach((key, value) {
            // Get preferences
            List<dynamic> preferences = value as List<dynamic>;

            friends.addAll(preferences.cast<String>());
          });
        } else if (inactiveList.exists) {
          // If inactive
          Map<dynamic, dynamic> friendMap = inactiveList.value as Map;

          friendMap.forEach((key, value) {
            // Get preferences
            List<dynamic> preferences = value as List<dynamic>;

            friends.addAll(preferences.cast<String>());
          });
        }
      });

      result = friends.toSet().toList(); // Remove duplicates
    }

    return result;
  }

  List<String> getMembersPreferences(DataSnapshot snapshot) {
    List<String> result = [];
    if (snapshot.exists) {
      Map<dynamic, dynamic> databaseMapDynamic = snapshot.value as Map;
      List<String> membersPreferences = [];

      if (databaseMapDynamic != null) {
        databaseMapDynamic.forEach((key, value) {
          Map<dynamic, dynamic> valueMap = value as Map;
          valueMap.forEach((key, value) {
            List<dynamic> preferences = value as List<dynamic>;

            membersPreferences.addAll(preferences.cast<String>());
          });
        });
      }
      result = membersPreferences.toSet().toList(); // Remove dublicates
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAF5E4),
      body: Column(
        children: [
          const Expanded(
            flex: 12,
            child: menuTopBar(),
          ),
          Expanded(
            flex: 76,
            child: Container(
              child: FutureBuilder(
                  future: Future.wait([product, preferences]),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case ConnectionState.done:
                      default:
                        final Product? product = snapshot.data?[0] as Product?;
                        final List<String> preferences =
                            snapshot.data?[1] as List<String>;

                        if (product != null) {
                          return Column(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Container(
                                    width: 300,
                                    padding: const EdgeInsets.all(20),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 3.0,
                                          color: Color(0xFF87A330),
                                        ),
                                      ),
                                    ),
                                    child:
                                        goodOrBadProduct(product, preferences)),
                              ),
                              Expanded(
                                flex: 4,
                                child: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Center(
                                              child: Text(
                                                'Info about: ${product.name}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )),
                                        Expanded(
                                          flex: 9,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 5,
                                                child: CircleAvatar(
                                                  radius: double.infinity,
                                                  foregroundImage: product
                                                              .image ==
                                                          ''
                                                      ? Image.asset(
                                                              'assets/images/picture-unavailable.png')
                                                          .image
                                                      : Image.network(
                                                              product.image)
                                                          .image,
                                                  backgroundColor:
                                                      Color(0xFF87A330),
                                                ),
                                              ),
                                              Spacer(),
                                              Expanded(
                                                  flex: 6,
                                                  child: Container(
                                                      width: 250,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Made by: ',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(
                                                                'Allergens: ',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                product.allergens
                                                                        .isEmpty
                                                                    ? '${product.brand}'
                                                                    : '${product.brand}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                              Text(
                                                                product.allergens
                                                                        .isEmpty
                                                                    ? 'none'
                                                                    : '${product.allergens}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ))),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                              )
                            ],
                          );
                        } else {
                          return AlertDialog(
                            title: const Text('Unknown Barcode'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                Text(
                                    "Unforntunelty we couldn't find information about that product"),
                              ],
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Close'),
                              ),
                            ],
                          );
                        }
                    }
                  }),
            ),
          ),
          const Expanded(flex: 12, child: menuBottomBar())
        ],
      ),
    );
  }
}
