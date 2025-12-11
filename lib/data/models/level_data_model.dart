/// نموذج بيانات المستوى
class LevelDataModel {
  final int levelNumber;
  final List<String> questions;
  final List<String> words;
  final List<List<String>> gridLetters;

  LevelDataModel({
    required this.levelNumber,
    required this.questions,
    required this.words,
    required this.gridLetters,
  }) : assert(questions.length == words.length,
            'عدد الأسئلة يجب أن يساوي عدد الكلمات');

  /// عدد صفوف الشبكة
  int get gridRows => gridLetters.length;

  /// عدد أعمدة الشبكة
  int get gridCols =>
      gridLetters.isEmpty ? 0 : gridLetters.map((row) => row.length).reduce((a, b) => a > b ? a : b);

  /// عدد الكلمات الإجمالي
  int get totalWords => words.length;

  /// عدد الأسئلة
  int get totalQuestions => questions.length;

  /// المسافة الأفقية بناءً على حجم الشبكة
  double get horizontalPadding {
    switch (gridCols) {
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

  /// حجم خط الشبكة
  double get gridFontSize => horizontalPadding - 4;

  /// النقاط المتوقعة للمستوى
  int get expectedScore {
    return words.fold(0, (sum, word) => sum + (word.length * 10));
  }

  /// الحصول على سؤال وكلمة معينة
  ({String question, String word})? getQuestionAndWord(int index) {
    if (index >= 0 && index < words.length) {
      return (question: questions[index], word: words[index]);
    }
    return null;
  }

  /// الحصول على حرف في موقع معين
  String getLetterAt(int row, int col) {
    if (row >= 0 &&
        row < gridLetters.length &&
        col >= 0 &&
        col < gridLetters[row].length) {
      return gridLetters[row][col];
    }
    return '';
  }

  /// مستوى فارغ افتراضي
  factory LevelDataModel.empty() {
    return LevelDataModel(
      levelNumber: 0,
      questions: const ['عضو للشم', 'فاكهة صفراء', 'حيوان أليف'],
      words: const ['أنف', 'موز', 'قطة'],
      gridLetters: const [
        ['أ', 'ن', 'ف'],
        ['م', 'و', 'ز'],
        ['ق', 'ط', 'ة'],
      ],
    );
  }
}
