import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseFunctions {
  Future<void> addPreference(String memberName, String preference) async {
    final user = FirebaseAuth.instance.currentUser!;

    DatabaseReference userRef = FirebaseDatabase.instance.reference().child(
        'Users/${user.displayName}/Members'); // Get reference for current user

    DataSnapshot activeMembersSnapshot = await userRef
        .child('Active/$memberName')
        .get(); // Snapshot of active member

    DataSnapshot InactiveMembersSnapshot = await userRef
        .child('Inactive/$memberName')
        .get(); // Snapshot of Inactive member

    if (activeMembersSnapshot.exists) {
      // Check if member is in active
      DataSnapshot membersCurrentPreferences = await userRef
          .child('Active/$memberName/Preferences')
          .get(); // Get preferences

      if (membersCurrentPreferences.exists) {
        // Check if previous preferences exist
        List<String> currentPreferences =
            databaseList(membersCurrentPreferences);

        currentPreferences.add(preference);

        await userRef.update({
          'Active/$memberName/Preferences': currentPreferences,
        });
      } else {
        await userRef.update({
          'Active/$memberName/Preferences': [preference],
        });
      }
    } else {
      // Else member is in Inactive
      DataSnapshot membersCurrentPreferences = await userRef
          .child('Inactive/$memberName/Preferences')
          .get(); // Get preferences

      if (membersCurrentPreferences.exists) {
        // Check if previous preferences exist
        List<String> currentPreferences =
            databaseList(membersCurrentPreferences);

        currentPreferences.add(preference);

        await userRef.update({
          'Inactive/$memberName/Preferences': currentPreferences,
        });
      } else {
        await userRef.update({
          'Inactive/$memberName/Preferences': [preference],
        });
      }
    }
  }

  Future<void> removePreference(String memberName, String preference) async {
    final user = FirebaseAuth.instance.currentUser!;

    DatabaseReference userRef = FirebaseDatabase.instance.reference().child(
        'Users/${user.displayName}/Members'); // Get reference for current user

    DataSnapshot activeMembersSnapshot = await userRef
        .child('Active/$memberName')
        .get(); // Snapshot of active member

    DataSnapshot InactiveMembersSnapshot = await userRef
        .child('Inactive/$memberName')
        .get(); // Snapshot of Inactive member

    if (activeMembersSnapshot.exists) {
      // Check if member is in active
      DataSnapshot membersCurrentPreferences = await userRef
          .child('Active/$memberName/Preferences')
          .get(); // Get preferences

      if (membersCurrentPreferences.exists) {
        // Check if previous preferences exist
        List<String> currentPreferences =
            databaseList(membersCurrentPreferences);

        currentPreferences.remove(preference);

        await userRef.update({
          'Active/$memberName/Preferences': currentPreferences,
        });
      }
    } else {
      // Else member is in Inactive
      DataSnapshot membersCurrentPreferences = await userRef
          .child('Inactive/$memberName/Preferences')
          .get(); // Get preferences

      if (membersCurrentPreferences.exists) {
        // Check if previous preferences exist
        List<String> currentPreferences =
            databaseList(membersCurrentPreferences);

        currentPreferences.remove(preference);

        await userRef.update({
          'Inactive/$memberName/Preferences': currentPreferences,
        });
      }
    }
  }

  Future<List<String>> allPreferences() async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('Preferences');

    DataSnapshot preferencesSnapshot = await userRef.get();
    debugPrint('DATA1: ${preferencesSnapshot.value}');

    List<String> list = databaseList(preferencesSnapshot);

    return list;
  }

  Future<List<String>> allMembers() async {
    List<String> activeMembers = await fetchActiveMemberList();
    List<String> inactiveMembers = await fetchUnActiveMemberList();

    activeMembers.addAll(inactiveMembers);

    return activeMembers;
  }

  Future<List<String>> fetchMembersPreferences(String username) async {
    final user = FirebaseAuth.instance.currentUser!;
    List<String> memberPreferences = [];

    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('Users/${user.displayName}/Members');
    debugPrint('user: $user, username: $username');

    DataSnapshot activeMember = await userRef.child('Active/$username').get();
    DataSnapshot inactiveMember =
        await userRef.child('Inactive/$username').get();

    if (activeMember.exists) {
      Map<dynamic, dynamic> memberMap = activeMember.value as Map;
      debugPrint('User: $memberMap');
      memberMap.forEach((key, value) {
        List<dynamic> preferences = value as List;

        memberPreferences.addAll(preferences.cast<String>());
      });
    } else {
      Map<dynamic, dynamic> memberMap = inactiveMember.value as Map;
      debugPrint('User: $memberMap');
      memberMap.forEach((key, value) {
        List<dynamic> preferences = value as List;

        memberPreferences.addAll(preferences.cast<String>());
      });
    }

    return memberPreferences;
  }

  Future<List<String>> allFriends() async {
    List<String> activeFriends = await fetchActiveFriendList();
    List<String> inactiveFriends = await fetchUnActiveFriendsList();

    activeFriends.addAll(inactiveFriends);

    return activeFriends;
  }

  Future<List<String>> fetchFriendsPreferences(String username) async {
    List<String> friendPreferences = [];

    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('Users/$username/Members');

    DataSnapshot activeFriend = await userRef.child('Active/You').get();
    DataSnapshot inactiveFriend = await userRef.child('Inactive/You').get();

    if (activeFriend.exists) {
      Map<dynamic, dynamic> memberMap = activeFriend.value as Map;
      debugPrint('User: $memberMap');
      memberMap.forEach((key, value) {
        List<dynamic> preferences = value as List;

        friendPreferences.addAll(preferences.cast<String>());
      });
    } else {
      Map<dynamic, dynamic> memberMap = inactiveFriend.value as Map;
      debugPrint('User: $memberMap');
      memberMap.forEach((key, value) {
        List<dynamic> preferences = value as List;

        friendPreferences.addAll(preferences.cast<String>());
      });
    }

    return friendPreferences;
  }

  List<String> databaseList(DataSnapshot snapshot) {
    List<dynamic> databaseListDynamic = snapshot.value as List<dynamic>;

    List<String> dataBaseList =
        databaseListDynamic.map((member) => member.toString()).toList();

    return dataBaseList;
  }

  // Fetches a list of active members from the database
  Future<List<String>> fetchActiveMemberList() async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance
        .reference()
        .child('Users/${user.displayName}/Members');

    final activeSnapshot = await userRef
        .child('Active')
        .get(); // get snapshot of all active members

    List<String> activeMembers = [];

    if (activeSnapshot.exists) {
      // check if there are any active members in the database
      Map<dynamic, dynamic> membersMap =
          activeSnapshot.value as Map; // map the active members

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
    DatabaseReference userRef = FirebaseDatabase.instance
        .reference()
        .child('Users/${user.displayName}/Members');

    final inActiveSnapshot = await userRef
        .child('Inactive')
        .get(); // get snapshot of all inactive members

    List<String> activeMembers = [];

    if (inActiveSnapshot.exists) {
      // check if there are any inactive members in the database

      Map<dynamic, dynamic> membersMap =
          inActiveSnapshot.value as Map; // map the inactive members
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

  // fetch a list of active friends
  Future<List<String>> fetchActiveFriendList() async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef = FirebaseDatabase.instance
        .reference()
        .child('Users/${user.displayName}/Friends');

    final activeSnapshot =
        await userRef.child('Active').get(); // get snapshot of active friends

    List<String> activeMembers = [];

    if (activeSnapshot.exists) {
      // if active friends snapshot exists
      Map<dynamic, dynamic> membersMap =
          activeSnapshot.value as Map; // map all active friends

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
    DatabaseReference userRef = FirebaseDatabase.instance
        .reference()
        .child('Users/${user.displayName}/Friends');

    final activeSnapshot = await userRef
        .child('Inactive')
        .get(); // get snapshot of inactive friends

    List<String> unactiveMembers = [];

    if (activeSnapshot.exists) {
      // if inactive friends snapshot exists

      Map<dynamic, dynamic> membersMap =
          activeSnapshot.value as Map; // map all inactive friends
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
}
