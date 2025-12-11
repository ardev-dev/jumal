/// ثوابت التطبيق العامة
abstract final class AppConstants {
  // معلومات التطبيق
  static const String appName = 'جُمَل';
  static const String appTitle = 'لعبة البحث عن الكلمات';
  static const String appVersion = '1.0.0';

  // إعدادات اللعبة
  static const int initialHints = 3;
  static const int dailyRewardHints = 2;
  static const int dailyRewardScore = 50;
  static const int totalLevels = 14;

  // إعدادات الوقت
  static const int splashDuration = 3; // ثواني
  static const int dailyRewardHours = 24;

  // إعدادات النقاط
  static const int scorePerLetter = 10;
  static const int fastCompletionThreshold = 30; // ثواني
  static const int mediumCompletionThreshold = 60; // ثواني
  static const int highScoreThreshold = 100;
  static const int mediumScoreThreshold = 80;
}

/// مفاتيح التخزين المحلي
abstract final class StorageKeys {
  static const String progressBox = 'game_progress';
  static const String settingsBox = 'settings';
  static const String progressKey = 'main_progress';
  static const String soundKey = 'sound_enabled';
  static const String musicKey = 'music_enabled';
  static const String vibrationKey = 'vibration_enabled';
}

/// معرفات Hive Type
abstract final class HiveTypeIds {
  static const int gameProgress = 0;
  static const int levelProgress = 1;
}
