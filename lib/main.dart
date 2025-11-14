import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jumal/app.dart';

import 'core/services/game_progress_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Hive
  await initHive();

  // قفل الشاشة في الوضع العمودي
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const JumalApp());
}
