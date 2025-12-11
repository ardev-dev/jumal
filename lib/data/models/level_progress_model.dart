import 'package:hive_ce_flutter/adapters.dart';
import '../../core/constants/app_constants.dart';

/// نموذج تقدم المستوى
@HiveType(typeId: HiveTypeIds.levelProgress)
class LevelProgressModel {
  @HiveField(0)
  final int levelNumber;

  @HiveField(1)
  final int score;

  @HiveField(2)
  final int stars; // 1-3 نجوم

  @HiveField(3)
  final List<String> foundWords;

  @HiveField(4)
  final DateTime completedAt;

  @HiveField(5)
  final int timeSpent; // بالثواني

  @HiveField(6)
  final bool usedHints;

  const LevelProgressModel({
    required this.levelNumber,
    required this.score,
    required this.stars,
    required this.foundWords,
    required this.completedAt,
    required this.timeSpent,
    this.usedHints = false,
  });

  /// نسخ مع تعديلات
  LevelProgressModel copyWith({
    int? levelNumber,
    int? score,
    int? stars,
    List<String>? foundWords,
    DateTime? completedAt,
    int? timeSpent,
    bool? usedHints,
  }) {
    return LevelProgressModel(
      levelNumber: levelNumber ?? this.levelNumber,
      score: score ?? this.score,
      stars: stars ?? this.stars,
      foundWords: foundWords ?? this.foundWords,
      completedAt: completedAt ?? this.completedAt,
      timeSpent: timeSpent ?? this.timeSpent,
      usedHints: usedHints ?? this.usedHints,
    );
  }

  /// هل المستوى مكتمل بشكل مثالي
  bool get isPerfect => stars == 3;
}

/// محول Hive لـ LevelProgressModel
class LevelProgressModelAdapter extends TypeAdapter<LevelProgressModel> {
  @override
  final int typeId = HiveTypeIds.levelProgress;

  @override
  LevelProgressModel read(BinaryReader reader) {
    return LevelProgressModel(
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
  void write(BinaryWriter writer, LevelProgressModel obj) {
    writer.writeInt(obj.levelNumber);
    writer.writeInt(obj.score);
    writer.writeInt(obj.stars);
    writer.writeStringList(obj.foundWords);
    writer.writeInt(obj.completedAt.millisecondsSinceEpoch);
    writer.writeInt(obj.timeSpent);
    writer.writeBool(obj.usedHints);
  }
}
