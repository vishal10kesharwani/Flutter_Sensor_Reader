import 'package:environment_sensors/environment_sensors.dart';
import 'package:flutter/material.dart';

bool _tempAvailable = false;
bool _humidityAvailable = false;
bool _lightAvailable = false;
bool _pressureAvailable = false;
final environmentSensors = EnvironmentSensors();

Future<void> initPlatformState() async {
  environmentSensors.pressure.listen((pressure) {
    print(pressure.toString());
  });
  bool tempAvailable;
  bool humidityAvailable;
  bool lightAvailable;
  bool pressureAvailable;

  tempAvailable = await environmentSensors
      .getSensorAvailable(SensorType.AmbientTemperature);
  humidityAvailable =
      await environmentSensors.getSensorAvailable(SensorType.Humidity);
  lightAvailable =
      await environmentSensors.getSensorAvailable(SensorType.Light);
  pressureAvailable =
      await environmentSensors.getSensorAvailable(SensorType.Pressure);

  _tempAvailable = tempAvailable;
  _humidityAvailable = humidityAvailable;
  _lightAvailable = lightAvailable;
  _pressureAvailable = pressureAvailable;
}

Widget getLight(BuildContext context) {
  environmentSensors.pressure.listen((pressure) {
    print(pressure.toString());
  });
  initPlatformState();

  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    (_tempAvailable)
        ? StreamBuilder<double>(
            stream: environmentSensors.humidity,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              return Text(
                  'The Current Humidity is: ${snapshot.data?.toStringAsFixed(2)}%');
            })
        : Text('No relative humidity sensor found'),
    (_humidityAvailable)
        ? StreamBuilder<double>(
            stream: environmentSensors.temperature,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              return Text(
                  'The Current Temperature is: ${snapshot.data?.toStringAsFixed(2)}');
            })
        : Text('No temperature sensor found'),
    (_lightAvailable)
        ? StreamBuilder<double>(
            stream: environmentSensors.light,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              return Text(
                  'The Current Light is: ${snapshot.data?.toStringAsFixed(2)}');
            })
        : Text('No light sensor found'),
    (_pressureAvailable)
        ? StreamBuilder<double>(
            stream: environmentSensors.pressure,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              return Text(
                  'The Current Pressure is: ${snapshot.data?.toStringAsFixed(2)}');
            })
        : Text('No pressure sensure found'),
    //ElevatedButton(onPressed: initPlatformState , child: Text('Get'))
  ]);
}
