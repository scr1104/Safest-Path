import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomStreams{

  static Stream<bool> onVisibleRegionChangedStream(GoogleMapController mapController, Duration dur) async* {
    LatLngBounds pastCamPos = await mapController.getVisibleRegion();
    while (true) {
      await Future.delayed(dur);
      LatLngBounds curCamPos = await mapController.getVisibleRegion();
      if (pastCamPos != curCamPos){
        yield true;
      }
      pastCamPos = curCamPos;
    }
  }
}