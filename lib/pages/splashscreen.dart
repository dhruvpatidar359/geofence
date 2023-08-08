import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:geofence/pages/officelist.dart';
import 'package:geofence/pages/login.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key, required this.isLoggedIn}) : super(key: key);

  final isLoggedIn;

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset('assets/images/logo.png'),
      title: Text(
        "GeoFlix",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      showLoader: true,
      loadingText: Text("Loading..."),
      navigator: widget.isLoggedIn ? OfficeList() : LoginPage(),
      durationInSeconds: 3,
    );
  }
}
