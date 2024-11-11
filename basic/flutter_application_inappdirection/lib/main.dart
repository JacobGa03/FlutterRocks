import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_inappdirection/env.dart';
import 'package:flutter_application_inappdirection/util/intent_utils.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChooseLocations(),
    );
  }
}

class ChooseLocations extends StatelessWidget {
  ChooseLocations({super.key});
  // Each location is a map with lat and lng
  final List<Map<String, double>> _locations = [{}, {}];
  final startController = TextEditingController();
  final endController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Destinations')),
      body: Column(
        children: [
          // Select primary destination
          Padding(
            padding: const EdgeInsets.all(8),
            child: TypeAheadField(
              builder: (context, startController, focusNode) => TextField(
                controller: startController,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  hintText: 'Enter Primary Destination',
                  border: OutlineInputBorder(),
                ),
              ),
              suggestionsCallback: (pattern) async {
                // Call the Google Maps API to get the suggestions
                return await getLocations(pattern);
              },
              onSelected: (suggestion) async {
                final finalLoc =
                    await getLocationDetails(suggestion['place_id']);

                _locations[0]['lat'] = finalLoc?['lat'] ?? 0;
                _locations[0]['lng'] = finalLoc?['lng'] ?? 0;
              },
              itemBuilder: (context, suggest) {
                return ListTile(
                  title: Text(suggest['description'].toString() ?? ''),
                );
              },
            ),
          ),
          // Final destinations
          Padding(
            padding: const EdgeInsets.all(8),
            child: TypeAheadField(
              builder: (context, endController, focusNode) => TextField(
                controller: endController,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  hintText: 'Enter Final Destination',
                  border: OutlineInputBorder(),
                ),
              ),
              suggestionsCallback: (pattern) async {
                // Call the Google Maps API to get the suggestions
                return await getLocations(pattern);
              },
              onSelected: (suggestion) async {
                final finalLoc =
                    await getLocationDetails(suggestion['place_id']);

                _locations[1]['lat'] = finalLoc?['lat'] ?? 0;
                _locations[1]['lng'] = finalLoc?['lng'] ?? 0;
              },
              itemBuilder: (context, suggest) {
                return ListTile(
                  title: Text(suggest['description'].toString() ?? ''),
                );
              },
            ),
          ),

          ElevatedButton(
            onPressed: () {
              // _addIntermediateLocation(); // Add new intermediate location
              print(_locations);
            },
            child: const Text("Add Intermediate Location"),
          ),

          // Go to the map page
          ElevatedButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainApp(location: _locations),
                ),
              );

              // await IntentUtils.launchGoogleMaps();
            },
            child: const Text("Continue to Map"),
          ),
        ],
      ),
    );
  }
}

// Get location suggestions from Google Maps API
Future<List<Map<String, dynamic>>> getLocations(String query) async {
  final url =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$GOOGLE_MAPS';

  final response = await http.get(Uri.parse(url));
  // We got a response
  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);

    final predictions = jsonResponse['predictions'] as List;
    // Return the list of place names and their IDs
    return predictions
        .map((prediction) => {
              'description': prediction['description'],
              'place_id': prediction['place_id'],
            })
        .toList();
  } else {
    throw Exception('Failed to load suggestions');
  }
}

// Get location details (Lat and Lng) from Google Maps API
Future<Map<String, double>?> getLocationDetails(String placeId) async {
  final url =
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$GOOGLE_MAPS';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final result = jsonResponse['result'];

    if (result != null) {
      final location = result['geometry']['location'];
      return {
        'lat': location['lat'],
        'lng': location['lng'],
      };
    } else {
      print("No result found for place ID: $placeId");
      return null;
    }
  } else {
    print('Failed to load location details: ${response.statusCode}');
    return null;
  }
}

class MainApp extends StatefulWidget {
  List<Map<String, double>> location;
  MainApp({super.key, required this.location});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late WebViewController controller;
  // Store the current location of the user
  String? _startLocation = '';
  String? _finalLocation = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Load the map with the user's location
    _loadCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("DriveU"),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.arrow_forward)),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : WebViewWidget(controller: controller),
      ),
    );
  }

  Future<void> _loadCurrentLocation() async {
    // Get the permission to get the user's location
    await Geolocator.requestPermission();
    // Get the user's current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _startLocation =
          '${widget.location[0]['lat']},${widget.location[0]['lng']}';
      _finalLocation =
          '${widget.location[1]['lat']},${widget.location[1]['lng']}';
      _isLoading = false;
    });

    // Load the Google Maps page with the selected locations
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(
          'https://www.google.com/maps/dir/?api=1&origin=$_startLocation&destination=$_finalLocation'))
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (String url) {
          print('Page started loading: $url');
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
        },
        onWebResourceError: (WebResourceError error) {
          print('Error: $error');
        },
        onNavigationRequest: (NavigationRequest request) async {
          if (request.url.contains(RegExp('^intent://.*\$'))) {
            print('launching intent');
            launchUrl(Uri.parse(request.url));
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ));
  }
}
