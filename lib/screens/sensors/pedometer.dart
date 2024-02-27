import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

late Stream<StepCount> _stepCountStream;
late Stream<PedestrianStatus> _pedestrianStatusStream;
String _status = '?', _steps = '?';
void onStepCount(StepCount event) {
  print(event);
  _steps = event.steps.toString();
}

void onPedestrianStatusChanged(PedestrianStatus event) {
  print(event);

  _status = event.status;
}

void onPedestrianStatusError(error) {
  print('onPedestrianStatusError: $error');

  _status = 'Pedestrian Status not available';

  print(_status);
}

void onStepCountError(error) {
  print('onStepCountError: $error');
  _steps = 'Step Count not available';
}

void initPlatformState() async {
  _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
  _pedestrianStatusStream
      .listen(onPedestrianStatusChanged)
      .onError(onPedestrianStatusError);

  _stepCountStream = Pedometer.stepCountStream;
  _stepCountStream.listen(onStepCount).onError(onStepCountError);
}

Widget getPedometer(BuildContext context) {
  initPlatformState();

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Steps Taken',
          style: TextStyle(fontSize: 30),
        ),
        Text(
          _steps,
          style: TextStyle(fontSize: 60),
        ),
        Divider(
          height: 100,
          thickness: 0,
          color: Colors.white,
        ),
        Text(
          'Pedestrian Status',
          style: TextStyle(fontSize: 30),
        ),
        Icon(
          _status == 'walking'
              ? Icons.directions_walk
              : _status == 'stopped'
                  ? Icons.accessibility_new
                  : Icons.error,
          size: 100,
        ),
        Center(
          child: Text(
            _status,
            style: _status == 'walking' || _status == 'stopped'
                ? TextStyle(fontSize: 30)
                : TextStyle(fontSize: 20, color: Colors.red),
          ),
        )
      ],
    ),
  );
}
