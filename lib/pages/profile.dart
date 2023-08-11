import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geofence/pages/login.dart';
import 'package:geofence/services/authServices/firebase_auth_services.dart';
import 'package:geofence/widgets/widgets.dart';

class Profile extends StatelessWidget {
  Profile({Key? key}) : super(key: key);
  FirebaseAuthService _firebaseAuthService =
      FirebaseAuthService(authService: FirebaseAuth.instance);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    _firebaseAuthService.signOut();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => LoginPage()),
                    // );
                    nextScreenReplace(context, LoginPage());
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.sizeOf(context).width,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey[900]),
                    child: Center(
                      child: Text(
                        "Logout",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 50,
                    width: MediaQuery.sizeOf(context).width,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey[900]),
                    child: Center(
                      child: Text(
                        "View Attendance",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
