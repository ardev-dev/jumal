class GameLevelsDatabase {
  // قاعدة البيانات الكاملة للمستويات
  static Map<int, LevelData> getAllLevels() {
    return {
      // المستويات 1-9: شبكة 3×3 (3 كلمات × 3 أحرف)
      1: LevelData(
        gridSize: 3,
        targetWord: 'سلم',
        extraWords: ['سلس', 'لسم'],
      ),
      2: LevelData(
        gridSize: 3,
        targetWord: 'قلم',
        extraWords: ['قلق', 'ملق'],
      ),
      3: LevelData(
        gridSize: 3,
        targetWord: 'نور',
        extraWords: ['نون', 'رون'],
      ),
      4: LevelData(
        gridSize: 3,
        targetWord: 'بحر',
        extraWords: ['بحب', 'حرب'],
      ),
      5: LevelData(
        gridSize: 3,
        targetWord: 'شمس',
        extraWords: ['شمش', 'مسم'],
      ),
      6: LevelData(
        gridSize: 3,
        targetWord: 'زهر',
        extraWords: ['زهز', 'هرز'],
      ),
      7: LevelData(
        gridSize: 3,
        targetWord: 'عصر',
        extraWords: ['عصع', 'صرع'],
      ),
      8: LevelData(
        gridSize: 3,
        targetWord: 'فجر',
        extraWords: ['فجف', 'جرف'],
      ),
      9: LevelData(
        gridSize: 3,
        targetWord: 'طير',
        extraWords: ['طيط', 'يرط'],
      ),
      
      // المستويات 10-18: شبكة 4×4 (4 كلمات × 4 أحرف)
      10: LevelData(
        gridSize: 4,
        targetWord: 'كتاب',
        extraWords: ['كتب', 'تاب', 'كات'],
      ),
      11: LevelData(
        gridSize: 4,
        targetWord: 'سماء',
        extraWords: ['سما', 'ماء', 'سمس'],
      ),
      12: LevelData(
        gridSize: 4,
        targetWord: 'جبال',
        extraWords: ['جبل', 'بال', 'جال'],
      ),
      13: LevelData(
        gridSize: 4,
        targetWord: 'نهار',
        extraWords: ['نهر', 'هار', 'نار'],
      ),
      14: LevelData(
        gridSize: 4,
        targetWord: 'ليال',
        extraWords: ['ليل', 'يال', 'لال'],
      ),
      15: LevelData(
        gridSize: 4,
        targetWord: 'قمار',
        extraWords: ['قمر', 'مار', 'قار'],
      ),
      16: LevelData(
        gridSize: 4,
        targetWord: 'بحار',
        extraWords: ['بحر', 'حار', 'بار'],
      ),
      17: LevelData(
        gridSize: 4,
        targetWord: 'زهور',
        extraWords: ['زهر', 'هور', 'زور'],
      ),
      18: LevelData(
        gridSize: 4,
        targetWord: 'طيور',
        extraWords: ['طير', 'يور', 'طور'],
      ),
      
      // المستويات 19-27: شبكة 5×5 (5 كلمات × 5 أحرف)
      19: LevelData(
        gridSize: 5,
        targetWord: 'مدرسة',
        extraWords: ['مدر', 'درس', 'رسة', 'مدس'],
      ),
      20: LevelData(
        gridSize: 5,
        targetWord: 'برمجة',
        extraWords: ['برج', 'رمج', 'مجة', 'برم'],
      ),
      21: LevelData(
        gridSize: 5,
        targetWord: 'كلمات',
        extraWords: ['كلم', 'لما', 'مات', 'كلا'],
      ),
      22: LevelData(
        gridSize: 5,
        targetWord: 'وصلة',
        extraWords: ['وصل', 'صلة', 'وصة', 'لصة'],
      ),
      23: LevelData(
        gridSize: 5,
        targetWord: 'رسالة',
        extraWords: ['رسل', 'سال', 'الة', 'رسا'],
      ),
      24: LevelData(
        gridSize: 5,
        targetWord: 'عائلة',
        extraWords: ['عال', 'ائل', 'يلة', 'عاي'],
      ),
      25: LevelData(
        gridSize: 5,
        targetWord: 'مهنة',
        extraWords: ['مهن', 'هنة', 'منة', 'مهه'],
      ),
      26: LevelData(
        gridSize: 5,
        targetWord: 'هدية',
        extraWords: ['هدي', 'دية', 'هية', 'هدد'],
      ),
      27: LevelData(
        gridSize: 5,
        targetWord: 'قصيدة',
        extraWords: ['قصي', 'صيد', 'يدة', 'قصد'],
      ),
      
      // المستويات 28-36: شبكة 6×6 (6 كلمات × 6 أحرف)
      28: LevelData(
        gridSize: 6,
        targetWord: 'مكتبة',
        extraWords: ['مكتب', 'كتب', 'تبة', 'مكت', 'كتبة'],
      ),
      29: LevelData(
        gridSize: 6,
        targetWord: 'جامعة',
        extraWords: ['جام', 'امع', 'معة', 'جامع', 'جاع'],
      ),
      30: LevelData(
        gridSize: 6,
        targetWord: 'مستشفى',
        extraWords: ['مست', 'ستش', 'تشف', 'مسش', 'ستفى'],
      ),
      31: LevelData(
        gridSize: 6,
        targetWord: 'محطة',
        extraWords: ['محط', 'حطة', 'محة', 'مطة', 'حطط'],
      ),
      32: LevelData(
        gridSize: 6,
        targetWord: 'ساحة',
        extraWords: ['ساح', 'احة', 'سحة', 'ساة', 'حاة'],
      ),
      33: LevelData(
        gridSize: 6,
        targetWord: 'حديقة',
        extraWords: ['حدي', 'ديق', 'يقة', 'حدق', 'حدية'],
      ),
      34: LevelData(
        gridSize: 6,
        targetWord: 'مدينة',
        extraWords: ['مدي', 'دين', 'ينة', 'مدن', 'مدية'],
      ),
      35: LevelData(
        gridSize: 6,
        targetWord: 'قرية',
        extraWords: ['قري', 'رية', 'قية', 'قرر', 'ريية'],
      ),
      36: LevelData(
        gridSize: 6,
        targetWord: 'شارع',
        extraWords: ['شار', 'ارع', 'شاع', 'شرع', 'شاا'],
      ),
      
      // المستويات 37-45: شبكة 7×7 (7 كلمات × 7 أحرف)
      37: LevelData(
        gridSize: 7,
        targetWord: 'مطعم',
        extraWords: ['مطع', 'طعم', 'مطم', 'معم', 'طمم', 'مطط'],
      ),
      38: LevelData(
        gridSize: 7,
        targetWord: 'مقهى',
        extraWords: ['مقه', 'قهى', 'مقى', 'مهى', 'قهه', 'مقق'],
      ),
      39: LevelData(
        gridSize: 7,
        targetWord: 'متجر',
        extraWords: ['متج', 'تجر', 'مجر', 'متر', 'تتج', 'مجج'],
      ),
      40: LevelData(
        gridSize: 7,
        targetWord: 'سوق',
        extraWords: ['سوو', 'وقق', 'سوق', 'سقق', 'ووق', 'سسو'],
      ),
      41: LevelData(
        gridSize: 7,
        targetWord: 'منزل',
        extraWords: ['منز', 'نزل', 'مزل', 'منل', 'نزز', 'ممن'],
      ),
      42: LevelData(
        gridSize: 7,
        targetWord: 'مسجد',
        extraWords: ['مسج', 'سجد', 'مجد', 'مسد', 'سجج', 'مسس'],
      ),
      43: LevelData(
        gridSize: 7,
        targetWord: 'حمام',
        extraWords: ['حما', 'مام', 'حام', 'حمم', 'ماا', 'ححم'],
      ),
      44: LevelData(
        gridSize: 7,
        targetWord: 'مكان',
        extraWords: ['مكا', 'كان', 'مان', 'مكن', 'كاا', 'مكك'],
      ),
      45: LevelData(
        gridSize: 7,
        targetWord: 'زمان',
        extraWords: ['زما', 'مان', 'زان', 'زمن', 'ماا', 'ززم'],
      ),
      
      // المستويات 46-54: شبكة 8×8 (8 كلمات × 8 أحرف)
      46: LevelData(
        gridSize: 8,
        targetWord: 'صباح',
        extraWords: ['صبا', 'باح', 'صاح', 'صبح', 'باا', 'صصب', 'صبب'],
      ),
      47: LevelData(
        gridSize: 8,
        targetWord: 'مساء',
        extraWords: ['مسا', 'ساء', 'ماء', 'مسس', 'سااء', 'ممس', 'مساا'],
      ),
      48: LevelData(
        gridSize: 8,
        targetWord: 'ظهر',
        extraWords: ['ظهه', 'هرر', 'ظرر', 'ظهر', 'هرظ', 'ظظه', 'ظهه'],
      ),
      49: LevelData(
        gridSize: 8,
        targetWord: 'عصر',
        extraWords: ['عصص', 'صرر', 'عرر', 'عصر', 'صرع', 'ععص', 'عصع'],
      ),
      50: LevelData(
        gridSize: 8,
        targetWord: 'فجر',
        extraWords: ['فجج', 'جرر', 'فرر', 'فجر', 'جرف', 'ففج', 'فجف'],
      ),
      51: LevelData(
        gridSize: 8,
        targetWord: 'ليل',
        extraWords: ['ليي', 'يلل', 'لل', 'لي', 'يلي', 'للي', 'ليل'],
      ),
      52: LevelData(
        gridSize: 8,
        targetWord: 'نهار',
        extraWords: ['نها', 'هار', 'نار', 'نهر', 'هاا', 'ننه', 'نهه'],
      ),
      53: LevelData(
        gridSize: 8,
        targetWord: 'يوم',
        extraWords: ['يوو', 'ومم', 'يمم', 'يوم', 'ومي', 'ييو', 'يوي'],
      ),
      54: LevelData(
        gridSize: 8,
        targetWord: 'شهر',
        extraWords: ['شهه', 'هرر', 'شرر', 'شهر', 'هرش', 'ششه', 'شهش'],
      ),
      
      // المستويات 55-60: شبكة 9×9 (التحدي الأكبر)
      55: LevelData(
        gridSize: 9,
        targetWord: 'سنة',
        extraWords: ['سنن', 'نةة', 'سةة', 'سن', 'نة', 'سسن', 'سنس', 'نسس'],
      ),
      56: LevelData(
        gridSize: 9,
        targetWord: 'عام',
        extraWords: ['عاا', 'امم', 'عمم', 'عا', 'ام', 'ععا', 'عاع', 'امع'],
      ),
      57: LevelData(
        gridSize: 9,
        targetWord: 'قرن',
        extraWords: ['قرر', 'رنن', 'قنن', 'قر', 'رن', 'ققر', 'قرق', 'رنق'],
      ),
      58: LevelData(
        gridSize: 9,
        targetWord: 'زمن',
        extraWords: ['زمم', 'منن', 'زنن', 'زم', 'من', 'ززم', 'زمز', 'منز'],
      ),
      59: LevelData(
        gridSize: 9,
        targetWord: 'وقت',
        extraWords: ['وقق', 'قتت', 'وتت', 'وق', 'قت', 'ووق', 'وقو', 'قتو'],
      ),
      60: LevelData(
        gridSize: 9,
        targetWord: 'ساعة',
        extraWords: ['ساع', 'اعة', 'ساة', 'سا', 'عة', 'سسا', 'ساس', 'اعس'],
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
    // كل 9 مستويات تزيد الشبكة بمقدار 1
    if (levelNumber <= 9) return 3;
    if (levelNumber <= 18) return 4;
    if (levelNumber <= 27) return 5;
    if (levelNumber <= 36) return 6;
    if (levelNumber <= 45) return 7;
    if (levelNumber <= 54) return 8;
    return 9; // للمستويات 55+
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

// نموذج بيانات المستوى
class LevelData {
  final int gridSize;
  final String targetWord;
  final List<String> extraWords;
  
  LevelData({
    required this.gridSize,
    required this.targetWord,
    required this.extraWords,
  });
  
  // الحصول على جميع الكلمات (الهدف + الإضافية)
  List<String> get allWords => [targetWord, ...extraWords];
  
  // عدد الكلمات الإجمالي
  int get totalWords => allWords.length;
  
  // الصعوبة بناءً على حجم الشبكة
  String get difficulty {
    if (gridSize <= 3) return 'سهل';
    if (gridSize <= 5) return 'متوسط';
    if (gridSize <= 7) return 'صعب';
    return 'خبير';
  }
  
  // النقاط المتوقعة للمستوى
  int get expectedScore {
    return allWords.fold(0, (sum, word) => sum + (word.length * 10));
  }
  
  @override
  String toString() {
    return 'LevelData(gridSize: $gridSize, targetWord: $targetWord, totalWords: $totalWords, difficulty: $difficulty)';
  }
}