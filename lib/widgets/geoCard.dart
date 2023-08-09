import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GeoCard extends StatelessWidget {
  final String officeName;
  const GeoCard({Key? key, required this.officeName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white,
      shadowColor: Colors.black,
      child: Row(
        children: [
          Icon(
            Icons.location_on_outlined,
            color: Colors.red,
            size: 100,
          ),
          Text(
            officeName,
            style:
                GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
