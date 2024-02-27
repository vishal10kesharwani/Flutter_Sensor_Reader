import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

bool servicestatus = false;
bool haspermission = false;
late LocationPermission permission;
late Position position;
String long = "", lat = "";
late StreamSubscription<Position> positionStream;
GeoLocation() {
  checkGps();
}

Future<void> checkGps() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied');
    } else if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied");
    } else {
      getLocation();
    }
  } else {
    getLocation();
  }
}

getLocation() async {
  position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  long = position.longitude.toString();
  lat = position.latitude.toString() +
      "\nTime-Stamp: " +
      position.timestamp.toString() +
      "\nAccuracy: " +
      position.accuracy.toString() +
      "\nAltitude: " +
      position.altitude.toString() +
      "\nAltitude Accuracy: " +
      position.altitudeAccuracy.toString() +
      "\nHeading: " +
      position.heading.toString() +
      "\nHeading Accuracy: " +
      position.headingAccuracy.toString() +
      "\nSpeed: " +
      position.speed.toString() +
      "\nSpeed Accuracy: " +
      position.speedAccuracy.toString();

  LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  StreamSubscription<Position> positionStream =
      Geolocator.getPositionStream(locationSettings: locationSettings)
          .listen((Position position) {
    long = position.longitude.toString();
    lat = position.latitude.toString() +
        "\nTime-Stamp: " +
        position.timestamp.toString() +
        "\nAccuracy: " +
        position.accuracy.toString() +
        "\nAltitude: " +
        position.altitude.toString() +
        "\nAltitude Accuracy: " +
        position.altitudeAccuracy.toString() +
        "\nHeading: " +
        position.heading.toString() +
        "\nHeading Accuracy: " +
        position.headingAccuracy.toString() +
        "\nSpeed: " +
        position.speed.toString() +
        "\nSpeed Accuracy: " +
        position.speedAccuracy.toString();
  });
}

// Method to return all values as a string
Widget getLocationValuesAsString() {
  checkGps();

  return Text(
      'Geolocation Sensor: \nService Status: ${servicestatus ? "Enabled" : "Disabled"}\n'
      'Permission Status: ${haspermission ? "Granted" : "Denied"}\n'
      'Longitude: $long\n'
      'Latitude: $lat');
}
