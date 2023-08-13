import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceName extends StatefulWidget {
  const AttendanceName({
    Key? key,
    required this.userName,
  }) : super(key: key);

  final String userName;

  @override
  State<AttendanceName> createState() => _AttendanceNameState();
}

class _AttendanceNameState extends State<AttendanceName> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
      color: Colors.orange.shade50,
      shadowColor: Colors.orange,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            widget.userName,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
