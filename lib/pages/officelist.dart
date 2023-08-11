import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:geofence/pages/geo_fence.dart';
import 'package:geofence/pages/profile.dart';
import 'package:geofence/services/firebase/firebase_services.dart';
import 'package:geofence/widgets/geoCard.dart';
import 'package:geofence/widgets/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class OfficeList extends StatefulWidget {
  OfficeList({Key? key}) : super(key: key);

  @override
  State<OfficeList> createState() => _OfficeListState();
}

class _OfficeListState extends State<OfficeList> {
  Position? currentPosition;
  final officeReference = FirebaseDatabase.instance.ref('office');

  TextEditingController officeController = TextEditingController();

  TextEditingController latitudeController = TextEditingController();

  TextEditingController longitudeController = TextEditingController();

  TextEditingController radiusController = TextEditingController();

  FirebaseServices firebaseServices = FirebaseServices();

  int _selectedIndex = 0;

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    currentPosition = await determinePosition();
    if (currentPosition != null) {
      setState(() {
        latitudeController.text = currentPosition!.latitude.toString();
        longitudeController.text = currentPosition!.longitude.toString();
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                label: 'Home',
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.search, color: Colors.black),
                label: 'Search',
                backgroundColor: Colors.white),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          iconSize: 40,
          onTap: _onItemTapped,
          elevation: 5),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange.shade100,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.orange.shade50,
                  title: Text(
                    "Create Office",
                    textAlign: TextAlign.center,
                  ),
                  content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: officeController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  hintText: "office name..."),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextField(
                              controller: latitudeController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  hintText: "latitude..."),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextField(
                              controller: longitudeController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  hintText: "longitude..."),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextField(
                              controller: radiusController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  hintText: "Radius..."),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: [
                    IconButton(
                        onPressed: () async {
                          getCurrentLocation();
                        },
                        icon: Icon(Icons.location_history)),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close)),
                    IconButton(
                        onPressed: () {
                          firebaseServices.createOffice(
                              name: officeController.text,
                              latitude: double.parse(latitudeController.text),
                              longitude: double.parse(longitudeController.text),
                              radius: double.parse(radiusController.text));
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.check)),
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
      body: _selectedIndex == 1
          ? Profile()
          : Column(
              children: [
                Text(
                  "Select GeoFence",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: 18),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 200,
                      child: FirebaseAnimatedList(
                        query: officeReference,
                        itemBuilder: (context, snapshot, animation, index) {
                          String name = snapshot.child('name').value.toString();
                          double latitude = double.parse(
                              snapshot.child('latitude').value.toString());
                          double longitude = double.parse(
                              snapshot.child('longitude').value.toString());
                          double radius = double.parse(
                              snapshot.child('radius').value.toString());
                          return GestureDetector(
                            child: GeoCard(officeName: name),
                            onTap: () {
                              nextScreen(
                                  context,
                                  GeoFence(
                                      name: name,
                                      latitudeCenter: latitude,
                                      longitudeCenter: longitude,
                                      radiusCenter: radius));
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
    ));
  }
}
