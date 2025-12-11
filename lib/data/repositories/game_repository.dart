import '../datasources/local/levels_local_datasource.dart';
import '../datasources/local/progress_local_datasource.dart';
import '../models/game_progress_model.dart';
import '../models/level_data_model.dart';
import '../models/level_progress_model.dart';
import '../../core/constants/app_constants.dart';

/// واجهة مستودع اللعبة
abstract interface class GameRepository {
  // المستويات
  Map<int, LevelDataModel> getAllLevels();
  LevelDataModel? getLevel(int levelNumber);
  int getTotalLevels();
  bool levelExists(int levelNumber);

  // التقدم
  GameProgressModel getProgress();
  Future<void> saveProgress(GameProgressModel progress);
  Future<void> updateCurrentLevel(int level);
  Future<void> addScore(int score);
  Future<void> completeLevel({
    required int levelNumber,
    required int score,
    required List<String> foundWords,
    required int timeSpent,
    required bool usedHints,
  });
  Future<void> useHint();
  Future<void> addHints(int count);
  Future<void> resetProgress();

  // الإحصائيات
  Map<String, dynamic> getStatistics();
  LevelProgressModel? getLevelProgress(int levelNumber);
  bool isLevelCompleted(int levelNumber);
  Set<int> getCompletedLevels();

  // الإعدادات
  bool get isSoundEnabled;
  bool get isMusicEnabled;
  bool get isVibrationEnabled;
  Future<void> setSoundEnabled(bool enabled);
  Future<void> setMusicEnabled(bool enabled);
  Future<void> setVibrationEnabled(bool enabled);

  // المكافآت اليومية
  Future<bool> claimDailyReward();
  Duration getTimeUntilNextReward();

  // التنظيف
  Future<void> close();
}

/// التنفيذ الافتراضي لمستودع اللعبة
class GameRepositoryImpl implements GameRepository {
  final LevelsLocalDataSource _levelsDataSource;
  final ProgressLocalDataSource _progressDataSource;

  GameRepositoryImpl({
    required LevelsLocalDataSource levelsDataSource,
    required ProgressLocalDataSource progressDataSource,
  })  : _levelsDataSource = levelsDataSource,
        _progressDataSource = progressDataSource;

  // =====================
  // المستويات
  // =====================

  @override
  Map<int, LevelDataModel> getAllLevels() {
    return _levelsDataSource.getAllLevels();
  }

  @override
  LevelDataModel? getLevel(int levelNumber) {
    return _levelsDataSource.getLevel(levelNumber);
  }

  @override
  int getTotalLevels() {
    return _levelsDataSource.getTotalLevels();
  }

  @override
  bool levelExists(int levelNumber) {
    return _levelsDataSource.levelExists(levelNumber);
  }

  // =====================
  // التقدم
  // =====================

  @override
  GameProgressModel getProgress() {
    return _progressDataSource.getProgress();
  }

  @override
  Future<void> saveProgress(GameProgressModel progress) async {
    progress.lastPlayed = DateTime.now();
    await _progressDataSource.saveProgress(progress);
  }

  @override
  Future<void> updateCurrentLevel(int level) async {
    final progress = getProgress();
    progress.currentLevel = level;
    await saveProgress(progress);
  }

  @override
  Future<void> addScore(int score) async {
    final progress = getProgress();
    progress.totalScore += score;
    await saveProgress(progress);
  }

  @override
  Future<void> completeLevel({
    required int levelNumber,
    required int score,
    required List<String> foundWords,
    required int timeSpent,
    required bool usedHints,
  }) async {
    final progress = getProgress();

    // حساب النجوم
    final stars = _calculateStars(score, timeSpent, usedHints);

    final levelProgress = LevelProgressModel(
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
    if (timeSpent < AppConstants.fastCompletionThreshold &&
        score > AppConstants.highScoreThreshold) {
      return 3;
    }
    if (timeSpent < AppConstants.mediumCompletionThreshold) return 3;
    if (score > AppConstants.mediumScoreThreshold) return 2;
    return 1;
  }

  @override
  Future<void> useHint() async {
    final progress = getProgress();
    if (progress.hintsRemaining > 0) {
      progress.hintsRemaining--;
      await saveProgress(progress);
    }
  }

  @override
  Future<void> addHints(int count) async {
    final progress = getProgress();
    progress.hintsRemaining += count;
    await saveProgress(progress);
  }

  @override
  Future<void> resetProgress() async {
    await _progressDataSource.clearProgress();
    await saveProgress(GameProgressModel());
  }

  // =====================
  // الإحصائيات
  // =====================

  @override
  Map<String, dynamic> getStatistics() {
    final progress = getProgress();

    return {
      'currentLevel': progress.currentLevel,
      'totalScore': progress.totalScore,
      'levelsCompleted': progress.levelsCompleted,
      'perfectLevels': progress.perfectLevels,
      'totalPlayTime': progress.totalPlayTime,
      'hintsRemaining': progress.hintsRemaining,
      'averageScore': progress.averageScore,
      'lastPlayed': progress.lastPlayed,
    };
  }

  @override
  LevelProgressModel? getLevelProgress(int levelNumber) {
    return getProgress().completedLevels[levelNumber];
  }

  @override
  bool isLevelCompleted(int levelNumber) {
    return getLevelProgress(levelNumber) != null;
  }

  @override
  Set<int> getCompletedLevels() {
    return getProgress().completedLevels.keys.toSet();
  }

  // =====================
  // الإعدادات
  // =====================

  @override
  bool get isSoundEnabled =>
      _progressDataSource.getSetting<bool>(StorageKeys.soundKey, defaultValue: true) ?? true;

  @override
  bool get isMusicEnabled =>
      _progressDataSource.getSetting<bool>(StorageKeys.musicKey, defaultValue: true) ?? true;

  @override
  bool get isVibrationEnabled =>
      _progressDataSource.getSetting<bool>(StorageKeys.vibrationKey, defaultValue: true) ?? true;

  @override
  Future<void> setSoundEnabled(bool enabled) async {
    await _progressDataSource.setSetting(StorageKeys.soundKey, enabled);
  }

  @override
  Future<void> setMusicEnabled(bool enabled) async {
    await _progressDataSource.setSetting(StorageKeys.musicKey, enabled);
  }

  @override
  Future<void> setVibrationEnabled(bool enabled) async {
    await _progressDataSource.setSetting(StorageKeys.vibrationKey, enabled);
  }

  // =====================
  // المكافآت اليومية
  // =====================

  @override
  Future<bool> claimDailyReward() async {
    final progress = getProgress();
    final lastPlayed = progress.lastPlayed;
    final now = DateTime.now();

    final difference = now.difference(lastPlayed);

    if (difference.inHours >= AppConstants.dailyRewardHours) {
      progress.hintsRemaining += AppConstants.dailyRewardHints;
      progress.totalScore += AppConstants.dailyRewardScore;
      await saveProgress(progress);
      return true;
    }

    return false;
  }

  @override
  Duration getTimeUntilNextReward() {
    final progress = getProgress();
    final lastPlayed = progress.lastPlayed;
    final nextReward = lastPlayed.add(const Duration(hours: AppConstants.dailyRewardHours));
    final now = DateTime.now();

    if (now.isAfter(nextReward)) {
      return Duration.zero;
    }

    return nextReward.difference(now);
  }

  // =====================
  // التنظيف
  // =====================

  @override
  Future<void> close() async {
    await _progressDataSource.close();
  }
}
