import 'dart:ffi';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseServices {
  DatabaseReference userRef = FirebaseDatabase.instance.ref("user");
  DatabaseReference officeRef = FirebaseDatabase.instance.ref("office");
  DatabaseReference attendanceRef = FirebaseDatabase.instance.ref("attendance");

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> saveUser(String name, String email) async {
    await userRef
        .child(auth.currentUser!.uid)
        .set({"name": name, "email": email});
  }

  Future<void> createOffice(
      {required String name,
      required double longitude,
      required double latitude,
      required double radius}) async {
    final offices = await officeRef.get();

    if (offices.value != null) {
      // Cast offices.value to Map<dynamic, dynamic>
      final officeData = offices.value as Map<dynamic, dynamic>;

      // Check if an office with the given name already exists
      if (officeData.containsKey(name)) {
        // Office with the same name already exists, handle the error or update the existing entry
        print('An office with the name "$name" already exists.');
        // You can choose to throw an exception or take other actions based on your requirements.
      } else {
        await officeRef.child(name).set({
          "name": name,
          "longitude": longitude,
          "latitude": latitude,
          "radius": radius
        });
        print('Office "$name" created successfully.');
      }
    } else {
      await officeRef.child(name).set({
        "name": name,
        "longitude": longitude,
        "latitude": latitude,
        "radius": radius
      });
    }
  }

  Future<void> deleteOffice(String name) async {
    await officeRef.child(name).remove();
  }

  Future<void> markAttendanceEntry(
    {required String uId,
    // required String userName
    }) async {
    final now = DateTime.now();
    await attendanceRef.child(DateFormat('yMd').format(now)).child(uId).set({
      // "name": userName,
      "entry_time": DateFormat.Hm(now),
      "exit_time": DateFormat.Hm(now),
      "duration": "",
    });
  }

  Future<void> markAttendanceExit(
      { required String uId,
        // required String userName
      }) async {
    final now = DateTime.now();
    await attendanceRef.child(DateFormat('yMd').format(now)).child(uId).set({
      "exit_time": DateFormat.Hm(now),
    });
  }
}
