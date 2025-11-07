import 'package:hive_ce_flutter/adapters.dart';

late GameProgressService progressService;

Future<void> initHive() async {
  await Hive.initFlutter();
  
  // تسجيل الـ Adapters
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(GameProgressAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(LevelProgressAdapter());
  }

  final Box<GameProgress> progressBox = await Hive.openBox<GameProgress>('game_progress');
  final Box settingsBox = await Hive.openBox('settings');

  progressService = GameProgressService(progressBox, settingsBox);
}

// ========================================
// نماذج البيانات (Models)
// ========================================

@HiveType(typeId: 0)
class GameProgress extends HiveObject {
  @HiveField(0)
  int currentLevel;

  @HiveField(1)
  int totalScore;

  @HiveField(2)
  Map<int, LevelProgress> completedLevels;

  @HiveField(3)
  DateTime lastPlayed;

  @HiveField(4)
  int totalPlayTime; // بالثواني

  @HiveField(5)
  int hintsRemaining;

  GameProgress({
    this.currentLevel = 1,
    this.totalScore = 0,
    Map<int, LevelProgress>? completedLevels,
    DateTime? lastPlayed,
    this.totalPlayTime = 0,
    this.hintsRemaining = 3,
  })  : completedLevels = completedLevels ?? {},
        lastPlayed = lastPlayed ?? DateTime.now();
}

@HiveType(typeId: 1)
class LevelProgress {
  @HiveField(0)
  int levelNumber;

  @HiveField(1)
  int score;

  @HiveField(2)
  int stars; // 1-3 نجوم

  @HiveField(3)
  List<String> foundWords;

  @HiveField(4)
  DateTime completedAt;

  @HiveField(5)
  int timeSpent; // بالثواني

  @HiveField(6)
  bool usedHints;

  LevelProgress({
    required this.levelNumber,
    required this.score,
    required this.stars,
    required this.foundWords,
    required this.completedAt,
    required this.timeSpent,
    this.usedHints = false,
  });
}

// ========================================
// Hive Adapters
// ========================================

class GameProgressAdapter extends TypeAdapter<GameProgress> {
  @override
  final int typeId = 0;

  @override
  GameProgress read(BinaryReader reader) {
    return GameProgress(
      currentLevel: reader.readInt(),
      totalScore: reader.readInt(),
      completedLevels: Map<int, LevelProgress>.from(reader.readMap()),
      lastPlayed: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      totalPlayTime: reader.readInt(),
      hintsRemaining: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, GameProgress obj) {
    writer.writeInt(obj.currentLevel);
    writer.writeInt(obj.totalScore);
    writer.writeMap(obj.completedLevels);
    writer.writeInt(obj.lastPlayed.millisecondsSinceEpoch);
    writer.writeInt(obj.totalPlayTime);
    writer.writeInt(obj.hintsRemaining);
  }
}

class LevelProgressAdapter extends TypeAdapter<LevelProgress> {
  @override
  final int typeId = 1;

  @override
  LevelProgress read(BinaryReader reader) {
    return LevelProgress(
      levelNumber: reader.readInt(),
      score: reader.readInt(),
      stars: reader.readInt(),
      foundWords: reader.readStringList(),
      completedAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      timeSpent: reader.readInt(),
      usedHints: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, LevelProgress obj) {
    writer.writeInt(obj.levelNumber);
    writer.writeInt(obj.score);
    writer.writeInt(obj.stars);
    writer.writeStringList(obj.foundWords);
    writer.writeInt(obj.completedAt.millisecondsSinceEpoch);
    writer.writeInt(obj.timeSpent);
    writer.writeBool(obj.usedHints);
  }
}

// ========================================
// خدمة إدارة التقدم
// ========================================

class GameProgressService {
  final Box<GameProgress> _progressBox;
  final Box _settingsBox;
  
  static const String _progressKey = 'main_progress';
  static const String _soundKey = 'sound_enabled';
  static const String _musicKey = 'music_enabled';
  static const String _vibrationKey = 'vibration_enabled';

  GameProgressService(this._progressBox, this._settingsBox);

  // ========================================
  // إدارة التقدم
  // ========================================

  GameProgress getProgress() {
    return _progressBox.get(_progressKey) ?? GameProgress();
  }

  Future<void> saveProgress(GameProgress progress) async {
    progress.lastPlayed = DateTime.now();
    await _progressBox.put(_progressKey, progress);
  }

  Future<void> updateCurrentLevel(int level) async {
    final progress = getProgress();
    progress.currentLevel = level;
    await saveProgress(progress);
  }

  Future<void> addScore(int score) async {
    final progress = getProgress();
    progress.totalScore += score;
    await saveProgress(progress);
  }

  Future<void> completeLevel({
    required int levelNumber,
    required int score,
    required List<String> foundWords,
    required int timeSpent,
    required bool usedHints,
  }) async {
    final progress = getProgress();
    
    // حساب النجوم بناءً على الأداء
    int stars = _calculateStars(score, timeSpent, usedHints);
    
    final levelProgress = LevelProgress(
      levelNumber: levelNumber,
      score: score,
      stars: stars,
      foundWords: foundWords,
      completedAt: DateTime.now(),
      timeSpent: timeSpent,
      usedHints: usedHints,
    );

    // تحديث أو إضافة تقدم المستوى
    final existingProgress = progress.completedLevels[levelNumber];
    if (existingProgress == null || score > existingProgress.score) {
      progress.completedLevels[levelNumber] = levelProgress;
      progress.totalScore += score;
    }

    // التقدم للمستوى التالي
    if (levelNumber == progress.currentLevel) {
      progress.currentLevel = levelNumber + 1;
    }

    progress.totalPlayTime += timeSpent;
    
    await saveProgress(progress);
  }

  int _calculateStars(int score, int timeSpent, bool usedHints) {
    if (usedHints) return 2;
    if (timeSpent < 30 && score > 100) return 3;
    if (timeSpent < 60) return 3;
    if (score > 80) return 2;
    return 1;
  }

  Future<void> useHint() async {
    final progress = getProgress();
    if (progress.hintsRemaining > 0) {
      progress.hintsRemaining--;
      await saveProgress(progress);
    }
  }

  Future<void> addHints(int count) async {
    final progress = getProgress();
    progress.hintsRemaining += count;
    await saveProgress(progress);
  }

  // ========================================
  // إحصائيات اللعبة
  // ========================================

  Map<String, dynamic> getStatistics() {
    final progress = getProgress();
    
    int totalLevelsCompleted = progress.completedLevels.length;
    int total3Stars = progress.completedLevels.values
        .where((level) => level.stars == 3)
        .length;
    
    double averageScore = totalLevelsCompleted > 0
        ? progress.totalScore / totalLevelsCompleted
        : 0;

    return {
      'currentLevel': progress.currentLevel,
      'totalScore': progress.totalScore,
      'levelsCompleted': totalLevelsCompleted,
      'perfectLevels': total3Stars,
      'totalPlayTime': progress.totalPlayTime,
      'hintsRemaining': progress.hintsRemaining,
      'averageScore': averageScore.round(),
      'lastPlayed': progress.lastPlayed,
    };
  }

  LevelProgress? getLevelProgress(int levelNumber) {
    final progress = getProgress();
    return progress.completedLevels[levelNumber];
  }

  bool isLevelCompleted(int levelNumber) {
    return getLevelProgress(levelNumber) != null;
  }

  Set<int> getCompletedLevels() {
    return getProgress().completedLevels.keys.toSet();
  }

  // ========================================
  // الإعدادات
  // ========================================

  bool get isSoundEnabled => _settingsBox.get(_soundKey, defaultValue: true);
  bool get isMusicEnabled => _settingsBox.get(_musicKey, defaultValue: true);
  bool get isVibrationEnabled => _settingsBox.get(_vibrationKey, defaultValue: true);

  Future<void> setSoundEnabled(bool enabled) async {
    await _settingsBox.put(_soundKey, enabled);
  }

  Future<void> setMusicEnabled(bool enabled) async {
    await _settingsBox.put(_musicKey, enabled);
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    await _settingsBox.put(_vibrationKey, enabled);
  }

  // ========================================
  // إدارة البيانات
  // ========================================

  Future<void> resetProgress() async {
    await _progressBox.clear();
    await saveProgress(GameProgress());
  }

  Future<void> importProgress(GameProgress progress) async {
    await saveProgress(progress);
  }

  Future<void> close() async {
    await _progressBox.close();
    await _settingsBox.close();
  }

  // ========================================
  // مكافآت يومية
  // ========================================

  Future<bool> claimDailyReward() async {
    final progress = getProgress();
    final lastPlayed = progress.lastPlayed;
    final now = DateTime.now();
    
    final difference = now.difference(lastPlayed);
    
    if (difference.inHours >= 24) {
      // إضافة مكافأة
      progress.hintsRemaining += 2;
      progress.totalScore += 50;
      await saveProgress(progress);
      return true;
    }
    
    return false;
  }

  Duration getTimeUntilNextReward() {
    final progress = getProgress();
    final lastPlayed = progress.lastPlayed;
    final nextReward = lastPlayed.add(const Duration(hours: 24));
    final now = DateTime.now();
    
    if (now.isAfter(nextReward)) {
      return Duration.zero;
    }
    
    return nextReward.difference(now);
  }
}