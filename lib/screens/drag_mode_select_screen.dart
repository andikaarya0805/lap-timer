import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/telemetry_provider.dart';
import '../theme/app_theme.dart';
import 'drag_meter_screen.dart';

class DragModeSelectScreen extends StatelessWidget {
  const DragModeSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('SELECT MODE', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.accentOrange),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'WHAT DO YOU WANT TO MEASURE?',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
            const SizedBox(height: 20),
            _buildModeCard(
              context,
              'SPEED',
              'Measure acceleration between speed intervals.',
              Icons.speed,
              () => _selectMode(context, RacingMode.speed),
            ),
            _buildModeCard(
              context,
              'DISTANCE',
              'Classic drag race distances (1/4 mile, etc).',
              Icons.straighten,
              () => _selectMode(context, RacingMode.distance),
            ),
            _buildModeCard(
              context,
              'CUSTOM',
              'Configure your own set of disciplines.',
              Icons.settings_suggest,
              () => _selectMode(context, RacingMode.custom),
            ),
          ],
        ),
      ),
    );
  }

  void _selectMode(BuildContext context, RacingMode mode) {
    if (mode == RacingMode.custom) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Custom mode configuration coming soon!')),
      );
      return;
    }
    
    context.read<TelemetryProvider>().setMode(mode);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DragMeterScreen()),
    );
  }

  Widget _buildModeCard(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.glassBorder.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.accentOrange, size: 40),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
