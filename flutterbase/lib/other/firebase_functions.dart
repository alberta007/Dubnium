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

    List<String> list = databaseList(preferencesSnapshot);

    return list;
  }

  List<String> databaseList(DataSnapshot snapshot) {
    List<dynamic> databaseListDynamic = snapshot.value as List<dynamic>;

    List<String> dataBaseList =
        databaseListDynamic.map((member) => member.toString()).toList();

    return dataBaseList;
  }
}
