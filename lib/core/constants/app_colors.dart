import 'package:flutter/material.dart';

/// نظام ألوان احترافي للتطبيق
/// مستوحى من أفضل ألعاب الكلمات العالمية
abstract final class AppColors {
  // ===== الألوان الأساسية =====
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFF9D8DF7);
  static const Color primaryDark = Color(0xFF4834D4);

  static const Color secondary = Color(0xFF00CEC9);
  static const Color secondaryLight = Color(0xFF55EFC4);
  static const Color secondaryDark = Color(0xFF00B894);

  static const Color accent = Color(0xFFFF7675);
  static const Color accentLight = Color(0xFFFFB8B8);
  static const Color accentDark = Color(0xFFD63031);

  // ===== ألوان النص =====
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textTertiary = Color(0xFFB2BEC3);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFFDFE6E9);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFF5F6FA);

  // ===== ألوان الخلفية =====
  static const Color background = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF1E272E);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F3F4);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color overlay = Color(0x80000000);

  // ===== ألوان الحالات =====
  static const Color success = Color(0xFF00B894);
  static const Color successLight = Color(0xFF55EFC4);
  static const Color error = Color(0xFFD63031);
  static const Color errorLight = Color(0xFFFF7675);
  static const Color warning = Color(0xFFFDAA5D);
  static const Color warningLight = Color(0xFFFECE7C);
  static const Color info = Color(0xFF74B9FF);
  static const Color infoLight = Color(0xFFA8D8FF);

  // ===== ألوان اللعبة =====
  static const Color gridBackground = Color(0xFF2D3436);
  static const Color gridCellDefault = Color(0xFFF8F9FA);
  static const Color gridCellSelected = Color(0xFF6C5CE7);
  static const Color gridCellSelectedGlow = Color(0xFF9D8DF7);
  static const Color gridCellFound = Color(0xFF00B894);
  static const Color gridCellFoundGlow = Color(0xFF55EFC4);
  static const Color gridCellHint = Color(0xFFFDAA5D);
  static const Color gridLetterDefault = Color(0xFF2D3436);
  static const Color gridLetterSelected = Color(0xFFFFFFFF);
  static const Color gridLetterFound = Color(0xFFFFFFFF);

  static const Color selectionLine = Color(0xFF6C5CE7);
  static const Color selectionLineGlow = Color(0x809D8DF7);

  // ===== ألوان التلميحات والنقاط =====
  static const Color hintColor = Color(0xFFFDAA5D);
  static const Color hintGlow = Color(0xFFFECE7C);
  static const Color scoreColor = Color(0xFF00CEC9);
  static const Color scoreGlow = Color(0xFF55EFC4);
  static const Color coinColor = Color(0xFFFFD700);
  static const Color coinGlow = Color(0xFFFFE66D);

  // ===== ألوان المستويات =====
  static const Color levelCompleted = Color(0xFF00B894);
  static const Color levelCompletedGlow = Color(0xFF55EFC4);
  static const Color levelCurrent = Color(0xFFFDAA5D);
  static const Color levelCurrentGlow = Color(0xFFFECE7C);
  static const Color levelLocked = Color(0xFFB2BEC3);
  static const Color levelLockedDark = Color(0xFF636E72);
  static const Color levelPath = Color(0xFFDFE6E9);
  static const Color levelPathActive = Color(0xFF6C5CE7);

  // ===== ألوان النجوم =====
  static const Color starFilled = Color(0xFFFFD700);
  static const Color starEmpty = Color(0xFFDFE6E9);
  static const Color starGlow = Color(0xFFFFE66D);

  // ===== تدرجات الألوان الرئيسية =====
  static const List<Color> primaryGradient = [
    Color(0xFF6C5CE7),
    Color(0xFF4834D4),
  ];

  static const List<Color> primarySoftGradient = [
    Color(0xFF9D8DF7),
    Color(0xFF6C5CE7),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFF00CEC9),
    Color(0xFF00B894),
  ];

  static const List<Color> accentGradient = [
    Color(0xFFFF7675),
    Color(0xFFD63031),
  ];

  // ===== تدرجات الخلفية =====
  static const List<Color> backgroundGradient = [
    Color(0xFF667EEA),
    Color(0xFF764BA2),
  ];

  static const List<Color> backgroundGradientSoft = [
    Color(0xFFF8F9FA),
    Color(0xFFE8EEF7),
    Color(0xFFF0E6F5),
  ];

  static const List<Color> backgroundGradientDark = [
    Color(0xFF1E272E),
    Color(0xFF2D3436),
  ];

  static const List<Color> sunsetGradient = [
    Color(0xFFFF7E5F),
    Color(0xFFFEB47B),
  ];

  static const List<Color> oceanGradient = [
    Color(0xFF667EEA),
    Color(0xFF64B5F6),
  ];

  static const List<Color> forestGradient = [
    Color(0xFF11998E),
    Color(0xFF38EF7D),
  ];

  static const List<Color> nightGradient = [
    Color(0xFF232526),
    Color(0xFF414345),
  ];

  // ===== تدرجات اللعبة =====
  static const List<Color> hintGradient = [
    Color(0xFFFECE7C),
    Color(0xFFFDAA5D),
  ];

  static const List<Color> scoreGradient = [
    Color(0xFF55EFC4),
    Color(0xFF00B894),
  ];

  static const List<Color> successGradient = [
    Color(0xFF55EFC4),
    Color(0xFF00B894),
  ];

  static const List<Color> warningGradient = [
    Color(0xFFFECE7C),
    Color(0xFFFDAA5D),
  ];

  static const List<Color> errorGradient = [
    Color(0xFFFF7675),
    Color(0xFFD63031),
  ];

  // ===== تدرجات خاصة =====
  static const List<Color> goldGradient = [
    Color(0xFFFFD700),
    Color(0xFFFFA500),
  ];

  static const List<Color> silverGradient = [
    Color(0xFFE8E8E8),
    Color(0xFFBDBDBD),
  ];

  static const List<Color> bronzeGradient = [
    Color(0xFFCD7F32),
    Color(0xFF8B4513),
  ];

  static const List<Color> rainbowGradient = [
    Color(0xFFFF6B6B),
    Color(0xFFFECA57),
    Color(0xFF48DBFB),
    Color(0xFF6C5CE7),
  ];

  // ===== ألوان الظلال =====
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);
  static const Color shadowPrimary = Color(0x406C5CE7);
  static const Color shadowSecondary = Color(0x4000CEC9);
  static const Color shadowAccent = Color(0x40FF7675);

  // ===== ألوان الحدود =====
  static const Color borderLight = Color(0xFFE8E8E8);
  static const Color borderMedium = Color(0xFFDFE6E9);
  static const Color borderDark = Color(0xFFB2BEC3);

  // ===== ألوان Shimmer =====
  static const Color shimmerBase = Color(0xFFE8E8E8);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
}
