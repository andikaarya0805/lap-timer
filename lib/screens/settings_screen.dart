import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/telemetry_provider.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final telemetry = context.watch<TelemetryProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'SETTINGS',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.accentOrange),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader('PREFERENCES'),
          _buildSettingsTile(
            'Units',
            telemetry.useMetric ? 'Metric (KPH/Meters)' : 'Imperial (MPH/Feet)',
            Icons.straighten,
            telemetry.useMetric,
            (v) => telemetry.toggleUnits(),
          ),
          _buildSettingsTile(
            '1ft Rollout',
            'Compulsive start timing',
            Icons.timer_outlined,
            telemetry.rolloutEnabled,
            (v) => telemetry.toggleRollout(),
          ),
          _buildSettingsTile(
            'Sound Alerts',
            'Voice and beep notifications',
            Icons.volume_up,
            telemetry.soundAlerts,
            (v) => telemetry.toggleSound(),
          ),
          const SizedBox(height: 30),
          _buildSectionHeader('APP INFO'),
          const ListTile(
            title: Text('Version', style: TextStyle(color: AppColors.textPrimary)),
            subtitle: Text('1.0.0 (ANTI-GRAVITY)', style: TextStyle(color: AppColors.textSecondary)),
          ),
          const ListTile(
            title: Text('Build Date', style: TextStyle(color: AppColors.textPrimary)),
            subtitle: Text('March 2026', style: TextStyle(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.accentOrange,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.accentBlue),
        title: Text(title, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.accentOrange,
          activeTrackColor: AppColors.accentOrange.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
