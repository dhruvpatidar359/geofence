import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geofence/pages/login.dart';
import 'package:geofence/services/authServices/firebase_auth_services.dart';
import 'package:geofence/widgets/widgets.dart';
import 'package:table_calendar/table_calendar.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  DateTime today = DateTime.now();
  FirebaseAuthService _firebaseAuthService =
      FirebaseAuthService(authService: FirebaseAuth.instance);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Attendance'),
          actions: [
            IconButton(
                onPressed: () {
                  _firebaseAuthService.signOut();
                  nextScreenReplace(context, LoginPage());
                },
                icon: Icon(
                  Icons.logout,
                  size: 25,
                ),
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                child: TableCalendar(
                    focusedDay: today,
                    firstDay: DateTime.utc(2010,01,01),
                    lastDay: DateTime.utc(2030,12,31),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
