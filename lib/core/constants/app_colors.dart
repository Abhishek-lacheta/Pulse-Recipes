import 'package:flutter/material.dart';

/// Centralized color palette following a modern, professional dark aesthetic.
class AppColors {
  AppColors._();

  // Primary / Brand colors
  static const Color primary = Color(0xFF6366F1); // Indigo 500
  static const Color primaryLight = Color(0xFF818CF8); // Indigo 400

  // Backgrounds & Surface
  static const Color background = Color(0xFF0B0F17); // Deep luxury obsidian
  static const Color surface = Color(0xFF151C28); // Slate navy surface
  static const Color surfaceLight = Color(0xFF1E283A); // Elevated card surface
  static const Color border = Color(0xFF263346); // Subtle border
  static const Color borderFocused = Color(0xFF6366F1); // Highlight border

  // Typography
  static const Color textPrimary = Color(0xFFF8FAFC); // High emphasis
  static const Color textSecondary = Color(0xFF94A3B8); // Medium emphasis
  static const Color textMuted = Color(0xFF64748B); // Low emphasis

  // Feedback & State
  static const Color error = Color(0xFFEF4444);

  // Base
  static const Color white = Colors.white;
}
