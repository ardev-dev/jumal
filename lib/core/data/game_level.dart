class GameLevelsDatabase {
  // قاعدة البيانات الكاملة للمستويات
  static Map<int, LevelData> getAllLevels() {
    return {
      // المستويات 1-9: شبكة 3×3 (9 أحرف، 3 كلمات)
      1: LevelData(
        gridSize: 3,
        questions: ['وسيلة للصعود', 'ناعم ومستوٍ', 'سم اللسان'],
        words: ['سلم', 'سلس', 'لسم'],
        letters: ['س', 'ل', 'م', 'س', 'ل', 'س', 'ل', 'س', 'م'],
      ),
      2: LevelData(
        gridSize: 3,
        questions: ['أداة الكتابة', 'شعور بالخوف', 'فعل التملق'],
        words: ['قلم', 'قلق', 'ملق'],
        letters: ['ق', 'ل', 'م', 'ق', 'ل', 'ق', 'م', 'ل', 'ق'],
      ),
      3: LevelData(
        gridSize: 3,
        questions: ['ضياء وإشراق', 'حرف عربي مكرر', 'اسم علم'],
        words: ['نور', 'نون', 'رون'],
        letters: ['ن', 'و', 'ر', 'ن', 'و', 'ن', 'ر', 'و', 'ن'],
      ),
      4: LevelData(
        gridSize: 3,
        questions: ['مسطح مائي كبير', 'حرف مكرر', 'قتال ونزاع'],
        words: ['بحر', 'بحب', 'حرب'],
        letters: ['ب', 'ح', 'ر', 'ب', 'ح', 'ب', 'ح', 'ر', 'ب'],
      ),
      5: LevelData(
        gridSize: 3,
        questions: ['نجم السماء', 'حرف مكرر', 'ظلام وسم'],
        words: ['شمس', 'شمش', 'مسم'],
        letters: ['ش', 'م', 'س', 'ش', 'م', 'ش', 'م', 'س', 'م'],
      ),
      6: LevelData(
        gridSize: 3,
        questions: ['نبات جميل', 'حرف مكرر', 'تحريك برفق'],
        words: ['زهر', 'زهز', 'هرز'],
        letters: ['ز', 'ه', 'ر', 'ز', 'ه', 'ز', 'ه', 'ر', 'ز'],
      ),
      7: LevelData(
        gridSize: 3,
        questions: ['وقت من اليوم', 'حرف مكرر', 'ضغط وإجبار'],
        words: ['عصر', 'عصع', 'صرع'],
        letters: ['ع', 'ص', 'ر', 'ع', 'ص', 'ع', 'ص', 'ر', 'ع'],
      ),
      8: LevelData(
        gridSize: 3,
        questions: ['بداية النهار', 'حرف مكرر', 'حافة وطرف'],
        words: ['فجر', 'فجف', 'جرف'],
        letters: ['ف', 'ج', 'ر', 'ف', 'ج', 'ف', 'ج', 'ر', 'ف'],
      ),
      9: LevelData(
        gridSize: 3,
        questions: ['كائن يطير', 'حرف مكرر', 'شيء يسقط'],
        words: ['طير', 'طيط', 'يرط'],
        letters: ['ط', 'ي', 'ر', 'ط', 'ي', 'ط', 'ي', 'ر', 'ط'],
      ),
      
      // المستويات 10-18: شبكة 4×4 (16 حرف، 4 كلمات)
      10: LevelData(
        gridSize: 4,
        questions: ['مجموعة أوراق للقراءة', 'فعل الكتابة', 'ندم ورجوع', 'قطة بالإنجليزية'],
        words: ['كتاب', 'كتب', 'تاب', 'كات'],
        letters: ['ك', 'ت', 'ا', 'ب', 'ك', 'ت', 'ب', 'ت', 'ا', 'ب', 'ك', 'ا', 'ت', 'ك', 'ت', 'ب'],
      ),
      11: LevelData(
        gridSize: 4,
        questions: ['الفضاء الأزرق', 'علا وارتفع', 'سائل الحياة', 'حرف مكرر'],
        words: ['سماء', 'سما', 'ماء', 'سمس'],
        letters: ['س', 'م', 'ا', 'ء', 'س', 'م', 'ا', 'م', 'ا', 'ء', 'س', 'م', 'س', 'س', 'م', 'ا'],
      ),
      12: LevelData(
        gridSize: 4,
        questions: ['مرتفعات طبيعية', 'مفرد جبال', 'اسم عائلة', 'شمال'],
        words: ['جبال', 'جبل', 'بال', 'جال'],
        letters: ['ج', 'ب', 'ا', 'ل', 'ج', 'ب', 'ل', 'ب', 'ا', 'ل', 'ج', 'ا', 'ل', 'ج', 'ب', 'ل'],
      ),
      13: LevelData(
        gridSize: 4,
        questions: ['وقت النور', 'مجرى مائي', 'احتراق وحرارة', 'لهب وحريق'],
        words: ['نهار', 'نهر', 'هار', 'نار'],
        letters: ['ن', 'ه', 'ا', 'ر', 'ن', 'ه', 'ر', 'ه', 'ا', 'ر', 'ن', 'ا', 'ر', 'ن', 'ه', 'ر'],
      ),
      14: LevelData(
        gridSize: 4,
        questions: ['جمع ليلة', 'وقت الظلام', 'حرفان', 'تكرار حرف'],
        words: ['ليال', 'ليل', 'يال', 'لال'],
        letters: ['ل', 'ي', 'ا', 'ل', 'ل', 'ي', 'ل', 'ي', 'ا', 'ل', 'ل', 'ا', 'ل', 'ل', 'ي', 'ل'],
      ),
      15: LevelData(
        gridSize: 4,
        questions: ['جمع قمر', 'نور الليل', 'مرض', 'سائل أسود'],
        words: ['قمار', 'قمر', 'مار', 'قار'],
        letters: ['ق', 'م', 'ا', 'ر', 'ق', 'م', 'ر', 'م', 'ا', 'ر', 'ق', 'ا', 'ر', 'ق', 'م', 'ر'],
      ),
      16: LevelData(
        gridSize: 4,
        questions: ['جمع بحر', 'ماء مالح', 'شديد السخونة', 'مشروب'],
        words: ['بحار', 'بحر', 'حار', 'بار'],
        letters: ['ب', 'ح', 'ا', 'ر', 'ب', 'ح', 'ر', 'ح', 'ا', 'ر', 'ب', 'ا', 'ر', 'ب', 'ح', 'ر'],
      ),
      17: LevelData(
        gridSize: 4,
        questions: ['جمع زهرة', 'نبات جميل', 'طيور', 'ظلم'],
        words: ['زهور', 'زهر', 'هور', 'زور'],
        letters: ['ز', 'ه', 'و', 'ر', 'ز', 'ه', 'ر', 'ه', 'و', 'ر', 'ز', 'و', 'ر', 'ز', 'ه', 'ر'],
      ),
      18: LevelData(
        gridSize: 4,
        questions: ['جمع طير', 'كائن يطير', 'مرور الوقت', 'تطور'],
        words: ['طيور', 'طير', 'يور', 'طور'],
        letters: ['ط', 'ي', 'و', 'ر', 'ط', 'ي', 'ر', 'ي', 'و', 'ر', 'ط', 'و', 'ر', 'ط', 'ي', 'ر'],
      ),
      
      // المستويات 19-27: شبكة 5×5 (25 حرف، 5 كلمات)
      19: LevelData(
        gridSize: 5,
        questions: ['مكان التعليم', 'مطر', 'تعليم', 'آلة', 'كلمة قصيرة'],
        words: ['مدرسة', 'مدر', 'درس', 'رسة', 'مدس'],
        letters: ['م', 'د', 'ر', 'س', 'ة', 'م', 'د', 'ر', 'د', 'ر', 'س', 'ر', 'س', 'ة', 'م', 'د', 'س', 'م', 'د', 'ر', 'س', 'د', 'ر', 'س', 'ة'],
      ),
      20: LevelData(
        gridSize: 5,
        questions: ['كتابة الأكواد', 'برج', 'رمج', 'نهاية', 'برم'],
        words: ['برمجة', 'برج', 'رمج', 'مجة', 'برم'],
        letters: ['ب', 'ر', 'م', 'ج', 'ة', 'ب', 'ر', 'ج', 'ر', 'م', 'ج', 'م', 'ج', 'ة', 'ب', 'ر', 'م', 'ب', 'ر', 'م', 'ج', 'ر', 'م', 'ج', 'ة'],
      ),
      21: LevelData(
        gridSize: 5,
        questions: ['جمع كلمة', 'كلم', 'ماذا', 'موت', 'كلا'],
        words: ['كلمات', 'كلم', 'لما', 'مات', 'كلا'],
        letters: ['ك', 'ل', 'م', 'ا', 'ت', 'ك', 'ل', 'م', 'ل', 'م', 'ا', 'م', 'ا', 'ت', 'ك', 'ل', 'ا', 'ك', 'ل', 'م', 'ا', 'ل', 'م', 'ا', 'ت'],
      ),
      22: LevelData(
        gridSize: 5,
        questions: ['اتصال وارتباط', 'وصل', 'رابطة', 'وصة', 'لصة'],
        words: ['وصلة', 'وصل', 'صلة', 'وصة', 'لصة'],
        letters: ['و', 'ص', 'ل', 'ة', 'و', 'و', 'ص', 'ل', 'ص', 'ل', 'ة', 'و', 'ص', 'ة', 'ل', 'ص', 'ة', 'و', 'ص', 'ل', 'ة', 'ص', 'ل', 'ص', 'ة'],
      ),
      23: LevelData(
        gridSize: 5,
        questions: ['بريد مكتوب', 'رسل', 'سائل', 'آلة', 'رسا'],
        words: ['رسالة', 'رسل', 'سال', 'الة', 'رسا'],
        letters: ['ر', 'س', 'ا', 'ل', 'ة', 'ر', 'س', 'ل', 'س', 'ا', 'ل', 'ا', 'ل', 'ة', 'ر', 'س', 'ا', 'ر', 'س', 'ا', 'ل', 'س', 'ا', 'ل', 'ة'],
      ),
      24: LevelData(
        gridSize: 5,
        questions: ['أهل وأقارب', 'عال', 'سائل', 'نهاية', 'عاي'],
        words: ['عائلة', 'عال', 'ائل', 'يلة', 'عاي'],
        letters: ['ع', 'ا', 'ئ', 'ل', 'ة', 'ع', 'ا', 'ل', 'ا', 'ئ', 'ل', 'ي', 'ل', 'ة', 'ع', 'ا', 'ي', 'ع', 'ا', 'ئ', 'ل', 'ا', 'ئ', 'ل', 'ة'],
      ),
      25: LevelData(
        gridSize: 5,
        questions: ['وظيفة وعمل', 'مهن', 'هنة', 'منة', 'مهه'],
        words: ['مهنة', 'مهن', 'هنة', 'منة', 'مهه'],
        letters: ['م', 'ه', 'ن', 'ة', 'م', 'م', 'ه', 'ن', 'ه', 'ن', 'ة', 'م', 'ن', 'ة', 'م', 'ه', 'ه', 'م', 'ه', 'ن', 'ة', 'ه', 'ن', 'م', 'ه'],
      ),
      26: LevelData(
        gridSize: 5,
        questions: ['عطية وهبة', 'هدي', 'دية', 'هية', 'هدد'],
        words: ['هدية', 'هدي', 'دية', 'هية', 'هدد'],
        letters: ['ه', 'د', 'ي', 'ة', 'ه', 'ه', 'د', 'ي', 'د', 'ي', 'ة', 'ه', 'ي', 'ة', 'ه', 'د', 'د', 'ه', 'د', 'ي', 'ة', 'د', 'ي', 'ه', 'د'],
      ),
      27: LevelData(
        gridSize: 5,
        questions: ['شعر موزون', 'قصي', 'صيد', 'نهاية', 'قصد'],
        words: ['قصيدة', 'قصي', 'صيد', 'يدة', 'قصد'],
        letters: ['ق', 'ص', 'ي', 'د', 'ة', 'ق', 'ص', 'ي', 'ص', 'ي', 'د', 'ي', 'د', 'ة', 'ق', 'ص', 'د', 'ق', 'ص', 'ي', 'د', 'ص', 'ي', 'د', 'ة'],
      ),
      
      // يمكن إكمال باقي المستويات بنفس النمط
      // المستويات 28-60 تتبع نفس المنطق
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
    if (levelNumber <= 9) return 3;
    if (levelNumber <= 18) return 4;
    if (levelNumber <= 27) return 5;
    if (levelNumber <= 36) return 6;
    if (levelNumber <= 45) return 7;
    if (levelNumber <= 54) return 8;
    return 9;
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
    
    for (var level in allLevels.values) {
      gridSizes[level.gridSize] = (gridSizes[level.gridSize] ?? 0) + 1;
    }
    
    return {
      'totalLevels': allLevels.length,
      'gridSizeDistribution': gridSizes,
      'minGridSize': 3,
      'maxGridSize': 9,
    };
  }
}

// نموذج بيانات المستوى المحسّن
class LevelData {
  final int gridSize;
  final List<String> questions; // الأسئلة بعدد الكلمات
  final List<String> words; // الكلمات (الإجابات)
  final List<String> letters; // الأحرف المستخدمة في الشبكة
  
  LevelData({
    required this.gridSize,
    required this.questions,
    required this.words,
    required this.letters,
  }) {
    // التحقق من صحة البيانات
    assert(questions.length == words.length, 
      'عدد الأسئلة يجب أن يساوي عدد الكلمات');
    assert(letters.length == gridSize * gridSize, 
      'عدد الأحرف يجب أن يساوي gridSize * gridSize');
    assert(words.length <= gridSize * gridSize,
      'عدد الكلمات لا يمكن أن يتجاوز gridSize * gridSize');
  }
  
  // عدد الكلمات الإجمالي
  int get totalWords => words.length;
  
  // عدد الأسئلة
  int get totalQuestions => questions.length;
  
  // عدد الأحرف
  int get totalLetters => letters.length;
  
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
      return {
        'question': questions[index],
        'word': words[index],
      };
    }
    return {};
  }
  
  @override
  String toString() {
    return 'LevelData(gridSize: $gridSize, totalWords: $totalWords, totalLetters: $totalLetters, difficulty: $difficulty)';
  }
}