
import 'package:flutter/material.dart';
import './map.dart';
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
