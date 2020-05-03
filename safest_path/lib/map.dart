import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:search_map_place/search_map_place.dart';

import 'package:safestpath/constants/strings.dart';
import 'package:safestpath/constants/constants.dart';

class mainMap extends StatefulWidget {
  @override
  _mainMapState createState() => _mainMapState();
}

class _mainMapState extends State<mainMap> {
  GoogleMapController mapController;

  Location _location = Location();
  var _location$;
  LatLng userLoc;

  var allMarkers = {
    'self': Marker(markerId: MarkerId("1")),
    'dest': Marker(markerId: MarkerId("2"))
  };
  var heatmapCircles = [];

  Set<Polyline> safestDirection = {};

  @override
  void initState() {
    print('init');
    super.initState();

    try {
      _location$ = _location.onLocationChanged.listen((newLocalData) {
        this.setState(() {
          userLoc = LatLng(newLocalData.latitude, newLocalData.longitude);
//          safestDirection.add(
//            Polyline(
//              points: [
//                LatLng(12.988827, 77.472091),
//                LatLng(12.980821, 77.470815),
//                LatLng(12.969406, 77.471301)
//              ],
//              endCap: Cap.squareCap,
//              geodesic: false,
//              polylineId: PolylineId("line_one"),
//            ),
//          );

          allMarkers['self'] = Marker(
              markerId: MarkerId("self"),
              position: userLoc,
              rotation: newLocalData.heading,
              draggable: false,
              zIndex: 2,
              flat: true,
              );
        });
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  void setDest() async {
    var avg = (double a, double b) => (a + b) / 2;
    LatLng swCorner = (await mapController.getVisibleRegion()).southwest;
    LatLng neCorner = (await mapController.getVisibleRegion()).northeast;

    LatLng centerscreen = LatLng(avg(swCorner.latitude, neCorner.latitude),
        avg(swCorner.longitude, neCorner.longitude));
    this.setState(() {
      allMarkers['dest'] = Marker(
          markerId: MarkerId("dest"),
          position: centerscreen,
          draggable: false,
          zIndex: 2,
          flat: true,);
      print(allMarkers['dest']);
    });
  }

  //handles loading for current location using futurebuilder
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: FutureBuilder<LocationData>(
        future: _location.getLocation(),
        builder: (BuildContext context, AsyncSnapshot<LocationData> snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: <Widget>[
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                    mapController.setMapStyle(mapStyle);
                  },
                  mapToolbarEnabled: false,
                  markers: Set.of(allMarkers.values.toList()),
                  circles: Set.from(heatmapCircles),
                  initialCameraPosition: CameraPosition(
                    target:
                        LatLng(snapshot.data.latitude, snapshot.data.longitude),
                    zoom: 15.0,
                  ),
                  polylines: safestDirection,
                ),
                _mapOverlays(
                    mapController: this.mapController, userLoc: this.userLoc),
                Positioned.fill(
                  child: Align(
                      alignment: Alignment.center, child: Icon(Icons.add)),
                )
              ],
            );
          } else {
            return Expanded(
              child: SizedBox(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: setDest,
        label: Text(GlobalStrings.setDest),
        icon: Icon(Icons.add_location),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  void dispose() {
    //clean up subscriptions
    if (_location$ != null) {
      _location$.cancel();
    }
    super.dispose();
  }
}

class _mapOverlays extends StatefulWidget {
  GoogleMapController mapController;
  LatLng userLoc;
  _mapOverlays({this.mapController, this.userLoc});

  @override
  _mapOverlaysState createState() => _mapOverlaysState();
}

class _mapOverlaysState extends State<_mapOverlays> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
            top: 10,
            right: 0,
            child: SearchMapPlaceWidget(
              apiKey: API_KEY, // YOUR GOOGLE MAPS API KEY
              language: 'en',
              // The position used to give better recomendations. In this case we are using the user position
              location: widget.userLoc,
              radius: 30000,
              onSelected: (Place place) async {
                final geolocation = await place.geolocation;

                widget.mapController.animateCamera(
                    CameraUpdate.newLatLng(geolocation.coordinates));
                widget.mapController.animateCamera(
                    CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
              },
            )),
        Positioned(
            top: 60,
            right: 40,
            child: IconButton(
              icon: Icon(Icons.adjust),
              onPressed: () {
                if (widget.mapController != null) {
                  widget.mapController.animateCamera(
                      CameraUpdate.newCameraPosition(new CameraPosition(
                          bearing: 0,
                          target: widget.userLoc,
                          tilt: 0,
                          zoom: 15.00)));
                }
              },
            ))
      ],
    );
  }
}
