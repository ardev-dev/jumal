import '../../models/level_data_model.dart';

/// مصدر البيانات المحلي للمستويات
abstract interface class LevelsLocalDataSource {
  /// الحصول على جميع المستويات
  Map<int, LevelDataModel> getAllLevels();

  /// الحصول على مستوى محدد
  LevelDataModel? getLevel(int levelNumber);

  /// الحصول على إجمالي عدد المستويات
  int getTotalLevels();

  /// التحقق من وجود مستوى
  bool levelExists(int levelNumber);
}

/// التنفيذ الافتراضي لمصدر البيانات المحلي
class LevelsLocalDataSourceImpl implements LevelsLocalDataSource {
  // Singleton pattern
  static final LevelsLocalDataSourceImpl _instance = LevelsLocalDataSourceImpl._internal();
  factory LevelsLocalDataSourceImpl() => _instance;
  LevelsLocalDataSourceImpl._internal();

  // Cache للمستويات
  Map<int, LevelDataModel>? _levelsCache;

  @override
  Map<int, LevelDataModel> getAllLevels() {
    return _levelsCache ??= _generateLevels();
  }

  @override
  LevelDataModel? getLevel(int levelNumber) {
    return getAllLevels()[levelNumber];
  }

  @override
  int getTotalLevels() {
    return getAllLevels().length;
  }

  @override
  bool levelExists(int levelNumber) {
    return getAllLevels().containsKey(levelNumber);
  }

  Map<int, LevelDataModel> _generateLevels() {
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
}
