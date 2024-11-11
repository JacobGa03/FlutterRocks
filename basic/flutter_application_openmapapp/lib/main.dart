import 'package:flutter/material.dart';
import 'package:flutter_application_openmapapp/components/location_suggest.dart';
import 'package:flutter_application_openmapapp/pages/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // Store the LatLng of the locations
  List<Map<String, double>>? locationsMap = [{}, {}];

  @override
  void initState() {
    // Initialize the locationsMap with empty LatLng
    locationsMap = [
      {'lat': 0, 'lng': 0},
      {'lat': 0, 'lng': 0}
    ];
  }

  // Take in the LatLng for start and end points and open up Google Maps with that route selected
  void _launchMaps(String startLocation, String finalLocation) async {
    final Uri googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&origin=$startLocation&destination=$finalLocation&travelmode=driving');

    // Check if the URL can be launched
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("DriveU"),
        ),
        body: Center(
            child: Column(
          children: [
            LocationSuggest(locationsMap: locationsMap!, index: 0),
            LocationSuggest(locationsMap: locationsMap!, index: 1),
            ElevatedButton(
                onPressed: () {
                  String startLocation =
                      '${locationsMap![0]['lat']},${locationsMap![0]['lng']}';
                  String endLocation =
                      '${locationsMap![1]['lat']},${locationsMap![1]['lng']}';

                  // Open Google Maps with the route
                  _launchMaps(startLocation, endLocation);
                },
                child: const Text("Open Route Assistance")),
          ],
        )),
      ),
    );
  }
}
