import 'package:flutter/material.dart';
import 'package:flutter_application_openmapapp/api/google_maps_utils.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

// This component offers a TextField in which users can look for locations
class LocationSuggest extends StatelessWidget {
  // Map which holds the locations
  final List<Map<String, double>> locationsMap;
  // Where in the map to add the location
  final int index;
  final TextEditingController _controller = TextEditingController();
  LocationSuggest({super.key, required this.locationsMap, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TypeAheadField(
            controller: _controller,
            // hideOnEmpty: true,
            builder: (context, controller, focusNode) => TextField(
              controller: _controller,
              focusNode: focusNode,
              decoration: const InputDecoration(
                hintText: 'Enter Desired Destination',
                border: OutlineInputBorder(),
              ),
            ),
            suggestionsCallback: (pattern) async {
              // Call the Google Maps API to get the suggestions
              return await GoogleMapsUtils().getLocations(pattern);
            },
            onSelected: (suggestion) async {
              // Once a location is selected, call the Google Maps API to get the location details
              final finalLoc = await GoogleMapsUtils()
                  .getLocationDetails(suggestion['place_id']);

              locationsMap[index]['lat'] = finalLoc?['lat'] ?? 0;
              locationsMap[index]['lng'] = finalLoc?['lng'] ?? 0;
              _controller.text = suggestion['description'].toString();
            },
            itemBuilder: (context, suggest) {
              return ListTile(
                title: Text(suggest['description'].toString()),
              );
            },
          ),
        ),
        GestureDetector(
          onTap: () => _controller.clear(),
          child: const Icon(Icons.clear),
        ),
      ],
    );
  }
}
