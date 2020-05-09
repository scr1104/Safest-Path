import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HeatmapGenerator {
  // this variables should be in the google maps widget constructor
  // thiss class is around modifying this list
  Set<Circle> heatmapList;
  HeatmapGenerator(this.heatmapList);

  // modifies heatmapList to contain all relevant circles in the ranges
  // defined userLo and destLoc
  generateInArea(LatLng userLoc, LatLng destLoc) {
    // todo somehow get data, filter by bounds
    double padding = 0.005;

    double maxLat = max(userLoc.latitude, destLoc.latitude);
    double minLat = min(userLoc.latitude, destLoc.latitude);
    double maxLong = max(userLoc.longitude, destLoc.longitude);
    double minLong = min(userLoc.longitude, destLoc.longitude);
    var latRange = [minLat - padding, maxLat + padding];
    var longRange = [minLong - padding, maxLong + padding];

    for (var i = 0; i < 100; i++) {
      heatmapList.add(_genRandomCircle(latRange, longRange, i));
    }
  }

  //todo remove after getting real data
  _genRandomCircle(List<double> latBounds, List<double> longBounds, int id) {
    Random rand = Random();
    LatLng position = LatLng(
        rand.nextDouble() * (latBounds[1] - latBounds[0]) + latBounds[0],
        rand.nextDouble() * (longBounds[1] - longBounds[0]) + longBounds[0]);
    var circColour = _severityToColour(rand.nextDouble() * 400);
    return Circle(
      circleId: CircleId(id.toString()),
      center: position,
      radius: rand.nextDouble() * 60,
      fillColor: circColour,
      strokeWidth: 0,
    );
  }

  _severityToColour(double severity) {
    if (severity < 100) {
      return Color.fromRGBO(0, 255, 0, 0.5);
    } else if (severity < 200) {
      return Color.fromRGBO(125, 255, 0, 0.5);
    } else if (severity < 300) {
      return Color.fromRGBO(255, 255, 0, 0.5);
    } else if (severity < 300) {
      return Color.fromRGBO(255, 125, 0, 0.5);
    } else {
      return Color.fromRGBO(255, 0, 0, 0.5);
    }
  }
}
