import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensorreader/screens/sensors/accelerometer.dart';
import 'package:sensorreader/screens/sensors/geolocation.dart';
import 'package:sensorreader/screens/sensors/gyroscope.dart';
import 'package:sensorreader/screens/sensors/light_sensor.dart';
import 'package:sensorreader/screens/sensors/magnetometer.dart';
import 'package:sensorreader/screens/sensors/pedometer.dart';
import 'package:sensorreader/screens/sensors/proximity.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var gpsData;
  String selectedSensor = '';
  bool _isPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    final status = await Permission.activityRecognition.request();
    setState(() {
      _isPermissionGranted = status.isGranted;
    });
    final state = await Permission.sensors.request();
    setState(() {
      _isPermissionGranted = state.isGranted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor Data'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Sensors',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: Colors.deepOrangeAccent,
              ),
            ),
            ListTile(
              title: Text('GPS Sensor'),
              leading: Icon(Icons.gps_fixed),
              onTap: () {
                setState(() {
                  selectedSensor = 'GPS';
                  gpsData = getLocationValuesAsString();
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Accelerometer Sensor'),
              leading: Icon(Icons.speed),
              onTap: () {
                setState(() {
                  selectedSensor = 'Accelerometer';
                  gpsData = getAccelo(context);
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Gyroscope Sensor'),
              leading: Icon(Icons.screen_rotation),
              onTap: () {
                setState(() {
                  selectedSensor = 'Gyroscope';
                  gpsData = getGyroscope(context);
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Magnetometer Sensor'),
              leading: Icon(Icons.attractions),
              onTap: () {
                setState(() {
                  selectedSensor = 'Magnetometer';
                  gpsData = getMagnetometer(context);
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Proximity Sensor'),
              leading: Icon(Icons.location_disabled),
              onTap: () {
                setState(() {
                  selectedSensor = 'Proximity';
                  gpsData = getProximity(context);
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Light Sensor'),
              leading: Icon(Icons.light_mode_outlined),
              onTap: () {
                setState(() {
                  selectedSensor = 'Light';
                  gpsData = getLight(context);
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Pedometer'),
              leading: Icon(Icons.directions_walk),
              onTap: () {
                setState(() {
                  selectedSensor = 'Pedometer';
                  gpsData = getPedometer(context);
                });
                Navigator.pop(context); // Close the drawer
              },
            )
          ],
        ),
      ),
      body: Center(
        child: gpsData != null
            ? Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: gpsData,
                    ),
                  ),
                ],
              )
            : Text('Select a sensor from the drawer.'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            if (selectedSensor == 'GPS') {
              gpsData = getLocationValuesAsString();
            } else if (selectedSensor == 'Accelerometer') {
              gpsData = getAccelo(context);
            } else if (selectedSensor == 'Gyroscope') {
              gpsData = getGyroscope(context);
            } else if (selectedSensor == 'Magnetometer') {
              gpsData = getMagnetometer(context);
            } else if (selectedSensor == 'Proximity') {
              gpsData = getProximity(context);
            } else if (selectedSensor == 'Light') {
              gpsData = getLight(context);
            } else if (selectedSensor == 'Pedometer') {
              gpsData = getPedometer(context);
            }
          });
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
