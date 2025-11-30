import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Basado en el color favorito #2039FA
  static const Color primaryColor = Color(0xFF2039FA);
  static const Color primaryLight = Color(0xFF4D5FFF);
  static const Color primaryDark = Color(0xFF0029D6);
  
  // Secondary Colors - Complementarios armoniosos
  static const Color secondaryColor = Color(0xFF5B6CFF);
  static const Color secondaryLight = Color(0xFF8B9CFF);
  static const Color secondaryDark = Color(0xFF2B3FCF);
  
  // Background Colors
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFFFFFF);
  
  // Dark Theme Colors
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkSurfaceColor = Color(0xFF1E1E1E);
  static const Color darkCardColor = Color(0xFF2C2C2C);
  
  // Status Colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFF44336);
  static const Color infoColor = Color(0xFF2196F3);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);
  
  // Dark Theme Text Colors
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
  static const Color darkTextDisabled = Color(0xFF666666);
  
  // K-pop Inspired Colors
  static const Color btsPurple = Color(0xFF7C4DFF);
  static const Color blackpinkPink = Color(0xFFE91E63);
  static const Color twiceOrange = Color(0xFFFF6B35);
  static const Color redVelvetRed = Color(0xFFE53935);
  static const Color nctGreen = Color(0xFF00BCD4);
  static const Color strayKidsBlue = Color(0xFF3F51B5);
  static const Color newJeansPastel = Color(0xFFFFB3BA);
  static const Color leSserafimBlue = Color(0xFF1E88E5);
  static const Color iveYellow = Color(0xFFFFEB3B);
  
  // Collection Status Colors
  static const Color ownedColor = Color(0xFF4CAF50);
  static const Color wishlistColor = Color(0xFFFF9800);
  static const Color duplicateColor = Color(0xFF9C27B0);
  static const Color missingColor = Color(0xFF757575);
  
  // Gradient Colors - Basados en la nueva paleta
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1520A0), Color(0xFF2039FA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Acent colors para temas oscuros/claros
  static const Color accentLight = Color(0xFFE8EBFF);
  static const Color accentDark = Color(0xFF1A1E3A);
  
  // Get theme-appropriate colors
  static Color getPrimaryColor(bool isDark) => isDark ? primaryLight : primaryColor;
  static Color getBackgroundColor(bool isDark) => isDark ? darkBackgroundColor : backgroundColor;
  static Color getSurfaceColor(bool isDark) => isDark ? darkSurfaceColor : surfaceColor;
  static Color getTextColor(bool isDark) => isDark ? darkTextPrimary : textPrimary;
  static Color getTextSecondaryColor(bool isDark) => isDark ? darkTextSecondary : textSecondary;
}