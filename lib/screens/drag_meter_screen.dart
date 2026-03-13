import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/telemetry_provider.dart';
import '../widgets/nav_drawer.dart';
import '../theme/app_theme.dart';

class DragMeterScreen extends StatelessWidget {
  const DragMeterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      body: Container(
        color: AppColors.background,
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      _buildSpeedHero(context),
                      const SizedBox(height: 20),
                      _buildMiddleCards(context),
                      const SizedBox(height: 25),
                      _buildSplitTable(context),
                    ],
                  ),
                ),
              ),
              _buildActionButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: const Text(
                'RACEBOX PRO',
                style: TextStyle(
                  color: AppColors.accentOrange,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          const Text(
            'GPS SIGNAL: 100%',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedHero(BuildContext context) {
    final telemetry = context.watch<TelemetryProvider>();
    return Column(
      children: [
        Text(
          telemetry.currentSpeed.toStringAsFixed(0),
          style: const TextStyle(
            fontSize: 130,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            height: 1.1,
          ),
        ),
        const Text(
          'KM/H',
          style: TextStyle(
            color: AppColors.accentOrange,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildMiddleCards(BuildContext context) {
    final telemetry = context.watch<TelemetryProvider>();
    return Row(
      children: [
        Expanded(
          child: _buildValueCard('TIME', telemetry.elapsedTime),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildValueCard('DISTANCE', telemetry.currentDistance.toStringAsFixed(0)),
        ),
      ],
    );
  }

  Widget _buildValueCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Courier',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSplitTable(BuildContext context) {
    final telemetry = context.watch<TelemetryProvider>();
    final isDistanceMode = telemetry.activeMode == RacingMode.distance;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  isDistanceMode ? 'DISTANCE' : 'SPEED RANGE',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              const Expanded(
                child: Text(
                  'TIME',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  isDistanceMode ? 'SPEED' : 'EXIT SPEED',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        const Divider(color: AppColors.glassBorder, height: 1),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: telemetry.splitTimes.length,
          itemBuilder: (context, index) {
            final split = telemetry.splitTimes[index];
            final achieved = split['achieved'] as bool;
            final textColor = achieved ? AppColors.accentOrange : AppColors.textSecondary;
            
            String distanceLabel = split['distance'];
            if (!isDistanceMode && split['type'] == 'speed') {
              distanceLabel = '${split['distance']} ${telemetry.speedUnit}';
            }

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.glassBorder.withValues(alpha: 0.1), width: 1)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      distanceLabel,
                      style: TextStyle(color: textColor, fontWeight: achieved ? FontWeight.bold : FontWeight.normal, fontSize: 13),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      split['time'],
                      textAlign: TextAlign.center,
                      style: TextStyle(color: textColor, fontWeight: achieved ? FontWeight.bold : FontWeight.normal, fontSize: 14, fontFamily: 'Courier'),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      achieved ? '${split['speed']} ${telemetry.speedUnit}' : '--',
                      textAlign: TextAlign.right,
                      style: TextStyle(color: textColor, fontWeight: achieved ? FontWeight.bold : FontWeight.normal, fontSize: 14),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final telemetry = context.watch<TelemetryProvider>();
    final isRunning = telemetry.isRunning;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.cardBackground,
            foregroundColor: AppColors.textPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            if (!isRunning) {
              telemetry.startRun();
            } else {
              telemetry.resetRun();
            }
          },
          child: Text(
            isRunning ? 'RACING...' : 'START RUN',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 2),
          ),
        ),
      ),
    );
  }
}
