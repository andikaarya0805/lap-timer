import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF0A0A0B);
  static const Color cardBackground = Color(0xFF161618);
  static const Color accentOrange = Color(0xFFFF6B00); // Safety Orange
  static const Color accentBlue = Color(0xFF00E5FF); // Cyber Blue
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFA0A0A0);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassFill = Color(0x1A646464);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.accentOrange,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentOrange,
        secondary: AppColors.accentBlue,
        surface: AppColors.cardBackground,
      ),
      textTheme: GoogleFonts.orbitronTextTheme(
        const TextTheme(
          displayLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          displaySmall: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textSecondary),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.accentBlue),
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.background,
      ),
    );
  }
}
