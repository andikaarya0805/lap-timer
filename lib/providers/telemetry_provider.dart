import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

enum RacingMode { speed, distance, custom }

class TelemetryProvider with ChangeNotifier {
  double _currentSpeed = 0.0;
  double _currentDistance = 0.0; // Distance in meters
  double _topSpeed = 0.0;
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _speedTimer;
  Timer? _uiTimer;
  
  // Settings
  bool _useMetric = true; // KPH vs MPH
  bool _rolloutEnabled = true; // 1ft Rollout
  bool _soundAlerts = true;
  RacingMode _activeMode = RacingMode.distance;
  
  List<Map<String, dynamic>> _splitTimes = [];

  List<double> _speedCurve = [];

  TelemetryProvider() {
    _initializeSplits();
  }

  void _initializeSplits() {
    if (_activeMode == RacingMode.distance) {
      if (_useMetric) {
        _splitTimes = [
          {'distance': '60 ft', 'time': '--:--.--', 'speed': '--', 'achieved': false, 'targetMeters': 18.288, 'type': 'distance'},
          {'distance': '100 m', 'time': '--:--.--', 'speed': '--', 'achieved': false, 'targetMeters': 100.0, 'type': 'distance'},
          {'distance': '200 m', 'time': '--:--.--', 'speed': '--', 'achieved': false, 'targetMeters': 200.0, 'type': 'distance'},
          {'distance': '402 m', 'time': '--:--.--', 'speed': '--', 'achieved': false, 'targetMeters': 402.336, 'type': 'distance'},
        ];
      } else {
        _splitTimes = [
          {'distance': '60 ft', 'time': '--:--.--', 'speed': '--', 'achieved': false, 'targetMeters': 18.288, 'type': 'distance'},
          {'distance': '1/16 mi', 'time': '--:--.--', 'speed': '--', 'achieved': false, 'targetMeters': 100.584, 'type': 'distance'},
          {'distance': '1/8 mi', 'time': '--:--.--', 'speed': '--', 'achieved': false, 'targetMeters': 201.168, 'type': 'distance'},
          {'distance': '1/4 mi', 'time': '--:--.--', 'speed': '--', 'achieved': false, 'targetMeters': 402.336, 'type': 'distance'},
        ];
      }
    } else if (_activeMode == RacingMode.speed) {
      if (_useMetric) {
        _splitTimes = [
          {'distance': '0-60', 'time': '--:--.--', 'speed': '60', 'achieved': false, 'targetSpeed': 60.0, 'startSpeed': 0.0, 'type': 'speed'},
          {'distance': '0-100', 'time': '--:--.--', 'speed': '100', 'achieved': false, 'targetSpeed': 100.0, 'startSpeed': 0.0, 'type': 'speed'},
          {'distance': '100-200', 'time': '--:--.--', 'speed': '200', 'achieved': false, 'targetSpeed': 200.0, 'startSpeed': 100.0, 'type': 'speed'},
          {'distance': '0-200', 'time': '--:--.--', 'speed': '200', 'achieved': false, 'targetSpeed': 200.0, 'startSpeed': 0.0, 'type': 'speed'},
        ];
      } else {
        _splitTimes = [
          {'distance': '0-30', 'time': '--:--.--', 'speed': '30', 'achieved': false, 'targetSpeed': 30.0, 'startSpeed': 0.0, 'type': 'speed'},
          {'distance': '0-60', 'time': '--:--.--', 'speed': '60', 'achieved': false, 'targetSpeed': 60.0, 'startSpeed': 0.0, 'type': 'speed'},
          {'distance': '60-130', 'time': '--:--.--', 'speed': '130', 'achieved': false, 'targetSpeed': 130.0, 'startSpeed': 60.0, 'type': 'speed'},
          {'distance': '0-130', 'time': '--:--.--', 'speed': '130', 'achieved': false, 'targetSpeed': 130.0, 'startSpeed': 0.0, 'type': 'speed'},
        ];
      }
    }
  }

  double get currentSpeed => _currentSpeed;
  double get currentDistance => _currentDistance;
  double get topSpeed => _topSpeed;
  
  bool get useMetric => _useMetric;
  bool get rolloutEnabled => _rolloutEnabled;
  bool get soundAlerts => _soundAlerts;
  RacingMode get activeMode => _activeMode;

  void setMode(RacingMode mode) {
    _activeMode = mode;
    resetRun();
  }

  void toggleUnits() {
    _useMetric = !_useMetric;
    _initializeSplits();
    notifyListeners();
  }

  void toggleRollout() {
    _rolloutEnabled = !_rolloutEnabled;
    notifyListeners();
  }

  void toggleSound() {
    _soundAlerts = !_soundAlerts;
    notifyListeners();
  }

  String get speedUnit => _useMetric ? 'KM/H' : 'MPH';
  double get displaySpeed => _useMetric ? _currentSpeed : _currentSpeed * 0.621371;
  double get displayDistance => _useMetric ? _currentDistance : _currentDistance * 3.28084;
  String get distanceUnit => _useMetric ? 'M' : 'FT';
  String get elapsedTime {
    final minutes = _stopwatch.elapsed.inMinutes.toString().padLeft(2, '0');
    final seconds = (_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');
    final hundredths = (_stopwatch.elapsed.inMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0');
    return '$minutes:$seconds.$hundredths';
  }
  List<Map<String, dynamic>> get splitTimes => _splitTimes;
  List<double> get speedCurve => _speedCurve;

  bool get isRunning => _stopwatch.isRunning;

  void startRun() {
    resetRun();
    _stopwatch.start();
    _startSimulation();
    _startUiUpdates();
    notifyListeners();
  }

  void resetRun() {
    _stopwatch.stop();
    _stopwatch.reset();
    _speedTimer?.cancel();
    _uiTimer?.cancel();
    _currentSpeed = 0.0;
    _currentDistance = 0.0;
    _speedCurve = [0.0];
    _initializeSplits();
    notifyListeners();
  }

  void _startSimulation() {
    _speedTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_currentSpeed < 320) {
        double acceleration = 2.5 + (Random().nextDouble() * 2);
        _currentSpeed += acceleration;
        
        double speedInMs = _currentSpeed / 3.6;
        _currentDistance += speedInMs * 0.1;

        if (_currentSpeed > _topSpeed) _topSpeed = _currentSpeed;
        
        _speedCurve.add(_currentSpeed);
        if (_speedCurve.length > 50) _speedCurve.removeAt(0);

        _checkSplits();
        notifyListeners();
      } else {
        _stopwatch.stop();
        timer.cancel();
      }
    });
  }

  void _startUiUpdates() {
    _uiTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      notifyListeners();
    });
  }

  void _checkSplits() {
    for (var split in _splitTimes) {
      if (split['achieved']) continue;

      bool achieved = false;
      if (split['type'] == 'distance') {
        if (_currentDistance >= split['targetMeters']) {
          achieved = true;
        }
      } else if (split['type'] == 'speed') {
        double targetSpeedKmh = _useMetric ? split['targetSpeed'] : split['targetSpeed'] / 0.621371;
        if (_currentSpeed >= targetSpeedKmh) {
          achieved = true;
        }
      }

      if (achieved) {
        split['time'] = elapsedTime.substring(3);
        split['speed'] = _currentSpeed.toStringAsFixed(0);
        split['achieved'] = true;
      }
    }
  }

  @override
  void dispose() {
    _speedTimer?.cancel();
    _uiTimer?.cancel();
    super.dispose();
  }
}
