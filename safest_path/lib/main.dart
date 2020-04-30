import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:search_map_place/search_map_place.dart';

import 'package:safestpath/constants/constants.dart';

//This serves as the 'View' of the model view controller archetecture
void main() {
  runApp(MaterialApp(title: 'Safest Path', home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              child: mainMap(),
            ),
          ),
        ],
      )),
    );
  }
}

class mainMap extends StatefulWidget {
  @override
  _mainMapState createState() => _mainMapState();
}

class _mainMapState extends State<mainMap> {
  GoogleMapController mapController;
  Location _location = Location();
  var _location$;

  LatLng userLoc;
  var selfMarker = {'marker': Marker(), 'radius': Circle()};
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

          selfMarker['marker'] = Marker(
              markerId: MarkerId("me"),
              position: userLoc,
              rotation: newLocalData.heading,
              draggable: false,
              zIndex: 2,
              flat: true,
              anchor: Offset(0.5, 0.5));
          selfMarker['radius'] = Circle(
              circleId: CircleId("meRad"),
              radius: newLocalData.accuracy,
              zIndex: 1,
              strokeColor: Colors.blue,
              center: userLoc,
              fillColor: Colors.blue.withAlpha(70));
        });
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
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
                  markers: Set.of((selfMarker['marker'] != null)
                      ? [selfMarker['marker']]
                      : []),
                  circles: Set.of((selfMarker['radius'] != null)
                      ? [selfMarker['radius']]
                      : []),
                  initialCameraPosition: CameraPosition(
                    target:
                        LatLng(snapshot.data.latitude, snapshot.data.longitude),
                    zoom: 15.0,
                  ),
                  polylines: safestDirection,
                ),
                _mapOverlays(
                    mapController: this.mapController,
                    userLoc: this.userLoc),
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
                CameraUpdate.newLatLngBounds(
                    geolocation.bounds, 0));
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
