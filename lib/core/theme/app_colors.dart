import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation
  AppColors._();

  // Primary Colors - Palette moderne et professionnelle
  static const Color primary = Color(0xFF6366F1); // Indigo vibrant
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Secondary Colors
  static const Color secondary = Color(0xFF10B981); // Green success
  static const Color secondaryLight = Color(0xFF34D399);
  static const Color secondaryDark = Color(0xFF059669);

  // Accent
  static const Color accent = Color(0xFFF59E0B); // Amber
  static const Color accentLight = Color(0xFFFBBF24);

  // Background
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);

  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFE2E8F0);

  // Input
  static const Color inputBackground = Color(0xFFF8FAFC);
  static const Color inputBorder = Color(0xFFE2E8F0);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Herbalife Brand Colors (pour éléments spécifiques)
  static const Color herbalifeGreen = Color(0xFF00A651);
  static const Color herbalifeRed = Color(0xFFE31837);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF34D399)],
  );

  // Shadow
  static const Color shadow = Color(0x1A000000);

  // CRM Status Colors
  static const Color prospectColor = Color(0xFF3B82F6); // Blue
  static const Color clientColor = Color(0xFF10B981); // Green
  static const Color inactiveColor = Color(0xFF64748B); // Gray

  // Task Priority Colors (Eisenhower Matrix)
  static const Color urgentImportant = Color(0xFFEF4444); // Red
  static const Color notUrgentImportant = Color(0xFFF59E0B); // Amber
  static const Color urgentNotImportant = Color(0xFF3B82F6); // Blue
  static const Color notUrgentNotImportant = Color(0xFF64748B); // Gray
}
