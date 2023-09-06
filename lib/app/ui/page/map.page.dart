import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mountain_map/app/services/geolocator.dart';
import 'package:mountain_map/app/ui/widgets/marker.dart';
import 'package:mountain_map/app/ui/widgets/marker.list.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapboxMap _mapController;
  final markerList = <Marker>{};

  Future<void> addMarker() async {
    // We get our current location data
    final myLocationData = await getCurrentLatLng();

    /* Important
     We ask the mapcontroller to give the screen coordinate based on
     our current location data (myLocationData) of type LatLng */
    final screenCoordinate = await _mapController.pixelForCoordinate(
        Point(coordinates: Position(myLocationData.lng, myLocationData.lat))
            .toJson());

    /* 
     We create the marker widget with the required data
    */
    final marker = Marker(
      position: screenCoordinate, // the screen position
      geoCoordinate: myLocationData, // the geospatial position
      id: "1", // the id (feel free to change)
      child: Image.asset(
        "assets/avatar.png",
        height: 32,
        width: 32,
      ), // My Widget I want to show on the map
    );

    // Add the new marker to list
    markerList.add(marker);

    // Trigger ui refresh
    setState(() {});
  }

  Future<void> updateMarkersPosition() async {
    // We check if any marker is present
    if (markerList.isNotEmpty) {
      for (var m in markerList) {
        /* For ever marker previously added
          we ask the mapboxcontroller to give the screenCoordinate corresponding to the geospatial coordinate
         */
        final screenCoordinate = await _mapController.pixelForCoordinate(Point(
                coordinates: Position(m.geoCoordinate.lng, m.geoCoordinate.lat))
            .toJson());
        // We update the new screen position
        m.screenPosition.value = screenCoordinate;
        // And finally we request a ui refresh
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ratio = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await addMarker();
        },
        child: const Icon(Icons.location_history),
      ),
      body: Stack(
        children: [
          MapWidget(
            onCameraChangeListener: (cameraChangedEventData) {
              updateMarkersPosition();
            },
            mapOptions: MapOptions(pixelRatio: ratio),
            onScrollListener: (coordinate) {},
            key: const ValueKey("mapBoxMap"),
            cameraOptions: CameraOptions(),
            onMapCreated: (controller) {
              _mapController = controller;
              _mapController.location
                  .updateSettings(LocationComponentSettings(enabled: false));
            },
            resourceOptions: ResourceOptions(
              accessToken:
                  "pk.eyJ1IjoiZnVzZWRldm9wcyIsImEiOiJjbG02bzBpMnUwM295M2Rsd3R2MGxpMDJhIn0.tN_wX1xlgIT8CJtgIB7AXg",
            ),
          ),
          MapMarkers(
            markers: markerList.toList(),
          )
        ],
      ),
    );
  }
}
