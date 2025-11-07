# 🎮 لعبة البحث عن الكلمات العربية

لعبة ممتعة للبحث عن الكلمات العربية مع نظام تقدم متطور باستخدام Hive!

## ✨ المميزات الجديدة

### 🔒 نظام حفظ التقدم المتطور
- ✅ حفظ تلقائي للتقدم في كل مستوى
- ✅ تتبع النقاط والوقت المستغرق
- ✅ نظام النجوم (1-3 نجوم لكل مستوى)
- ✅ إحصائيات شاملة للأداء
- ✅ حفظ التلميحات المتبقية

### 🎁 المكافآت اليومية
- 🎁 +2 تلميحات كل 24 ساعة
- 🎁 +50 نقطة إضافية
- ⏰ مؤقت للمكافأة التالية

### 📊 الإحصائيات
- 📈 عدد المستويات المكتملة
- ⭐ عدد المستويات المثالية (3 نجوم)
- ⏱️ إجمالي وقت اللعب
- 🎯 متوسط النقاط

## 📁 هيكل المشروع

```
lib/
├── main.dart                          # نقطة البداية
├── services/
│   └── game_progress_service.dart     # خدمة حفظ التقدم
├── screens/
│   ├── level_map_screen.dart          # شاشة خريطة المستويات
│   └── game_level_screen.dart         # شاشة اللعب
└── data/
    └── game_level.dart                # قاعدة بيانات المستويات
```

## 🚀 خطوات التثبيت

### 1. إضافة التبعيات

في ملف `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  hive: ^2.2.3
  hive_flutter: ^1.1.0

dev_dependencies:
  hive_generator: ^2.0.1
  build_runner: ^2.4.8
```

### 2. تشغيل الأوامر

```bash
# تثبيت التبعيات
flutter pub get

# توليد ملفات Hive Adapters (إذا لزم الأمر)
flutter pub run build_runner build --delete-conflicting-outputs

# تشغيل التطبيق
flutter run
```

## 🎯 كيفية الاستخدام

### تهيئة Hive في التطبيق

في `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();  // تهيئة Hive
  runApp(const MyApp());
}
```

### استخدام خدمة حفظ التقدم

```dart
// الحصول على التقدم الحالي
final stats = progressService.getStatistics();
final currentLevel = stats['currentLevel'];
final totalScore = stats['totalScore'];

// إكمال مستوى
await progressService.completeLevel(
  levelNumber: 1,
  score: 150,
  foundWords: ['كلمة1', 'كلمة2'],
  timeSpent: 45,
  usedHints: false,
);

// استخدام تلميح
await progressService.useHint();

// إضافة تلميحات
await progressService.addHints(3);

// الحصول على المستويات المكتملة
Set<int> completed = progressService.getCompletedLevels();

// التحقق من المكافأة اليومية
bool canClaim = await progressService.claimDailyReward();
```

## 🎨 التخصيص

### إضافة مستويات جديدة

في `game_level.dart`:

```dart
61: LevelData(
  gridSize: 9,
  targetWord: 'كلمتك',
  extraWords: ['كلمة1', 'كلمة2', 'كلمة3'],
),
```

### تغيير عدد التلميحات الابتدائية

في `game_progress_service.dart`:

```dart
GameProgress({
  this.hintsRemaining = 5, // غيّر هذا الرقم
})
```

### تعديل حساب النجوم

في `game_progress_service.dart`:

```dart
int _calculateStars(int score, int timeSpent, bool usedHints) {
  if (usedHints) return 2;
  if (timeSpent < 30 && score > 100) return 3;
  // أضف منطقك الخاص هنا
  return 1;
}
```

## 🔧 الإعدادات المتاحة

```dart
// تفعيل/تعطيل الصوت
await progressService.setSoundEnabled(true);

// تفعيل/تعطيل الموسيقى
await progressService.setMusicEnabled(true);

// تفعيل/تعطيل الاهتزاز
await progressService.setVibrationEnabled(true);
```

## 💾 إدارة البيانات

### إعادة تعيين التقدم

```dart
await progressService.resetProgress();
```

### تصدير البيانات

```dart
final progress = await progressService.exportProgress();
// يمكنك حفظها أو مشاركتها
```

### استيراد البيانات

```dart
await progressService.importProgress(savedProgress);
```

## 🐛 معالجة الأخطاء

```dart
try {
  await progressService.completeLevel(
    levelNumber: 1,
    score: 150,
    foundWords: ['كلمة'],
    timeSpent: 30,
    usedHints: false,
  );
} catch (e) {
  print('خطأ في حفظ التقدم: $e');
}
```

## 📱 الأجهزة المدعومة

- ✅ Android
- ✅ iOS
- ✅ Web (مع بعض القيود على الاهتزاز)

## 🎯 نظام النجوم

- ⭐ نجمة واحدة: إكمال المستوى
- ⭐⭐ نجمتان: إكمال مع استخدام تلميحات أو وقت متوسط
- ⭐⭐⭐ 3 نجوم: إكمال سريع بدون تلميحات ونقاط عالية

## 🏆 نصائح للمطورين

### 1. إضافة نظام الإنجازات

```dart
class Achievement {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  bool unlocked;
  
  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.unlocked = false,
  });
}
```

### 2. إضافة نظام التصنيف (Leaderboard)

يمكنك إضافة خدمة مثل Firebase لحفظ النتائج عبر الإنترنت.

### 3. إضافة مؤثرات صوتية

```dart
import 'package:audioplayers/audioplayers.dart';

final player = AudioPlayer();
await player.play(AssetSource('sounds/success.mp3'));
```

### 4. إضافة مستويات تحدي يومية

```dart
class DailyChallenge {
  final int levelNumber;
  final DateTime date;
  final int targetScore;
  
  bool isToday() {
    return date.day == DateTime.now().day;
  }
}
```

## 🔍 استكشاف الأخطاء

### المشكلة: البيانات لا تُحفظ

**الحل:**
```dart
// تأكد من تهيئة Hive في main
await initHive();

// تأكد من استدعاء saveProgress
await progressService.saveProgress(progress);
```

### المشكلة: خطأ في Hive Adapters

**الحل:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### المشكلة: التطبيق بطيء

**الحل:**
- استخدم `const` للـ Widgets الثابتة
- قلل عدد مرات `setState()`
- استخدم `AnimatedBuilder` بدلاً من `setState` للتحريكات

## 📚 موارد إضافية

- [Hive Documentation](https://docs.hivedb.dev/)
- [Flutter Animations](https://flutter.dev/docs/development/ui/animations)
- [Material Design](https://material.io/design)

## 🤝 المساهمة

مرحباً بأي مساهمات! يمكنك:
- إضافة مستويات جديدة
- تحسين الواجهة
- إضافة ميزات جديدة
- إصلاح الأخطاء

## 📄 الترخيص

هذا المشروع مفتوح المصدر ومتاح للجميع.

## 🎉 استمتع باللعبة!

هل لديك أسئلة؟ لا تتردد في السؤال!