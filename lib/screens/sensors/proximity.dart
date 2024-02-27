import 'dart:async';

import 'package:all_sensors2/all_sensors2.dart';
import 'package:flutter/material.dart';

bool _proximityValues = false;
List<StreamSubscription<dynamic>> _streamSubscriptions =
    <StreamSubscription<dynamic>>[];

Future<void> initState() async {
  _streamSubscriptions.add(proximityEvents!.listen((ProximityEvent event) {
    _proximityValues = event.getValue();
  }));
}

Widget getProximity(BuildContext context) {
  _streamSubscriptions.add(proximityEvents!.listen((ProximityEvent event) {
    _proximityValues = event.getValue();
  }));
  initState();
  return Column(
    children: [
      Padding(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Proximity: $_proximityValues'),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
      ),
    ],
  );
}
