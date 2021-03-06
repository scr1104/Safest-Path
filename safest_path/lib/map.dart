import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:search_map_place/search_map_place.dart';

import 'package:safestpath/constants/strings.dart';
import 'package:safestpath/constants/constants.dart';
import 'package:safestpath/path.dart';
import 'package:safestpath/heatmap.dart';
import 'package:safestpath/CustomUtils.dart';
import 'dart:async';

class mainMap extends StatefulWidget {
  @override
  _mainMapState createState() => _mainMapState();
}

class _mainMapState extends State<mainMap> {
  GoogleMapController mapController;
  Completer<GoogleMapController> _asyncMapController = Completer();
  HeatmapGenerator heatmapController ;

  DirectionUtility dirUtil = DirectionUtility(API_KEY);
  Location _location = Location();
  var _location$;
  var _VRChanged$;
  LatLng userLoc;

  Marker destmarker = Marker(markerId: MarkerId("dest"));

  Set<Circle> heatmapCircles = {};

  Set<Polyline> safestDirection = {};

  @override
  void initState() {
    super.initState();

    
    try {
      // subscribe to all listeners we need here
      _location$ = _location.onLocationChanged.listen((newLocalData) {
        this.setState(() {
          userLoc = LatLng(newLocalData.latitude, newLocalData.longitude);

          //if destination exists, we do it here as a subscription
          // bc we want to continuously modify the path as user moves
          // todo edit this polyline to custom
          if (destmarker.position != LatLng(0.0, 0.0)) {
            dirUtil
                .getDirection(userLoc, destmarker.position)
                .then((res) {
              safestDirection.add(
                Polyline(
                    polylineId: PolylineId("directionLine"),
                    points: res,
                    endCap: Cap.squareCap,
                    geodesic: false,
                    width: 3,
                    color: Color.fromRGBO(256, 256, 256, 0.5)),
              );
            });
          }
        });
      });

      //since when this init runs, google map might not have been built yet,
      // so we use this promise to make sure the controller is assigned
      _asyncMapController.future.then((contr) {
        setState(() {
          heatmapController = HeatmapGenerator(heatmapCircles);
        });

//        _VRChanged$ = CustomStreams.onVisibleRegionChangedStream(
//                contr, Duration(microseconds: 100))
//            .listen((b) {
//          print('camera moved');
//        });
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  void setDest() async {
    // get center of screen, maps lib might have a better way to do this in the future
    var avg = (double a, double b) => (a + b) / 2;
    LatLng swCorner = (await mapController.getVisibleRegion()).southwest;
    LatLng neCorner = (await mapController.getVisibleRegion()).northeast;
    LatLng centerscreen = LatLng(avg(swCorner.latitude, neCorner.latitude),
        avg(swCorner.longitude, neCorner.longitude));

    this.setState(() {
      //set destination marker
      destmarker = Marker(
        markerId: MarkerId("dest"),
        position: centerscreen,
        draggable: false,
        zIndex: 2,
        flat: true,
      );

      //set danger ratings
      //check if heatmapController is initialized
      if(heatmapController != null && userLoc != null){
        heatmapController.generateInArea(userLoc, centerscreen);
      }
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
                    this.setState(() {
                      mapController = controller;
                      mapController.setMapStyle(mapStyle);
                      _asyncMapController.complete(controller);
                    });
                  },
                  mapToolbarEnabled: false,
                  markers: {destmarker},
                  circles: heatmapCircles,
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target:
                        LatLng(snapshot.data.latitude, snapshot.data.longitude),
                    zoom: 15.0,
                  ),
                  polylines: safestDirection,
                ),
                _mapOverlays(
                    mapController: this.mapController, userLoc: this.userLoc),
              ],
            );
          } else {
            return Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: SizedBox(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
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
    if (_location$) {
      _location$.cancel();
    }
    if (_VRChanged$) {
      _VRChanged$.cancel();
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
            )),
        Positioned.fill(
          child: Align(alignment: Alignment.center, child: Icon(Icons.add)),
        )
      ],
    );
  }
}
