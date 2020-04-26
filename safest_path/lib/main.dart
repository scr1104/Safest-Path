import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

//This serves as the 'View' of the model view controller archetecture
void main() {
  runApp(MaterialApp(title: 'Safest Path', home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 1.0,
            child: mainMap(),
          ),
        ),
        Text('bruh'),
      ],
    ));
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
  var selfMarker = {'marker': Marker(), 'radius': Circle()};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    print('init');
    try {
      _location$ = _location.onLocationChanged.listen((newLocalData) {
        print('location updated');
        LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);

        this.setState(() {
          selfMarker['marker'] = Marker(
              markerId: MarkerId("home"),
              position: latlng,
              rotation: newLocalData.heading,
              draggable: false,
              zIndex: 2,
              flat: true,
              anchor: Offset(0.5, 0.5));
          selfMarker['radius'] = Circle(
              circleId: CircleId("car"),
              radius: newLocalData.accuracy,
              zIndex: 1,
              strokeColor: Colors.blue,
              center: latlng,
              fillColor: Colors.blue.withAlpha(70));
        });
        if (mapController != null) {
          mapController.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 18.00)));
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      markers: Set.of(( selfMarker['marker'] != null) ? [selfMarker['marker']] : []),
      circles: Set.of(( selfMarker['radius'] != null) ? [selfMarker['radius']] : []),
      initialCameraPosition: CameraPosition(
        target: LatLng(45.521563, -122.677433),
        zoom: 30.0,
      ),
    );
  }

  @override
  void dispose() {
    if (_location$ != null) {
      _location$.cancel();
    }
    super.dispose();
  }
}
