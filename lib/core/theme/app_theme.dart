import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';

/// ثيم التطبيق الاحترافي
abstract final class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      fontFamily: 'Cairo',
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        iconTheme: IconThemeData(
          color: AppColors.textPrimary,
          size: 24,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textLight,
          elevation: 8,
          shadowColor: AppColors.shadowPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusXL),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusXL),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        ),
      ),
      dialogTheme: DialogThemeData(
        elevation: 24,
        shadowColor: AppColors.shadowDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        ),
        backgroundColor: AppColors.surface,
        titleTextStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        contentTextStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          color: AppColors.textSecondary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 8,
        shadowColor: AppColors.shadowLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        ),
        color: AppColors.cardBackground,
        margin: EdgeInsets.zero,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimens.radiusXL),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.backgroundDark,
        contentTextStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          color: AppColors.textLight,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        ),
        elevation: 8,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.textTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryLight;
          }
          return AppColors.borderMedium;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.textLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.borderLight,
        circularTrackColor: AppColors.borderLight,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: 24,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingMD,
          vertical: AppDimens.paddingMD,
        ),
        hintStyle: const TextStyle(
          fontFamily: 'Cairo',
          color: AppColors.textTertiary,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primaryLight,
        secondary: AppColors.secondaryLight,
        surface: AppColors.backgroundDark,
        error: AppColors.errorLight,
      ),
      fontFamily: 'Cairo',
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textOnDark,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textOnDark,
        ),
      ),
    );
  }
}

/// أنماط النصوص الاحترافية
abstract final class AppTextStyles {
  // العناوين
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
    height: 1.2,
  );

  static const TextStyle headline1 = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
    shadows: [
      Shadow(
        color: Colors.black26,
        offset: Offset(2, 2),
        blurRadius: 4,
      ),
    ],
  );

  static const TextStyle headline2 = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline3 = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline4 = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // النصوص العادية
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // التسميات
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
    letterSpacing: 0.5,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // الأزرار
  static const TextStyle button = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
    letterSpacing: 0.5,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textLight,
  );

  // أنماط اللعبة
  static const TextStyle levelNumber = TextStyle(
    fontFamily: 'Cairo',
    color: Colors.white,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(
        color: Colors.black38,
        offset: Offset(1, 2),
        blurRadius: 4,
      ),
    ],
  );

  static const TextStyle gridLetter = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.gridLetterDefault,
  );

  static const TextStyle gridLetterSelected = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.gridLetterSelected,
  );

  static const TextStyle score = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
  );

  static const TextStyle timer = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textLight,
  );

  static const TextStyle questionText = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle questionTextFound = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.success,
    decoration: TextDecoration.lineThrough,
    decorationColor: AppColors.success,
    height: 1.4,
  );

  // النصوص المضيئة
  static TextStyle glowText({
    double fontSize = 24,
    Color color = AppColors.textLight,
    Color glowColor = AppColors.primaryLight,
  }) {
    return TextStyle(
      fontFamily: 'Cairo',
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
      shadows: [
        Shadow(
          color: glowColor.withValues(alpha: 0.8),
          blurRadius: 10,
        ),
        Shadow(
          color: glowColor.withValues(alpha: 0.5),
          blurRadius: 20,
        ),
      ],
    );
  }
}

/// أحجام الحواف والمسافات
abstract final class AppDimens {
  // ===== المسافات =====
  static const double paddingXXS = 2.0;
  static const double paddingXS = 4.0;
  static const double paddingSM = 8.0;
  static const double paddingMD = 16.0;
  static const double paddingLG = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // ===== الحواف المستديرة =====
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusXXL = 32.0;
  static const double radiusCircle = 100.0;

  // ===== أحجام الأيقونات =====
  static const double iconXS = 12.0;
  static const double iconSM = 16.0;
  static const double iconMD = 24.0;
  static const double iconLG = 32.0;
  static const double iconXL = 40.0;
  static const double iconXXL = 56.0;

  // ===== أحجام خلايا الشبكة =====
  static const double gridCellMargin = 4.0;
  static const double gridCellRadius = 12.0;
  static const double gridCellMinSize = 40.0;
  static const double gridCellMaxSize = 60.0;

  // ===== أحجام الأزرار =====
  static const double buttonHeightSM = 40.0;
  static const double buttonHeight = 52.0;
  static const double buttonHeightLG = 60.0;
  static const double fabSize = 64.0;
  static const double fabSizeLG = 80.0;

  // ===== أحجام المستويات =====
  static const double levelNodeSize = 72.0;
  static const double levelNodeSizeLG = 88.0;
  static const double levelPathWidth = 4.0;
  static const double levelStarSize = 20.0;

  // ===== الظلال =====
  static const double shadowBlurSM = 4.0;
  static const double shadowBlurMD = 8.0;
  static const double shadowBlurLG = 16.0;
  static const double shadowBlurXL = 24.0;

  // ===== الارتفاعات =====
  static const double elevationSM = 2.0;
  static const double elevationMD = 4.0;
  static const double elevationLG = 8.0;
  static const double elevationXL = 16.0;

  // ===== أحجام الشاشات =====
  static const double maxContentWidth = 600.0;
  static const double dialogMaxWidth = 400.0;
  static const double cardMaxWidth = 350.0;
}

/// ظلال مخصصة
abstract final class AppShadows {
  static List<BoxShadow> get small => [
        BoxShadow(
          color: AppColors.shadowLight,
          blurRadius: AppDimens.shadowBlurSM,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get medium => [
        BoxShadow(
          color: AppColors.shadowMedium,
          blurRadius: AppDimens.shadowBlurMD,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get large => [
        BoxShadow(
          color: AppColors.shadowMedium,
          blurRadius: AppDimens.shadowBlurLG,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get extraLarge => [
        BoxShadow(
          color: AppColors.shadowDark,
          blurRadius: AppDimens.shadowBlurXL,
          offset: const Offset(0, 12),
        ),
      ];

  static List<BoxShadow> glow(Color color, {double blur = 20}) => [
        BoxShadow(
          color: color.withValues(alpha: 0.4),
          blurRadius: blur,
          spreadRadius: 2,
        ),
      ];

  static List<BoxShadow> coloredShadow(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.3),
          blurRadius: AppDimens.shadowBlurLG,
          offset: const Offset(0, 8),
        ),
      ];
}

/// تدرجات مخصصة
abstract final class AppGradients {
  static LinearGradient primary({
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) =>
      LinearGradient(
        colors: AppColors.primaryGradient,
        begin: begin,
        end: end,
      );

  static LinearGradient secondary({
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) =>
      LinearGradient(
        colors: AppColors.secondaryGradient,
        begin: begin,
        end: end,
      );

  static LinearGradient background({
    AlignmentGeometry begin = Alignment.topCenter,
    AlignmentGeometry end = Alignment.bottomCenter,
  }) =>
      LinearGradient(
        colors: AppColors.backgroundGradient,
        begin: begin,
        end: end,
      );

  static LinearGradient glass({
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) =>
      LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.2),
          Colors.white.withValues(alpha: 0.1),
        ],
        begin: begin,
        end: end,
      );

  static RadialGradient radialGlow(Color color) => RadialGradient(
        colors: [
          color.withValues(alpha: 0.6),
          color.withValues(alpha: 0.0),
        ],
      );
}

/// حدود مخصصة
abstract final class AppBorders {
  static Border light = Border.all(
    color: AppColors.borderLight,
    width: 1,
  );

  static Border medium = Border.all(
    color: AppColors.borderMedium,
    width: 1,
  );

  static Border primary = Border.all(
    color: AppColors.primary,
    width: 2,
  );

  static BorderRadius get radiusSM => BorderRadius.circular(AppDimens.radiusSM);
  static BorderRadius get radiusMD => BorderRadius.circular(AppDimens.radiusMD);
  static BorderRadius get radiusLG => BorderRadius.circular(AppDimens.radiusLG);
  static BorderRadius get radiusXL => BorderRadius.circular(AppDimens.radiusXL);
  static BorderRadius get circle => BorderRadius.circular(AppDimens.radiusCircle);
}
