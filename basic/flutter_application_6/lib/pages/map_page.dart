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
  // An actual point on the map
  static const LatLng _jlco = LatLng(40.76902682137855, -73.98278441352859);
  static const LatLng _rcme = LatLng(40.76023602126428, -73.98004694041965);
  final Location _locationController = Location();
  // Represent the current position of the user
  LatLng? _currPos;

  final Completer<GoogleMapController> _mapCon = Completer();

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
            body: GoogleMap(
                onMapCreated: ((controller) => _mapCon.complete(controller)),
                markers: {
                  // Markers represent
                  Marker(
                      markerId: const MarkerId("_currentLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _currPos!),
                  const Marker(
                      markerId: MarkerId("_sourceLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _rcme),
                  const Marker(
                      markerId: MarkerId("_destinationLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _jlco)
                },
                polylines: Set<Polyline>.of(polylines.values),
                initialCameraPosition:
                    CameraPosition(target: _currPos!, zoom: 10)),
          );
  }

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
          _cameraToPosition(_currPos!);
        });
      }
    });
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController con = await _mapCon.future;
    CameraPosition newCameraPos = CameraPosition(target: pos, zoom: 13);
    // Update the camera on the app
    await con.animateCamera(
      CameraUpdate.newCameraPosition(newCameraPos),
    );
  }

  // Get the directions from Google Maps API from one location to another
  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoor = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult res = await polylinePoints.getRouteBetweenCoordinates(
        // The API key for Google Maps
        googleApiKey: GOOGLE_MAPS,
        request: PolylineRequest(
            origin: PointLatLng(_jlco.latitude, _jlco.longitude),
            destination: PointLatLng(_rcme.latitude, _rcme.longitude),
            mode: TravelMode.driving));
    if (res.points.isNotEmpty) {
      for (var point in res.points) {
        polylineCoor.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      print(res.errorMessage);
    }
    return polylineCoor;
  }

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
