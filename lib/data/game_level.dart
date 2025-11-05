class GameLevel {
  final int levelNumber;
  final int gridSize;
  final String targetWord;
  final List<String> extraWords;
  final int minWordLength;

  GameLevel({
    required this.levelNumber,
    required this.gridSize,
    required this.targetWord,
    required this.extraWords,
    required this.minWordLength,
  });

  List<String> get allWords => [targetWord, ...extraWords];
}

class GameDatabase {
  static GameLevel getLevelData(int levelNumber) {
    // تحديد حجم الشبكة بناءً على المستوى
    // المستويات 1-9: شبكة 3x3
    // المستويات 10-18: شبكة 4x4
    // المستويات 19-27: شبكة 5x5
    // المستويات 28-36: شبكة 6x6
    int gridSize = 3 + ((levelNumber - 1) ~/ 9);
    
    final levelData = _levels[levelNumber];
    if (levelData != null) {
      return GameLevel(
        levelNumber: levelNumber,
        gridSize: gridSize,
        targetWord: levelData['target']!,
        extraWords: List<String>.from(levelData['extra']!),
        minWordLength: levelData['minLength'] ?? 3,
      );
    }
    
    // مستوى افتراضي في حالة عدم وجود البيانات
    return GameLevel(
      levelNumber: levelNumber,
      gridSize: gridSize,
      targetWord: 'كلمة',
      extraWords: ['كلم', 'لمك'],
      minWordLength: 3,
    );
  }

  static final Map<int, Map<String, dynamic>> _levels = {
    // ============ المستويات 1-9: شبكة 3×3 ============
    1: {
      'target': 'كتب',
      'extra': ['كتك', 'تبك'],
      'minLength': 3,
    },
    2: {
      'target': 'علم',
      'extra': ['عمل', 'لمع'],
      'minLength': 3,
    },
    3: {
      'target': 'قلم',
      'extra': ['قلب', 'ملق'],
      'minLength': 3,
    },
    4: {
      'target': 'بحر',
      'extra': ['حبر', 'رحب'],
      'minLength': 3,
    },
    5: {
      'target': 'نور',
      'extra': ['ورن', 'رون'],
      'minLength': 3,
    },
    6: {
      'target': 'سمع',
      'extra': ['عسم', 'معس'],
      'minLength': 3,
    },
    7: {
      'target': 'فجر',
      'extra': ['جفر', 'رجف'],
      'minLength': 3,
    },
    8: {
      'target': 'شمس',
      'extra': ['مشس', 'سمش'],
      'minLength': 3,
    },
    9: {
      'target': 'قمر',
      'extra': ['مقر', 'رقم'],
      'minLength': 3,
    },

    // ============ المستويات 10-18: شبكة 4×4 ============
    10: {
      'target': 'كتاب',
      'extra': ['كتب', 'باك', 'تاب'],
      'minLength': 3,
    },
    11: {
      'target': 'سماء',
      'extra': ['سما', 'ماء', 'اسم'],
      'minLength': 3,
    },
    12: {
      'target': 'جبال',
      'extra': ['جبل', 'بال', 'لاج'],
      'minLength': 3,
    },
    13: {
      'target': 'نهار',
      'extra': ['نار', 'هار', 'ران'],
      'minLength': 3,
    },
    14: {
      'target': 'وطن',
      'extra': ['طون', 'نطو', 'ونط'],
      'minLength': 3,
    },
    15: {
      'target': 'حلم',
      'extra': ['حلو', 'لمح', 'محل'],
      'minLength': 3,
    },
    16: {
      'target': 'بحار',
      'extra': ['بحر', 'حار', 'راح'],
      'minLength': 3,
    },
    17: {
      'target': 'زهور',
      'extra': ['زهر', 'هور', 'روز'],
      'minLength': 3,
    },
    18: {
      'target': 'غيوم',
      'extra': ['غيم', 'يوم', 'موغ'],
      'minLength': 3,
    },

    // ============ المستويات 19-27: شبكة 5×5 ============
    19: {
      'target': 'مدرسة',
      'extra': ['مدر', 'درس', 'رسة', 'سدر'],
      'minLength': 3,
    },
    20: {
      'target': 'مكتبة',
      'extra': ['مكت', 'كتب', 'تبة', 'بكت'],
      'minLength': 3,
    },
    21: {
      'target': 'حديقة',
      'extra': ['حدي', 'ديق', 'قية', 'يحد'],
      'minLength': 3,
    },
    22: {
      'target': 'صحراء',
      'extra': ['صحر', 'حرا', 'راء', 'احر'],
      'minLength': 3,
    },
    23: {
      'target': 'طائرة',
      'extra': ['طير', 'ائر', 'رطا', 'يرة'],
      'minLength': 3,
    },
    24: {
      'target': 'سفينة',
      'extra': ['سفي', 'فين', 'ينة', 'نسف'],
      'minLength': 3,
    },
    25: {
      'target': 'مدينة',
      'extra': ['مدن', 'دين', 'ينة', 'نمد'],
      'minLength': 3,
    },
    26: {
      'target': 'قرية',
      'extra': ['قري', 'رية', 'يقر', 'ريق'],
      'minLength': 3,
    },
    27: {
      'target': 'واحة',
      'extra': ['واح', 'احة', 'حوا', 'حاو'],
      'minLength': 3,
    },

    // ============ المستويات 28-36: شبكة 6×6 ============
    28: {
      'target': 'مستشفى',
      'extra': ['مست', 'شفى', 'تشف', 'فمس', 'شمس'],
      'minLength': 3,
    },
    29: {
      'target': 'جامعة',
      'extra': ['جام', 'امع', 'معة', 'عجا', 'مجا'],
      'minLength': 3,
    },
    30: {
      'target': 'مطعم',
      'extra': ['مطع', 'طعم', 'عمط', 'معط', 'طمع'],
      'minLength': 3,
    },
    31: {
      'target': 'فندق',
      'extra': ['فند', 'ندق', 'دقف', 'قفن', 'نفد'],
      'minLength': 3,
    },
    32: {
      'target': 'متحف',
      'extra': ['متح', 'تحف', 'حفم', 'فمت', 'حمت'],
      'minLength': 3,
    },
    33: {
      'target': 'ملعب',
      'extra': ['ملع', 'لعب', 'عبم', 'بمل', 'علم'],
      'minLength': 3,
    },
    34: {
      'target': 'مسجد',
      'extra': ['مسج', 'سجد', 'جدم', 'دمس', 'جمس'],
      'minLength': 3,
    },
    35: {
      'target': 'كنيسة',
      'extra': ['كني', 'نيس', 'يسة', 'سكن', 'نسك'],
      'minLength': 3,
    },
    36: {
      'target': 'معبد',
      'extra': ['معب', 'عبد', 'بدم', 'دمع', 'بعم'],
      'minLength': 3,
    },

    // ============ المستويات 37-45: شبكة 7×7 ============
    37: {
      'target': 'مهندس',
      'extra': ['مهن', 'هند', 'ندس', 'دسم', 'سهن', 'نهم'],
      'minLength': 3,
    },
    38: {
      'target': 'محامي',
      'extra': ['محا', 'حام', 'امي', 'ميح', 'احم', 'ماح'],
      'minLength': 3,
    },
    39: {
      'target': 'طبيب',
      'extra': ['طبي', 'بيب', 'يطب', 'بطي', 'طيب', 'بطب'],
      'minLength': 3,
    },
    40: {
      'target': 'معلم',
      'extra': ['معل', 'علم', 'لمع', 'مع', 'عمل', 'لعم'],
      'minLength': 3,
    },
    41: {
      'target': 'كاتب',
      'extra': ['كات', 'اتب', 'تبك', 'بكا', 'كتب', 'اكت'],
      'minLength': 3,
    },
    42: {
      'target': 'رسام',
      'extra': ['رسا', 'سام', 'امر', 'مرس', 'رام', 'سمر'],
      'minLength': 3,
    },
    43: {
      'target': 'موسيقي',
      'extra': ['موس', 'وسي', 'سيق', 'يقي', 'قوس', 'سوم'],
      'minLength': 3,
    },
    44: {
      'target': 'شاعر',
      'extra': ['شاع', 'اعر', 'عرش', 'رشا', 'شعر', 'عشا'],
      'minLength': 3,
    },
    45: {
      'target': 'ممثل',
      'extra': ['ممث', 'مثل', 'ثلم', 'لمم', 'ثمم', 'مثم'],
      'minLength': 3,
    },

    // ============ المستويات 46-54: شبكة 8×8 ============
    46: {
      'target': 'مبرمج',
      'extra': ['مبر', 'برم', 'رمج', 'جمب', 'ربم', 'مجر', 'برج'],
      'minLength': 3,
    },
    47: {
      'target': 'صحفي',
      'extra': ['صحف', 'حفي', 'فيص', 'يصح', 'فصح', 'حصف', 'صفح'],
      'minLength': 3,
    },
    48: {
      'target': 'محرر',
      'extra': ['محر', 'حرر', 'ررم', 'رمح', 'حمر', 'رحم', 'مرح'],
      'minLength': 3,
    },
    49: {
      'target': 'مصور',
      'extra': ['مصو', 'صور', 'ورم', 'رمص', 'ومص', 'صرم', 'روم'],
      'minLength': 3,
    },
    50: {
      'target': 'مترجم',
      'extra': ['متر', 'ترج', 'رجم', 'جمت', 'رمت', 'جتر', 'تجم'],
      'minLength': 3,
    },
  };

  // دالة للحصول على إجمالي عدد المستويات
  static int get totalLevels => _levels.length;

  // دالة للتحقق من وجود مستوى
  static bool hasLevel(int levelNumber) => _levels.containsKey(levelNumber);

  // دالة للحصول على نطاق حجم الشبكة
  static String getGridSizeRange(int levelNumber) {
    int gridSize = 3 + ((levelNumber - 1) ~/ 9);
    int startLevel = ((levelNumber - 1) ~/ 9) * 9 + 1;
    int endLevel = startLevel + 8;
    return 'المستويات $startLevel-$endLevel: شبكة ${gridSize}×$gridSize';
  }
}