import 'package:flutter/material.dart';

class AppColors {
  // Light Mode Colors - ألوان مميزة وجذابة
  static const Color primaryLight = Color(0xFF6C63FF); // بنفسجي حديث
  static const Color secondaryLight = Color(0xFFFF6584); // وردي فاتح
  static const Color backgroundLight = Color(0xFFF8F9FE);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF2D3142);
  static const Color textSecondaryLight = Color(0xFF9094A6);
  static const Color accentLight = Color(0xFFFFB800); // ذهبي
  static const Color successLight = Color(0xFF00D9A5);
  static const Color errorLight = Color(0xFFFF5252);
  static const Color warningLight = Color(0xFFFFAB00);
  static const Color infoLight = Color(0xFF3A86FF);
  static const Color borderLight = Color(0xFFE8ECF4);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color shadowLight = Color(0x1A000000);
  
  // Dark Mode Colors - ألوان داكنة أنيقة
  static const Color primaryDark = Color(0xFF8B7FFF); // بنفسجي فاتح
  static const Color secondaryDark = Color(0xFFFF7FA0); // وردي ناعم
  static const Color backgroundDark = Color(0xFF0F0F1E);
  static const Color surfaceDark = Color(0xFF1A1A2E);
  static const Color textPrimaryDark = Color(0xFFEAECF0);
  static const Color textSecondaryDark = Color(0xFFB4B7C3);
  static const Color accentDark = Color(0xFFFFC933); // ذهبي فاتح
  static const Color successDark = Color(0xFF00F5BF);
  static const Color errorDark = Color(0xFFFF6B6B);
  static const Color warningDark = Color(0xFFFFBD2E);
  static const Color infoDark = Color(0xFF5BA2FF);
  static const Color borderDark = Color(0xFF2A2A3E);
  static const Color cardDark = Color(0xFF16213E);
  static const Color shadowDark = Color(0x4D000000);
  
  // Gradient Colors
  static const LinearGradient primaryGradientLight = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF8B7FFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient primaryGradientDark = LinearGradient(
    colors: [Color(0xFF8B7FFF), Color(0xFFAA9FFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradientLight = LinearGradient(
    colors: [Color(0xFFFF6584), Color(0xFFFF8BA7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradientDark = LinearGradient(
    colors: [Color(0xFFFF7FA0), Color(0xFFFFAAC1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Status Colors
  static const Color present = Color(0xFF00D9A5);
  static const Color absent = Color(0xFFFF5252);
  static const Color late = Color(0xFFFFAB00);
  
  // Grade Colors
  static const Color gradeA = Color(0xFF00D9A5);
  static const Color gradeB = Color(0xFF3A86FF);
  static const Color gradeC = Color(0xFFFFAB00);
  static const Color gradeD = Color(0xFFFF8800);
  static const Color gradeF = Color(0xFFFF5252);
  
  // Chart Colors Light
  static const List<Color> chartColorsLight = [
    Color(0xFF6C63FF),
    Color(0xFFFF6584),
    Color(0xFFFFB800),
    Color(0xFF00D9A5),
    Color(0xFF3A86FF),
    Color(0xFFFF5252),
  ];
  
  // Chart Colors Dark
  static const List<Color> chartColorsDark = [
    Color(0xFF8B7FFF),
    Color(0xFFFF7FA0),
    Color(0xFFFFC933),
    Color(0xFF00F5BF),
    Color(0xFF5BA2FF),
    Color(0xFFFF6B6B),
  ];
}