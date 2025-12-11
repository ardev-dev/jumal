import 'package:flutter/services.dart';

/// أدوات الاهتزاز اللمسي
abstract final class HapticUtils {
  /// اهتزاز خفيف - للتفاعلات البسيطة
  static void lightImpact() {
    HapticFeedback.lightImpact();
  }

  /// اهتزاز متوسط - للنجاح
  static void mediumImpact() {
    HapticFeedback.mediumImpact();
  }

  /// اهتزاز قوي - للأخطاء أو الإنجازات
  static void heavyImpact() {
    HapticFeedback.heavyImpact();
  }

  /// اهتزاز اختيار
  static void selectionClick() {
    HapticFeedback.selectionClick();
  }
}
