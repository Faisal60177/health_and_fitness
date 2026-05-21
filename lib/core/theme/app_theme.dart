import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);
  static ThemeData get lightTheme => _buildTheme(Brightness.light);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3:            true,
      brightness:              brightness,
      scaffoldBackgroundColor: isDark
          ? AppColors.background
          : AppColors.backgroundLight,
      colorScheme: ColorScheme(
        brightness:  brightness,
        primary:     AppColors.primary,
        onPrimary:   Colors.black,
        surface:     isDark ? AppColors.surfaceCard : AppColors.surfaceCardLight,
        onSurface:   isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
        error:       AppColors.danger,
        onError:     Colors.white,
        // Required fields
        secondary:   AppColors.primary,
        onSecondary: Colors.black,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
            fontSize: 28, fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight),
        headlineMedium: TextStyle(
            fontSize: 22, fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight),
        bodyLarge: TextStyle(fontSize: 16,
            color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight),
        bodyMedium: TextStyle(fontSize: 14,
            color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight),
        labelSmall: TextStyle(fontSize: 12,
            color: isDark ? AppColors.textHint : AppColors.textHintLight),
      ),
    );
  }
}

// Add light mode colors to AppColors
class AppColors {
  // Dark mode (existing)
  static const primary        = Color(0xFF00C896);
  static const background     = Color(0xFF0F1117);
  static const surfaceCard    = Color(0xFF1A1D27);
  static const surfaceMuted   = Color(0xFF252836);
  static const textPrimary    = Color(0xFFFFFFFF);
  static const textSecondary  = Color(0xFFB0B3C1);
  static const textHint       = Color(0xFF6B6F80);
  static const success        = Color(0xFF4CAF50);
  static const warning        = Color(0xFFFF9800);
  static const danger         = Color(0xFFE53935);

  // Light mode (new)
  static const backgroundLight    = Color(0xFFF5F7FA);
  static const surfaceCardLight   = Color(0xFFFFFFFF);
  static const surfaceMutedLight  = Color(0xFFEEF0F5);
  static const textPrimaryLight   = Color(0xFF0F1117);
  static const textSecondaryLight = Color(0xFF4A4E5A);
  static const textHintLight      = Color(0xFF9098A9);
}