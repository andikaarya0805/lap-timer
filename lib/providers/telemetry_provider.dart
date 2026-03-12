import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class TelemetryProvider with ChangeNotifier {
  double _currentSpeed = 0.0;
  double _currentDistance = 0.0; // Distance in meters
  double _topSpeed = 0.0;
  double _personalBest = 0.0;
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _speedTimer;
  Timer? _uiTimer;
  
  // Settings
  bool _useMetric = true; // KPH vs MPH
  bool _rolloutEnabled = true; // 1ft Rollout
  bool _soundAlerts = true;
  
  List<Map<String, dynamic>> _splitTimes = [
    {'distance': '60 ft', 'time': '--:--.--', 'speed': '--', 'achieved': false, 'targetMeters': 18.288},
    {'distance': '100 m', 'time': '--:--.--', 'speed': '--', 'achieved': false, 'targetMeters': 100.0},
    {'distance': '200 m', 'time': '--:--.--', 'speed': '--', 'achieved': false, 'targetMeters': 200.0},
    {'distance': '402 m', 'time': '--:--.--', 'speed': '--', 'achieved': false, 'targetMeters': 402.336},
  ];

  List<double> _speedCurve = [];

  double get currentSpeed => _currentSpeed;
  double get currentDistance => _currentDistance;
  double get topSpeed => _topSpeed;
  double get personalBest => _personalBest;
  
  bool get useMetric => _useMetric;
  bool get rolloutEnabled => _rolloutEnabled;
  bool get soundAlerts => _soundAlerts;

  void toggleUnits() {
    _useMetric = !_useMetric;
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
    _splitTimes = [
      {'distance': '60 ft', 'time': '--:--.--', 'speed': '--', 'achieved': false, 'targetMeters': 18.288},
      {'distance': '100 m', 'time': '--:--.--', 'speed': '--', 'achieved': false, 'targetMeters': 100.0},
      {'distance': '200 m', 'time': '--:--.--', 'speed': '--', 'achieved': false, 'targetMeters': 200.0},
      {'distance': '402 m', 'time': '--:--.--', 'speed': '--', 'achieved': false, 'targetMeters': 402.336},
    ];
    notifyListeners();
  }

  void _startSimulation() {
    _speedTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_currentSpeed < 320) {
        // Accelerate
        double acceleration = 2.5 + (Random().nextDouble() * 2);
        _currentSpeed += acceleration;
        
        // Update distance (rough estimation: average speed * time interval)
        // currentSpeed is in KM/H, convert to m/s
        double speedInMs = _currentSpeed / 3.6;
        _currentDistance += speedInMs * 0.1; // 0.1 seconds interval

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
      if (!split['achieved'] && _currentDistance >= split['targetMeters']) {
        split['time'] = elapsedTime.substring(3); // Just SS.HH for table maybe? No, let's keep full for now or as per UI
        split['speed'] = _currentSpeed.toStringAsFixed(0);
        split['achieved'] = true;
        
        if (split['distance'] == '402 m') {
          _personalBest = _stopwatch.elapsed.inMilliseconds / 1000;
        }
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
