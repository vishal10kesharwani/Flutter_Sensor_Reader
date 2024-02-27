import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

const Duration _ignoreDuration = Duration(milliseconds: 20);

const int _snakeRows = 20;
const int _snakeColumns = 20;
const double _snakeCellSize = 10.0;

UserAccelerometerEvent? _userAccelerometerEvent;
AccelerometerEvent? _accelerometerEvent;
GyroscopeEvent? _gyroscopeEvent;
MagnetometerEvent? _magnetometerEvent;

DateTime? _userAccelerometerUpdateTime;
DateTime? _accelerometerUpdateTime;
DateTime? _gyroscopeUpdateTime;
DateTime? _magnetometerUpdateTime;

int? _userAccelerometerLastInterval;
int? _accelerometerLastInterval;
int? _gyroscopeLastInterval;
int? _magnetometerLastInterval;
final _streamSubscriptions = <StreamSubscription<dynamic>>[];

Duration sensorInterval = SensorInterval.normalInterval;
List<AccelerometerEvent> _accelerometerValues = [];

// StreamSubscription for accelerometer events
late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;

Widget getGyroscope(BuildContext context) {
  _streamSubscriptions.add(
    userAccelerometerEventStream(samplingPeriod: sensorInterval).listen(
      (UserAccelerometerEvent event) {
        final now = DateTime.now();

        _userAccelerometerEvent = event;
        if (_userAccelerometerUpdateTime != null) {
          final interval = now.difference(_userAccelerometerUpdateTime!);
          if (interval > _ignoreDuration) {
            _userAccelerometerLastInterval = interval.inMilliseconds;
          }
        }

        _userAccelerometerUpdateTime = now;
      },
      onError: (e) {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Sensor Not Found"),
                content: Text(
                    "It seems that your device doesn't support User Accelerometer Sensor"),
              );
            });
      },
      cancelOnError: true,
    ),
  );
  _streamSubscriptions.add(
    accelerometerEventStream(samplingPeriod: sensorInterval).listen(
      (AccelerometerEvent event) {
        final now = DateTime.now();

        _accelerometerEvent = event;
        if (_accelerometerUpdateTime != null) {
          final interval = now.difference(_accelerometerUpdateTime!);
          if (interval > _ignoreDuration) {
            _accelerometerLastInterval = interval.inMilliseconds;
          }
        }

        _accelerometerUpdateTime = now;
      },
      onError: (e) {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Sensor Not Found"),
                content: Text(
                    "It seems that your device doesn't support Accelerometer Sensor"),
              );
            });
      },
      cancelOnError: true,
    ),
  );
  _streamSubscriptions.add(
    gyroscopeEventStream(samplingPeriod: sensorInterval).listen(
      (GyroscopeEvent event) {
        final now = DateTime.now();

        _gyroscopeEvent = event;
        if (_gyroscopeUpdateTime != null) {
          final interval = now.difference(_gyroscopeUpdateTime!);
          if (interval > _ignoreDuration) {
            _gyroscopeLastInterval = interval.inMilliseconds;
          }
        }

        _gyroscopeUpdateTime = now;
      },
      onError: (e) {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Sensor Not Found"),
                content: Text(
                    "It seems that your device doesn't support Gyroscope Sensor"),
              );
            });
      },
      cancelOnError: true,
    ),
  );
  _streamSubscriptions.add(
    magnetometerEventStream(samplingPeriod: sensorInterval).listen(
      (MagnetometerEvent event) {
        final now = DateTime.now();

        _magnetometerEvent = event;
        if (_magnetometerUpdateTime != null) {
          final interval = now.difference(_magnetometerUpdateTime!);
          if (interval > _ignoreDuration) {
            _magnetometerLastInterval = interval.inMilliseconds;
          }
        }

        _magnetometerUpdateTime = now;
      },
      onError: (e) {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Sensor Not Found"),
                content: Text(
                    "It seems that your device doesn't support Magnetometer Sensor"),
              );
            });
      },
      cancelOnError: true,
    ),
  );
  _accelerometerSubscription = accelerometerEvents.listen((event) {
    _accelerometerValues = [event];
  });
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      Text(
        'Gyroscope Data',
        style: TextStyle(fontSize: 20),
      ),
      SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Table(
          border: TableBorder.all(
              color: Colors.black, borderRadius: BorderRadius.circular(10)),
          columnWidths: const {
            0: FlexColumnWidth(4),
            4: FlexColumnWidth(2),
          },
          children: [
            const TableRow(
              children: [
                SizedBox.shrink(),
                Text('X', textAlign: TextAlign.center),
                Text('Y', textAlign: TextAlign.center),
                Text('Z', textAlign: TextAlign.center),
                Text('Interval', textAlign: TextAlign.center),
              ],
            ),
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Gyroscope', textAlign: TextAlign.center),
                ),
                Center(
                    child: Text(_gyroscopeEvent?.x.toStringAsFixed(1) ?? '?')),
                Center(
                    child: Text(_gyroscopeEvent?.y.toStringAsFixed(1) ?? '?')),
                Center(
                    child: Text(_gyroscopeEvent?.z.toStringAsFixed(1) ?? '?')),
                Center(
                    child: Text(
                        '${_gyroscopeLastInterval?.toString() ?? '?'} ms')),
              ],
            ),
          ],
        ),
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Update Interval:'),
          SizedBox(height: 10),
          SegmentedButton(
            segments: [
              ButtonSegment(
                value: SensorInterval.gameInterval,
                label: Text('Interval\n'
                    '(${SensorInterval.gameInterval.inMilliseconds}ms)'),
              ),
              ButtonSegment(
                value: SensorInterval.uiInterval,
                label: Text('UI\n'
                    '(${SensorInterval.uiInterval.inMilliseconds}ms)'),
              ),
              ButtonSegment(
                value: SensorInterval.normalInterval,
                label: Text('Normal\n'
                    '(${SensorInterval.normalInterval.inMilliseconds}ms)'),
              ),
              const ButtonSegment(
                value: Duration(milliseconds: 500),
                label: Text('500ms'),
              ),
              const ButtonSegment(
                value: Duration(seconds: 1),
                label: Text('1s'),
              ),
            ],
            selected: {sensorInterval},
            showSelectedIcon: false,
            onSelectionChanged: (value) {
              sensorInterval = value.first;
              userAccelerometerEventStream(samplingPeriod: sensorInterval);
              accelerometerEventStream(samplingPeriod: sensorInterval);
              gyroscopeEventStream(samplingPeriod: sensorInterval);
              magnetometerEventStream(samplingPeriod: sensorInterval);
            },
          ),
        ],
      ),
    ],
  );
}
