import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/telemetry_provider.dart';
import 'screens/drag_meter_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TelemetryProvider()),
      ],
      child: const AntiGravityApp(),
    ),
  );
}

class AntiGravityApp extends StatelessWidget {
  const AntiGravityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anti-Gravity Racing',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const DragMeterScreen(),
    );
  }
}
