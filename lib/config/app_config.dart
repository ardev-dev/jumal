import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/service_locator.dart';

/// إعدادات التطبيق
abstract final class AppConfig {
  /// تهيئة التطبيق
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // تهيئة الخدمات
    await ServiceLocator.instance.initialize();

    // قفل الشاشة في الوضع العمودي
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// تنظيف الموارد عند إغلاق التطبيق
  static Future<void> dispose() async {
    await ServiceLocator.instance.dispose();
  }
}
