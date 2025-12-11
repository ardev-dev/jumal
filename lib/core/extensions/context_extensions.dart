import 'package:flutter/material.dart';

/// امتدادات BuildContext
extension ContextExtensions on BuildContext {
  /// الحصول على حجم الشاشة
  Size get screenSize => MediaQuery.sizeOf(this);

  /// الحصول على عرض الشاشة
  double get screenWidth => screenSize.width;

  /// الحصول على ارتفاع الشاشة
  double get screenHeight => screenSize.height;

  /// الحصول على اتجاه النص
  TextDirection get textDirection => Directionality.of(this);

  /// هل الاتجاه من اليمين لليسار
  bool get isRTL => textDirection == TextDirection.rtl;

  /// الحصول على الثيم
  ThemeData get theme => Theme.of(this);

  /// الحصول على ColorScheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// الحصول على TextTheme
  TextTheme get textTheme => theme.textTheme;

  /// إظهار SnackBar
  void showSnackBar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// إظهار SnackBar للنجاح
  void showSuccessSnackBar(String message) {
    showSnackBar(message, backgroundColor: Colors.green);
  }

  /// إظهار SnackBar للخطأ
  void showErrorSnackBar(String message) {
    showSnackBar(message, backgroundColor: Colors.red);
  }

  /// الرجوع للصفحة السابقة
  void pop<T>([T? result]) => Navigator.pop(this, result);

  /// الانتقال لصفحة جديدة
  Future<T?> push<T>(Widget page) {
    return Navigator.push<T>(
      this,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// استبدال الصفحة الحالية
  Future<T?> pushReplacement<T>(Widget page) {
    return Navigator.pushReplacement<T, void>(
      this,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}
