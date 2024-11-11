import 'dart:async';
import 'package:flutter_application_6/env.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<LatLng> mapPoints = [];
  final Location _locationController = Location();
  // Represent the current position of the user
  LatLng? _currPos;

  final Completer<GoogleMapController> _mapCon = Completer();
  // Polylines to draw the route from source to destination
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    // When the application first loads, draw the route from source to destination
    getLocationUpdates().then((_) =>
        getPolylinePoints().then((coor) => generatePolyLineFromPoints(coor)));
  }

  @override
  Widget build(BuildContext context) {
    return _currPos == null
        ? const Scaffold(body: Center(child: Text("Loading")))
        : Scaffold(
            appBar: AppBar(
              title: const Text("DriveU"),
            ),
            body: Column(
              children: [
                GoogleMap(
                    onMapCreated: ((controller) =>
                        _mapCon.complete(controller)),
                    markers: {
                      // Markers represent
                      Marker(
                          onTap: () => print("Clicking $_currPos"),
                          markerId: const MarkerId("_currentLocation"),
                          icon: BitmapDescriptor.defaultMarker,
                          position: _currPos!),
                    },
                    polylines: Set<Polyline>.of(polylines.values),
                    initialCameraPosition:
                        CameraPosition(target: _currPos!, zoom: 10)),
              ],
            ),
          );
  }

  // Get the location of the user
  Future<void> getLocationUpdates() async {
    // Are we allowed to obtain user location
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (serviceEnabled) {
      // If we can, ask for permission to take location data
      serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await _locationController.hasPermission();
    // Ask for permission to gain location of the user
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    // Listen for location changes
    _locationController.onLocationChanged.listen((LocationData curLoc) {
      // Redraw the map as long as the users location exists
      if (curLoc.latitude != null && curLoc.longitude != null) {
        setState(() {
          _currPos = LatLng(curLoc.latitude!, curLoc.longitude!);
          // Move the camera to the current position of the user
          // TODO: when the user is just looking for trips , this should be disabled
          _cameraToPosition(_currPos!);
        });
      }
    });
  }

  // Move the camera to a specific position (to some position represented as LatLng)
  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController con = await _mapCon.future;
    CameraPosition newCameraPos = CameraPosition(target: pos, zoom: 13);
    // Update the camera on the app
    await con.animateCamera(
      CameraUpdate.newCameraPosition(newCameraPos),
    );
  }

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

  // Generate a polyline from a list of points
  void generatePolyLineFromPoints(List<LatLng> polylineCoor) {
    // Set the id to a polyline
    PolylineId id = const PolylineId("poly");
    // Create the new polyline object
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.blue, points: polylineCoor, width: 8);
    // Set the polyline in the map
    setState(() {
      polylines[id] = polyline;
    });
  }
}
