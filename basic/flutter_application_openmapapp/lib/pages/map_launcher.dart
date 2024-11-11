import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MapLauncher extends StatelessWidget {
  String? startLocation;
  String? finalLocation;

  MapLauncher(
      {super.key, required this.startLocation, required this.finalLocation});

  // Take in the LatLng for start and end points and open up Google Maps with that route selected
  Future<void> _launchMaps() async {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('DriveU'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _launchMaps,
              child: const Text('Open Google Maps'),
            ),
          ],
        ),
      ),
    );
  }
}
