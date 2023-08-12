import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:geofence/pages/login.dart';
import 'package:geofence/services/authServices/firebase_auth_services.dart';
import 'package:geofence/widgets/attendanceCard.dart';
import 'package:geofence/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
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

  DatabaseReference attendanceRef = FirebaseDatabase.instance.ref("attendance");
  String date_Control =
      DateFormat('yMd').format(DateTime.now()).toString().replaceAll("/", "-");

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    // TODO: implement your code here
    final date = args.value.toString();
    final inprocess = date.split(" ").first.split("-");
    final RegExp regexp = RegExp(r'^0+(?=.)');
    for (int i = 0; i < inprocess.length; i++) {
      inprocess[i] = inprocess[i].replaceAll(regexp, "");
    }

    setState(() {
      date_Control = "${inprocess[1]}-${inprocess[2]}-${inprocess[0]}";
    });
    print(date_Control);
  }

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
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: SfDateRangePicker(
                  onSelectionChanged: _onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.single,
                ),
              ),
              Expanded(
                child: FirebaseAnimatedList(
                  query: attendanceRef
                      .child(date_Control)
                      .child("ku5TV2SU58T3ZSQbDjus23BAVh83"),
                  itemBuilder: (context, snapshot, animation, index) {
                    String inTime =
                        snapshot.child('entry_time').value.toString();
                    String outTime =
                        snapshot.child('exit_time').value.toString();
                    String duration =
                        snapshot.child('duration').value.toString();
                    String location =
                        snapshot.child('office_name').value.toString();

                    return GestureDetector(
                      onTap: () {
                        print(inTime);
                      },
                      child: AttendanceCard(
                        inTime: inTime,
                        outTime: outTime,
                        duration: duration,
                        location: location,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
