import 'package:flutter_application_6/env.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsApi {
  // Get the route from Google Maps API from one location to another
  // optionally you can include waypoints (intermediate locations)
  Future<List<LatLng>> getPolylinePoints(
      LatLng origin, LatLng destination) async {
    List<LatLng> polylineCoor = [];
    PolylinePoints polylinePoints = PolylinePoints();
    // Call the Google Maps API to get the route from one location to another
    PolylineResult res = await polylinePoints.getRouteBetweenCoordinates(
        // The API key for Google Maps
        googleApiKey: GOOGLE_MAPS,
        request: PolylineRequest(
            origin: PointLatLng(origin.latitude, origin.longitude),
            destination:
                PointLatLng(destination.latitude, destination.longitude),
            mode: TravelMode.driving));

    // Some route exists
    if (res.points.isNotEmpty) {
      for (var point in res.points) {
        polylineCoor.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      print(res.errorMessage);
    }
    return polylineCoor;
  }
}
