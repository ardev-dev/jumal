import 'package:hive_ce_flutter/adapters.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/game_progress_model.dart';
import '../../models/level_progress_model.dart';

/// مصدر البيانات المحلي للتقدم
abstract interface class ProgressLocalDataSource {
  /// الحصول على التقدم
  GameProgressModel getProgress();

  /// حفظ التقدم
  Future<void> saveProgress(GameProgressModel progress);

  /// حذف التقدم
  Future<void> clearProgress();

  /// الحصول على إعداد
  T? getSetting<T>(String key, {T? defaultValue});

  /// حفظ إعداد
  Future<void> setSetting<T>(String key, T value);

  /// إغلاق الاتصال
  Future<void> close();
}

/// التنفيذ الافتراضي لمصدر البيانات المحلي للتقدم
class ProgressLocalDataSourceImpl implements ProgressLocalDataSource {
  final Box<GameProgressModel> _progressBox;
  final Box _settingsBox;

  ProgressLocalDataSourceImpl({
    required Box<GameProgressModel> progressBox,
    required Box settingsBox,
  })  : _progressBox = progressBox,
        _settingsBox = settingsBox;

  @override
  GameProgressModel getProgress() {
    return _progressBox.get(StorageKeys.progressKey) ?? GameProgressModel();
  }

  @override
  Future<void> saveProgress(GameProgressModel progress) async {
    await _progressBox.put(StorageKeys.progressKey, progress);
  }

  @override
  Future<void> clearProgress() async {
    await _progressBox.clear();
  }

  @override
  T? getSetting<T>(String key, {T? defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue) as T?;
  }

  @override
  Future<void> setSetting<T>(String key, T value) async {
    await _settingsBox.put(key, value);
  }

  @override
  Future<void> close() async {
    await _progressBox.close();
    await _settingsBox.close();
  }
}

/// تهيئة Hive
class HiveInitializer {
  static Future<ProgressLocalDataSource> initialize() async {
    await Hive.initFlutter();

    // تسجيل المحولات
    if (!Hive.isAdapterRegistered(HiveTypeIds.gameProgress)) {
      Hive.registerAdapter(GameProgressModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTypeIds.levelProgress)) {
      Hive.registerAdapter(LevelProgressModelAdapter());
    }

    // فتح الصناديق
    final progressBox = await Hive.openBox<GameProgressModel>(StorageKeys.progressBox);
    final settingsBox = await Hive.openBox(StorageKeys.settingsBox);

    return ProgressLocalDataSourceImpl(
      progressBox: progressBox,
      settingsBox: settingsBox,
    );
  }
}
