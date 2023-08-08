import 'package:flutter/material.dart';
import 'package:geofence/services/firebase/firebase_services.dart';
import 'package:geofence/widgets/geoCard.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';


class OfficeList extends StatefulWidget {
  OfficeList({Key? key}) : super(key: key);

  @override
  State<OfficeList> createState() => _OfficeListState();
}

class _OfficeListState extends State<OfficeList> {
  Position? currentPosition;

  TextEditingController officeController = new TextEditingController();

  TextEditingController latitudeController = new TextEditingController();

  TextEditingController longitudeController = new TextEditingController();

  TextEditingController radiusController = new TextEditingController();

  FirebaseServices firebaseServices = FirebaseServices();

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

  void getCurrentLocation() async{

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    "Create Office",
                    textAlign: TextAlign.left,
                  ),
                  content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
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
                  } ,)

,
                  actions: [
                    IconButton(
                        onPressed: () async {
                          // getCurrentLocation();
                          currentPosition = await determinePosition();

                          if(currentPosition != null){

                            setState(() {
                              //print(currentPosition!.latitude.toString());
                              latitudeController =
                                  TextEditingController(text: currentPosition!.latitude.toString());
                              longitudeController =
                                  TextEditingController(text: currentPosition!.longitude.toString());
                            });
                          }
                        }, icon: Icon(Icons.location_history)),
                    IconButton(onPressed: () {
                      Navigator.pop(context);
                    }, icon: Icon(Icons.close)),
                    IconButton(
                        onPressed: () {
                          firebaseServices.createOffice(
                              name: officeController.text,
                              latitude: double.parse(latitudeController.text),
                              longitude: double.parse(longitudeController.text),
                              radius: double.parse(radiusController.text)
                          );
                        },
                        icon: Icon(Icons.check)),
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
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
                    color: Colors.orange[900]),
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
          Text(
            "Select GeoFence",
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 18),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return GeoCard();
                    }),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
