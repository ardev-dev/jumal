import 'package:flutter/material.dart';
import 'app.dart';
import 'config/app_config.dart';

void main() async {
  // تهيئة التطبيق
  await AppConfig.initialize();

  // تشغيل التطبيق
  runApp(const JumalApp());
}
