import 'package:flutter/material.dart';
import 'package:geofence/services/firebase/firebase_services.dart';
import 'package:geofence/widgets/geoCard.dart';
import 'package:google_fonts/google_fonts.dart';

class OfficeList extends StatelessWidget {
  OfficeList({Key? key}) : super(key: key);

  String officeName = "";
  late double latitude;
  late double longitude;
  late double radius;

  FirebaseServices firebaseServices = FirebaseServices();

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
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          onChanged: (value) {
                            officeName = value;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              hintText: "office name..."),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextField(
                          onChanged: (value) {
                            latitude = double.parse(value);
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              hintText: "latitude..."),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextField(
                          onChanged: (value) {
                            longitude = double.parse(value);
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              hintText: "longitude..."),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextField(
                          onChanged: (value) {
                            radius = double.parse(value);
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              hintText: "Radius..."),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {}, icon: Icon(Icons.location_history)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.close)),
                    IconButton(
                        onPressed: () {
                          print(latitude);
                          print("hehelkjrahg");
                          firebaseServices.createOffice(
                              name: officeName,
                              latitude: latitude,
                              longitude: longitude,
                              radius: radius);
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
