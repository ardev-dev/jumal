class GameDatabase {
  // قاعدة البيانات الكاملة للمستويات
  static Map<int, LevelData> getAllLevels() {
    return {
      // ═══════════════════════════════════════════════════════════
      // المستويات 1-4: شبكة 3×3 (9 أحرف، 3 كلمات)
      // ═══════════════════════════════════════════════════════════
      1: LevelData(
        levelNumber: 1,
        questions: ['عضو للشم', 'فاكهة صفراء', 'حيوان أليف'],
        words: ['أنف', 'موز', 'قطة'],
        gridLetters: [
          ['أ', 'ن', 'ف'],
          ['م', 'و', 'ز'],
          ['ق', 'ط', 'ة'],
        ],
      ),

      2: LevelData(
        levelNumber: 2,
        questions: ['وقت الظهيرة', 'طائر يصيح فجراً', 'مصدر الضوء ليلاً'],
        words: ['ظهر', 'ديك', 'قمر'],
        gridLetters: [
          ['ظ', 'ه', 'ر'],
          ['د', 'ي', 'ك'],
          ['ق', 'م', 'ر'],
        ],
      ),

      3: LevelData(
        levelNumber: 3,
        questions: ['عكس ليل', 'رقم بعد ٢'],
        words: ['نهار', 'ثلاثة'],
        gridLetters: [
          ['ن', 'ه', 'ا'],
          ['ر', 'ث', 'ل'],
          ['ا', 'ث', 'ة'],
        ],
      ),

      4: LevelData(
        levelNumber: 4,
        questions: ['عاصمة مصر', 'كوكب أحمر'],
        words: ['قاهرة', 'مريخ'],
        gridLetters: [
          ['ق', 'ا', 'ه'],
          ['ر', 'ة', 'م'],
          ['ر', 'ي', 'خ'],
        ],
      ),

      // ═══════════════════════════════════════════════════════════
      // المستويات 5-9: شبكة 4×4 (16 حرف، 4 كلمات)
      // ═══════════════════════════════════════════════════════════
      5: LevelData(
        levelNumber: 5,
        questions: [
          'أكبر قارة في العالم',
          'عاصمة فرنسا',
          'فصل الأمطار',
          'معدن ثمين أصفر',
        ],
        words: ['آسيا', 'باريس', 'شتاء', 'ذهب'],
        gridLetters: [
          ['آ', 'س', 'ي', 'ا'],
          ['ب', 'ا', 'ر', 'ي'],
          ['س', 'ش', 'ت', 'ا'],
          ['ء', 'ذ', 'ه', 'ب'],
        ],
      ),

      6: LevelData(
        levelNumber: 6,
        questions: [
          'كتاب المسلمين المقدس',
          'نهر في مصر',
          'عاصمة السعودية',
          'أطول حيوان',
        ],
        words: ['قرآن', 'نيل', 'رياض', 'زرافة'],
        gridLetters: [
          ['ق', 'ر', 'آ', 'ن'],
          ['ن', 'ي', 'ل', 'ر'],
          ['ي', 'ا', 'ض', 'ز'],
          ['ر', 'ا', 'ف', 'ة'],
        ],
      ),

      7: LevelData(
        levelNumber: 7,
        questions: [
          'يوم الراحة الأسبوعية',
          'أكبر محيط في العالم',
          'فاكهة استوائية',
          'طائر لا يطير',
        ],
        words: ['جمعة', 'هادئ', 'مانجو', 'نعامة'],
        gridLetters: [
          ['ج', 'م', 'ع', 'ة'],
          ['ه', 'ا', 'د', 'ئ'],
          ['م', 'ا', 'ن', 'ج'],
          ['و', 'ن', 'ع', 'ا'],
        ],
      ),

      8: LevelData(
        levelNumber: 8,
        questions: ['جهاز للاتصال', 'مدينة الضباب', 'شهر الصيام', 'كوكب الأرض'],
        words: ['هاتف', 'لندن', 'رمضان', 'كوكب'],
        gridLetters: [
          ['ه', 'ا', 'ت', 'ف'],
          ['ل', 'ن', 'د', 'ن'],
          ['ر', 'م', 'ض', 'ا'],
          ['ن', 'ك', 'و', 'ك'],
        ],
      ),

      9: LevelData(
        levelNumber: 9,
        questions: ['ساعة الحائط', 'رياضة بالكرة', 'حاسة التذوق', 'بيت النحل'],
        words: ['منبه', 'تنس', 'لسان', 'خلية'],
        gridLetters: [
          ['م', 'ن', 'ب', 'ه'],
          ['ت', 'ن', 'س', 'ل'],
          ['س', 'ا', 'ن', 'خ'],
          ['ل', 'ي', 'ة', 'م'],
        ],
      ),

      // ═══════════════════════════════════════════════════════════
      // المستويات 10-14: شبكة 5×5 (25 حرف، 5 كلمات)
      // ═══════════════════════════════════════════════════════════
      10: LevelData(
        levelNumber: 10,
        questions: [
          'عاصمة إيطاليا',
          'جهاز للتبريد',
          'رياضة قتالية يابانية',
          'أطول نهر في العالم',
          'كوكب لديه حلقات',
        ],
        words: ['روما', 'ثلاجة', 'كاراتيه', 'نيل', 'زحل'],
        gridLetters: [
          ['ر', 'و', 'م', 'ا', 'ث'],
          ['ل', 'ا', 'ج', 'ة', 'ك'],
          ['ا', 'ر', 'ا', 'ت', 'ي'],
          ['ه', 'ن', 'ي', 'ل', 'ز'],
          ['ح', 'ل', 'م', 'ن', 'ق'],
        ],
      ),

      11: LevelData(
        levelNumber: 11,
        questions: [
          'جبل أعلى قمة',
          'مدينة الذهب',
          'أسرع حيوان بري',
          'عاصمة اليابان',
          'معدن أبيض ثمين',
        ],
        words: ['إفرست', 'دبي', 'فهد', 'طوكيو', 'فضة'],
        gridLetters: [
          ['إ', 'ف', 'ر', 'س', 'ت'],
          ['د', 'ب', 'ي', 'ف', 'ه'],
          ['د', 'ط', 'و', 'ك', 'ي'],
          ['و', 'ف', 'ض', 'ة', 'م'],
          ['ن', 'ل', 'ك', 'ج', 'ر'],
        ],
      ),

      12: LevelData(
        levelNumber: 12,
        questions: [
          'قارة الكنغر',
          'شهر الحج',
          'رياضة الملاكمة',
          'نجم الصباح',
          'مدينة الفن',
        ],
        words: ['أستراليا', 'ذو الحجة', 'بوكس', 'زهرة', 'باريس'],
        gridLetters: [
          ['أ', 'س', 'ت', 'ر', 'ا'],
          ['ل', 'ي', 'ا', 'ذ', 'و'],
          ['ا', 'ل', 'ح', 'ج', 'ة'],
          ['ب', 'و', 'ك', 'س', 'ز'],
          ['ه', 'ر', 'ة', 'ب', 'ا'],
        ],
      ),

      13: LevelData(
        levelNumber: 13,
        questions: [
          'أصغر قارة',
          'عاصمة الهند',
          'حيوان بحري ضخم',
          'شهر الميلاد',
          'لون العشب',
        ],
        words: ['أوقيانوسيا', 'دلهي', 'حوت', 'ديسمبر', 'أخضر'],
        gridLetters: [
          ['أ', 'و', 'ق', 'ي', 'ا'],
          ['ن', 'و', 'س', 'ي', 'ا'],
          ['د', 'ل', 'ه', 'ي', 'ح'],
          ['و', 'ت', 'د', 'ي', 'س'],
          ['م', 'ب', 'ر', 'أ', 'خ'],
        ],
      ),

      14: LevelData(
        levelNumber: 14,
        questions: [
          'عاصمة ألمانيا',
          'طائر الليل',
          'حاسة السمع',
          'كوكب الجمال',
          'فصل الحصاد',
        ],
        words: ['برلين', 'بومة', 'أذن', 'زهرة', 'خريف'],
        gridLetters: [
          ['ب', 'ر', 'ل', 'ي', 'ن'],
          ['ب', 'و', 'م', 'ة', 'أ'],
          ['ذ', 'ن', 'ز', 'ه', 'ر'],
          ['ة', 'خ', 'ر', 'ي', 'ف'],
          ['ج', 'س', 'ع', 'ك', 'ل'],
        ],
      ),
    };
  }

  // الحصول على بيانات مستوى محدد
  static LevelData? getLevel(int levelNumber) {
    return getAllLevels()[levelNumber];
  }

  // الحصول على إجمالي عدد المستويات
  static int getTotalLevels() {
    return getAllLevels().length;
  }

  // التحقق من وجود مستوى
  static bool levelExists(int levelNumber) {
    return getAllLevels().containsKey(levelNumber);
  }

  // الحصول على حجم الشبكة لمستوى معين
  static int getGridSizeForLevel(int levelNumber) {
    final level = getAllLevels()[levelNumber];
    return level?.gridSize ?? 0;
  }

  // الحصول على نطاق المستويات لحجم شبكة معين
  static List<int> getLevelsForGridSize(int gridSize) {
    List<int> levels = [];
    for (var entry in getAllLevels().entries) {
      if (entry.value.gridSize == gridSize) {
        levels.add(entry.key);
      }
    }
    return levels;
  }

  // إحصائيات عن المستويات
  static Map<String, dynamic> getStatistics() {
    final allLevels = getAllLevels();
    final gridSizes = <int, int>{};
    int minSize = 999;
    int maxSize = 0;

    for (var level in allLevels.values) {
      final size = level.gridSize;
      gridSizes[size] = (gridSizes[size] ?? 0) + 1;
      if (size < minSize) minSize = size;
      if (size > maxSize) maxSize = size;
    }

    return {
      'totalLevels': allLevels.length,
      'gridSizeDistribution': gridSizes,
      'minGridSize': minSize,
      'maxGridSize': maxSize,
    };
  }
}

class LevelData {
  final int levelNumber;
  final List<String> questions; // الأسئلة بعدد الكلمات
  final List<String> words; // الكلمات (الإجابات)
  final List<List<String>> gridLetters; // الأحرف المستخدمة في الشبكة (قوائم متداخلة)

  LevelData({
    required this.levelNumber,
    required this.questions,
    required this.words,
    required this.gridLetters,
  }) {
    // التحقق من صحة البيانات
    assert(
      questions.length == words.length,
      'عدد الأسئلة يجب أن يساوي عدد الكلمات',
    );
    
    // التحقق من أن الشبكة مربعة
    assert(
      gridLetters.isNotEmpty && gridLetters.every((row) => row.length == gridLetters.length),
      'الشبكة يجب أن تكون مربعة (عدد الصفوف = عدد الأعمدة)',
    );
    
    assert(
      words.length <= gridSize * gridSize,
      'عدد الكلمات لا يمكن أن يتجاوز عدد الخلايا في الشبكة',
    );
  }

  // حجم الشبكة (يُستنتج من عدد الصفوف)
  int get gridSize => gridLetters.length;

  // عدد الكلمات الإجمالي
  int get totalWords => words.length;

  // عدد الأسئلة
  int get totalQuestions => questions.length;

  // عدد الأحرف
  int get totalLetters => gridSize * gridSize;

  // الحصول على حرف في موقع محدد
  String getLetterAt(int row, int col) {
    if (row >= 0 && row < gridSize && col >= 0 && col < gridSize) {
      return gridLetters[row][col];
    }
    return '';
  }

  // الصعوبة بناءً على حجم الشبكة
  String get difficulty {
    if (gridSize <= 3) return 'سهل';
    if (gridSize <= 5) return 'متوسط';
    if (gridSize <= 7) return 'صعب';
    return 'خبير';
  }

  // النقاط المتوقعة للمستوى
  int get expectedScore {
    return words.fold(0, (sum, word) => sum + (word.length * 10));
  }

  // الحصول على سؤال وكلمة معينة
  Map<String, String> getQuestionAndWord(int index) {
    if (index >= 0 && index < words.length) {
      return {'question': questions[index], 'word': words[index]};
    }
    return {};
  }

  @override
  String toString() {
    return 'LevelData(levelNumber: $levelNumber, gridSize: $gridSize, totalWords: $totalWords, totalLetters: $totalLetters, difficulty: $difficulty)';
  }

  factory LevelData.empty() {
    return LevelData(
      levelNumber: 0,
      questions: ['عضو للشم', 'فاكهة صفراء', 'حيوان أليف'],
      words: ['أنف', 'موز', 'قطة'],
      gridLetters: [
        ['أ', 'ن', 'ف'],
        ['م', 'و', 'ز'],
        ['ق', 'ط', 'ة'],
      ],
    );
  }
}