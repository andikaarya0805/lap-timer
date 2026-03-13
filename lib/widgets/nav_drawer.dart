import 'package:flutter/material.dart';
import '../screens/settings_screen.dart';
import '../screens/history_screen.dart';
import '../screens/drag_mode_select_screen.dart';
import '../theme/app_theme.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(context, Icons.speed, 'DRAG METER', true, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const DragModeSelectScreen()));
                }),
                _buildMenuItem(context, Icons.history, 'HISTORY', false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
                }),
                _buildMenuItem(context, Icons.settings, 'SETTING', false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                }),
              ],
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(bottom: BorderSide(color: AppColors.accentOrange, width: 2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.accentBlue.withValues(alpha: 0.2),
            child: const Icon(Icons.person, color: AppColors.accentBlue, size: 40),
          ),
          const SizedBox(width: 15),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PILOT_01',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              Text(
                'RANK: PRO',
                style: TextStyle(color: AppColors.accentOrange, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, bool isSelected, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.accentOrange : AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          letterSpacing: 1.5,
        ),
      ),
      onTap: onTap,
      selected: isSelected,
      selectedTileColor: AppColors.accentOrange.withValues(alpha: 0.1),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Text(
        'ANTI-GRAVITY V1.0',
        style: TextStyle(color: AppColors.glassBorder, fontSize: 10, letterSpacing: 2),
      ),
    );
  }
}
