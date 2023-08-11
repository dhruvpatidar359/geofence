import 'dart:async';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geofence/pages/google_map.dart';
import 'package:geofence/services/authServices/auth_service.dart';
import 'package:geofence/services/authServices/firebase_auth_services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../services/firebase/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GeoFence extends StatefulWidget {
  final String name;
  final double latitudeCenter;
  final double longitudeCenter;
  final double radiusCenter;
  const GeoFence(
      {Key? key,
      required this.name,
      required this.latitudeCenter,
      required this.longitudeCenter,
      required this.radiusCenter})
      : super(key: key);

  @override
  State<GeoFence> createState() => _GeoFenceState();
}

class _GeoFenceState extends State<GeoFence> {
  int count = 0;
  StreamSubscription<Position>? _positionStream;
  FirebaseServices firebaseServices = FirebaseServices();
  DatabaseReference userRef = FirebaseDatabase.instance.ref("user");

  LocationSettings _locationSet = LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 1,
    timeLimit: Duration(seconds: 10000),
  );

  void startGeofenceService() {
    //parsing the values to double if in any case they are coming in int etc
    double latitude = widget.latitudeCenter;
    double longitude = widget.longitudeCenter;
    double radiusInMeter = widget.radiusCenter;
    int? eventPeriodInSeconds = 1;

    if (_positionStream == null) {
      _positionStream = Geolocator.getPositionStream(
        locationSettings: _locationSet,
      ).listen((Position position) {
        double distanceInMeters = Geolocator.distanceBetween(
            latitude, longitude, position.latitude, position.longitude);
        _checkGeofence(distanceInMeters, radiusInMeter);
      });
    }
    _positionStream!
        .pause(Future.delayed(Duration(seconds: eventPeriodInSeconds!)));
  }

  void _checkGeofence(double distanceInMeters, double radiusInMeter) async {
    if (distanceInMeters <= radiusInMeter) {
      print("Enter");
      if (count == 0) {
        firebaseServices.markAttendanceEntry(
            uId: FirebaseAuth.instance.currentUser!.uid);

        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            message: "You have Entered the Location",
          ),
        );

        count = 1;
      }
    } else {
      print("EXIT");
      if (count == 1) {
        firebaseServices.markAttendanceExit(
            uId: FirebaseAuth.instance.currentUser!.uid);
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message: "You are outside the Location",
          ),
        );
        count = 0;
      }
    }
  }

  double distanceBetween(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos as double Function(num?);
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startGeofenceService();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GoogleMapPage(
          latitudeCenter: widget.latitudeCenter,
          longitudeCenter: widget.longitudeCenter,
          radiusCenter: widget.radiusCenter),
    );
  }
}
