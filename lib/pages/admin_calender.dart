import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:geofence/pages/login.dart';
import 'package:geofence/services/authServices/firebase_auth_services.dart';
import 'package:geofence/widgets/attendanceCard.dart';
import 'package:geofence/widgets/present_names.dart';
import 'package:geofence/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


class AdminCalender extends StatefulWidget {
  const AdminCalender({Key? key}) : super(key: key);

  @override
  State<AdminCalender> createState() => _AdminCalenderState();
}

class _AdminCalenderState extends State<AdminCalender> {

  String date_Control = DateFormat('yMd').format(DateTime.now()).toString().replaceAll("/", "-");
  FirebaseAuthService _firebaseAuthService = FirebaseAuthService(authService: FirebaseAuth.instance);
  DatabaseReference attendanceRef = FirebaseDatabase.instance.ref("attendance");

  bool isEmpty = true;
  late Query _query ;
  Key _key = Key('New Key');

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
      _query = attendanceRef.child(date_Control);
      _key = Key(date_Control);
    });
    noClass();
  }

  noClass() async{
    final snapshot = await attendanceRef.child(date_Control).get();
    if(snapshot.exists){
      setState(() {
        isEmpty = false;
      });
    }
    else{
      setState(() {
        isEmpty = true;
      });
    }
  }

  getQuery() {
    _query = attendanceRef.child(date_Control);
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
              getAttendanceList(),
            ],
          ),
        ),
      ),
    );
  }
  getAttendanceList() {
    return isEmpty ? Expanded(
        child: Card(
          elevation: 5,
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
          color: Colors.orange.shade50,
          shadowColor: Colors.orange,
          child: Center(
            child: Text(
              'No Class',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        )
    )
        : Expanded(
      child: FirebaseAnimatedList(
        query: _query,
        key: _key,
        itemBuilder: (context, snapshot, animation, index) {
          String userId = snapshot.value.toString();
          Object? data = snapshot.value;
          String userName = snapshot.child('$index').child('name').value.toString();
          String userOffice = snapshot.child('$index').child('office_name').value.toString();
          print(userId);
          return AttendanceName(userName: userName , officeName: userOffice);
        },
      ),
    );
  }
}
