class GameDatabase {
  // قاعدة البيانات الكاملة للمستويات
  static Map<int, LevelDataModel> getAllLevels() {
    return {
      1: LevelDataModel(
        levelNumber: 1,
        questions: [
          'من يقدم الأخبار أو البرامج على التلفاز',
          'من لا يحب بذل الجهد أو العمل',
          'حشرة تعمل في مستعمرات منظمة',
        ],
        words: ['مذيع', 'كسول', 'نملة'],
        gridLetters: [
          ['ذ', 'م', 'ة'],
          ['ي', 'م', 'ل'],
          ['ع', 'ن', 'ك'],
          ['ل', 'و', 'س'],
        ],
      ),

      2: LevelDataModel(
        levelNumber: 2,
        questions: ['وقت الظهيرة', 'طائر يصيح فجراً', 'مصدر الضوء ليلاً'],
        words: ['ظهر', 'ديك', 'قمر'],
        gridLetters: [
          ['ظ', 'ه', 'ر'],
          ['د', 'ي', 'ك'],
          ['ق', 'م', 'ر'],
        ],
      ),

      3: LevelDataModel(
        levelNumber: 3,
        questions: ['عكس ليل', 'رقم بعد ٢'],
        words: ['نهار', 'ثلاثة'],
        gridLetters: [
          ['ن', 'ه', 'ا'],
          ['ر', 'ث', 'ل'],
          ['ا', 'ث', 'ة'],
        ],
      ),

      4: LevelDataModel(
        levelNumber: 4,
        questions: ['عاصمة مصر', 'كوكب أحمر'],
        words: ['قاهرة', 'مريخ'],
        gridLetters: [
          ['ق', 'ا', 'ه'],
          ['ر', 'ة', 'م'],
          ['ر', 'ي', 'خ'],
        ],
      ),

      5: LevelDataModel(
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

      6: LevelDataModel(
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

      7: LevelDataModel(
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

      8: LevelDataModel(
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

      9: LevelDataModel(
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
      10: LevelDataModel(
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

      11: LevelDataModel(
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

      12: LevelDataModel(
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

      13: LevelDataModel(
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

      14: LevelDataModel(
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
  static LevelDataModel? getLevel(int levelNumber) {
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

  // إحصائيات عن المستويات
  static Map<String, dynamic> getStatistics() {
    final allLevels = getAllLevels();
    final gridSizes = <int, int>{};
    int minSize = 999;
    int maxSize = 0;

    return {
      'totalLevels': allLevels.length,
      'gridSizeDistribution': gridSizes,
      'minGridSize': minSize,
      'maxGridSize': maxSize,
    };
  }
}

class LevelDataModel {
  final int levelNumber;
  final List<String> questions; // الأسئلة بعدد الكلمات
  final List<String> words; // الكلمات (الإجابات)
  final List<List<String>>
  gridLetters; // الأحرف المستخدمة في الشبكة (قوائم متداخلة)

  LevelDataModel({
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
  }

  double get horizontal {
    switch (gridLetters.first.length) {
      case 3:
        return 48.0;
      case 4:
        return 40.0;
      case 5:
        return 32.0;
      case 6:
        return 24.0;
      case 7:
        return 16.0;
      default:
        return 8.0;
    }
  }

  // عدد الكلمات الإجمالي
  int get totalWords => words.length;

  // عدد الأسئلة
  int get totalQuestions => questions.length;

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

  factory LevelDataModel.empty() {
    return LevelDataModel(
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

  String getLetterAt(int row, int col) {
    if (row >= 0 &&
        row < gridLetters.length &&
        col >= 0 &&
        col < gridLetters[row].length) {
      return gridLetters[row][col];
    }
    return '';
  }
}
