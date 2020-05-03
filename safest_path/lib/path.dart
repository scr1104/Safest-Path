
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

//todo replace this class with a custom class bounded by police data
class DirectionUtility{
  String apiKey;
  DirectionUtility(this.apiKey);

  //send request to get path from start to end
  Future<List<LatLng>> getDirection(LatLng start, LatLng end) async{
    List<LatLng> polylinePoints = [];
    var response = await http.get(
        "https://maps.googleapis.com/maps/api/directions/json?" +
            "origin=${start.latitude},${start.longitude}" +
            "&destination=${end.latitude},${end.longitude}" +
            "&mode=walking&key=$apiKey");

    if (response?.statusCode == 200) {
      var parsedJson = json.decode(response.body);
      if (parsedJson["status"]?.toLowerCase() == 'ok' &&
          parsedJson["routes"] != null &&
          parsedJson["routes"].isNotEmpty) {
        polylinePoints = _decodeEncodedPolyline(
            parsedJson["routes"][0]["overview_polyline"]["points"]);
      } else {
        throw Exception(parsedJson["error_message"]);
      }
    }
    return polylinePoints;
  }

  // decode from https://developers.google.com/maps/documentation/utilities/polylinealgorithm
  List<LatLng> _decodeEncodedPolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      LatLng p =
      new LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }

}

