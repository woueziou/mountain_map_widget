import 'package:flutter/widgets.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mountain_map/app/services/latlng.dart';

class Marker extends StatefulWidget {
  // The widget position on the UI
  final ValueNotifier<ScreenCoordinate> screenPosition;

  // The Marker id
  final String id;

  // The marker geo data
  final LatLng geoCoordinate;

  // Your widget coming from your imagination feel free 😎
  final Widget child;
  Marker({
    super.key,
    required ScreenCoordinate position,
    required this.geoCoordinate,
    required this.child,
    required this.id,
  }) : screenPosition = ValueNotifier(position);

  @override
  MarkerState createState() => MarkerState();
}

class MarkerState extends State<Marker> {
  MarkerState();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.screenPosition,
      builder: (context, pos, child) {
        return Positioned(
          left: pos.x,
          top: pos.y,
          child: GestureDetector(
            onTap: () {},
            child: widget.child,
          ),
        );
      },
    );
  }
}
