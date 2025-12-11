import 'package:hive_ce_flutter/adapters.dart';
import '../../core/constants/app_constants.dart';
import 'level_progress_model.dart';

/// نموذج تقدم اللعبة
@HiveType(typeId: HiveTypeIds.gameProgress)
class GameProgressModel extends HiveObject {
  @HiveField(0)
  int currentLevel;

  @HiveField(1)
  int totalScore;

  @HiveField(2)
  Map<int, LevelProgressModel> completedLevels;

  @HiveField(3)
  DateTime lastPlayed;

  @HiveField(4)
  int totalPlayTime; // بالثواني

  @HiveField(5)
  int hintsRemaining;

  GameProgressModel({
    this.currentLevel = 1,
    this.totalScore = 0,
    Map<int, LevelProgressModel>? completedLevels,
    DateTime? lastPlayed,
    this.totalPlayTime = 0,
    int? hintsRemaining,
  })  : completedLevels = completedLevels ?? {},
        lastPlayed = lastPlayed ?? DateTime.now(),
        hintsRemaining = hintsRemaining ?? AppConstants.initialHints;

  /// نسخ مع تعديلات
  GameProgressModel copyWith({
    int? currentLevel,
    int? totalScore,
    Map<int, LevelProgressModel>? completedLevels,
    DateTime? lastPlayed,
    int? totalPlayTime,
    int? hintsRemaining,
  }) {
    return GameProgressModel(
      currentLevel: currentLevel ?? this.currentLevel,
      totalScore: totalScore ?? this.totalScore,
      completedLevels: completedLevels ?? this.completedLevels,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      totalPlayTime: totalPlayTime ?? this.totalPlayTime,
      hintsRemaining: hintsRemaining ?? this.hintsRemaining,
    );
  }

  /// عدد المستويات المكتملة
  int get levelsCompleted => completedLevels.length;

  /// عدد المستويات بـ 3 نجوم
  int get perfectLevels =>
      completedLevels.values.where((level) => level.stars == 3).length;

  /// متوسط النقاط
  int get averageScore =>
      levelsCompleted > 0 ? (totalScore / levelsCompleted).round() : 0;
}

/// محول Hive لـ GameProgressModel
class GameProgressModelAdapter extends TypeAdapter<GameProgressModel> {
  @override
  final int typeId = HiveTypeIds.gameProgress;

  @override
  GameProgressModel read(BinaryReader reader) {
    return GameProgressModel(
      currentLevel: reader.readInt(),
      totalScore: reader.readInt(),
      completedLevels: Map<int, LevelProgressModel>.from(reader.readMap()),
      lastPlayed: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      totalPlayTime: reader.readInt(),
      hintsRemaining: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, GameProgressModel obj) {
    writer.writeInt(obj.currentLevel);
    writer.writeInt(obj.totalScore);
    writer.writeMap(obj.completedLevels);
    writer.writeInt(obj.lastPlayed.millisecondsSinceEpoch);
    writer.writeInt(obj.totalPlayTime);
    writer.writeInt(obj.hintsRemaining);
  }
}
