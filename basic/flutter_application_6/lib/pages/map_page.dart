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
  // Our set of markers that we will display on the map
  Set<Marker> markers = {};
  final Completer<GoogleMapController> _mapCon = Completer();
  // Polylines to draw the route from source to destination
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    _initMap();
    // When the application first loads, draw the route from source to destination
    // TODO: Move this to somewhere when the person selected a ride
    // getLocationUpdates().then((_) =>
    //     getPolylinePoints(, ).then((coor) => generatePolyLineFromPoints(coor)));
  }

  // Get the location of the user, then generate the points.
  Future<void> _initMap() async {
    await getLocationUpdates().then((_) => getMarkers());
  }

  @override
  Widget build(BuildContext context) {
    return _currPos == null
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            appBar: AppBar(
              title: const Text("DriveU"),
            ),
            body: Column(
              children: [
                Expanded(
                  child: GoogleMap(
                      onMapCreated: ((controller) =>
                          _mapCon.complete(controller)),
                      markers: markers,
                      initialCameraPosition:
                          CameraPosition(target: _currPos!, zoom: 10)),
                ),
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
    if (!serviceEnabled) {
      // If we can, ask for permission to take location data
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) return;
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
          // _cameraToPosition(_currPos!);

          // TODO: When redrawing the map might need to remove users old location
          // Add the users current location to the map
          markers.add(Marker(
              markerId: const MarkerId("_currLocation"),
              // Here we will display some sort of alert dialog
              onTap: () => print("my current location"),
              position: _currPos!,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue)));

          // Just generate random points
          double lat = _currPos!.latitude;
          double lng = _currPos!.longitude;

          for (int i = 0; i < 25; i++) {
            double latOffset = (i % 2 == 0 ? 1 : -1) * (i * 0.01);
            double lngOffset = (i % 2 == 0 ? 1 : -1) * (i * 0.01);
            double newLat = lat + latOffset;
            double newLng = lng + lngOffset;

            Marker marker = Marker(
              markerId: MarkerId(i.toString()),
              icon: BitmapDescriptor.defaultMarker,
              position: LatLng(newLat, newLng),
              infoWindow: InfoWindow(title: "Marker $i"),
            );

            markers.add(marker);
            print("Adding marker $i at ($newLat, $newLng)");
          }

          // Call setState to update the map with new markers
          setState(() {});
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

  // TESTING: generate a set of markers to display on the map within a radius of the user
  Future<void> getMarkers() async {
    if (_currPos == null) {
      print("Current position is null");
      return;
    } // Ensure _currPos is not null

    double lat = _currPos!.latitude;
    double lng = _currPos!.longitude;

    for (int i = 0; i < 25; i++) {
      double latOffset = (i % 2 == 0 ? 1 : -1) * (i * 0.01);
      double lngOffset = (i % 2 == 0 ? 1 : -1) * (i * 0.01);
      double newLat = lat + latOffset;
      double newLng = lng + lngOffset;

      Marker marker = Marker(
        markerId: MarkerId(i.toString()),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(newLat, newLng),
        infoWindow: InfoWindow(title: "Marker $i"),
      );

      markers.add(marker);
      print("Adding marker $i at ($newLat, $newLng)");
    }

    // Call setState to update the map with new markers
    setState(() {});
  }
}
