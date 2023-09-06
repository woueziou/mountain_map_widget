import 'package:geolocator/geolocator.dart';
import 'package:mountain_map/app/services/latlng.dart';

Future<LatLng> getCurrentLatLng() async {
  final data = await Geolocator.getCurrentPosition();
  return LatLng(lat: data.latitude, lng: data.longitude);
}
