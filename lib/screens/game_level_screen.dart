import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/services/game_progress_service.dart';
import '../core/data/game_level.dart';

class NatureWordGameScreen extends StatefulWidget {
  final int levelNumber;
  const NatureWordGameScreen({super.key, required this.levelNumber});

  @override
  State<NatureWordGameScreen> createState() => _NatureWordGameScreenState();
}

class _NatureWordGameScreenState extends State<NatureWordGameScreen>
    with TickerProviderStateMixin {
  late List<String> questions;
  late List<String> words;
  late List<String> letters;
  late List<bool> wordFound;
  late List<List<String>> grid;
  late int gridSize;

  List<GridPosition> selectedPositions = [];
  String currentWord = '';

  late AnimationController _shakeController;
  late AnimationController _successController;
  late AnimationController _celebrationController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _scaleAnimation;

  int _score = 0;
  int _hintsAvailable = 0;
  bool _usedHints = false;

  final Map<String, List<GridPosition>> _wordPositionsMap = {};
  Set<String> foundWords = {};

  // الخلايا المستخدمة (لمنع إعادة استخدامها)
  final Set<String> _usedCells = {};

  // مؤقت اللعب
  late Stopwatch _stopwatch;
  Timer? _timer;
  int _elapsedSeconds = 0;

  // للرسوم المتحركة
  int? _currentQuestionIndex;

  @override
  void initState() {
    super.initState();
    _initializeLevel();
    _setupAnimations();
    _startTimer();
    _loadHintsFromProgress();
  }

  void _initializeLevel() {
    final levelData = GameLevelsDatabase.getLevel(widget.levelNumber);

    if (levelData == null) {
      gridSize = 4;
      questions = ['سؤال 1', 'سؤال 2', 'سؤال 3', 'سؤال 4'];
      words = ['كلمة', 'كلم', 'لمة', 'كلة'];
      letters = List.generate(16, (_) => 'ك');
    } else {
      gridSize = levelData.gridSize;
      questions = levelData.questions;
      words = levelData.words;
      letters = levelData.letters;
    }

    wordFound = List.generate(words.length, (_) => false);
    _generateGridFromLetters();
  }

  void _generateGridFromLetters() {
    // إنشاء الشبكة من الأحرف المعطاة
    grid = List.generate(gridSize, (i) {
      return List.generate(gridSize, (j) {
        final index = i * gridSize + j;
        return index < letters.length ? letters[index] : '';
      });
    });

    // إيجاد مواقع كل كلمة في الشبكة
    for (var word in words) {
      final positions = _findWordInGrid(word);
      if (positions.isNotEmpty) {
        _wordPositionsMap[word] = positions;
      }
    }
  }

  List<GridPosition> _findWordInGrid(String word) {
    // البحث في جميع الاتجاهات الممكنة
    final directions = [
      [0, 1], // يمين
      [1, 0], // أسفل
      [1, 1], // قطري يمين-أسفل
      [1, -1], // قطري يسار-أسفل
      [0, -1], // يسار
      [-1, 0], // أعلى
      [-1, -1], // قطري يسار-أعلى
      [-1, 1], // قطري يمين-أعلى
    ];

    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        for (var dir in directions) {
          final positions = _checkWordAtPosition(
            word,
            row,
            col,
            dir[0],
            dir[1],
          );
          if (positions.isNotEmpty) {
            return positions;
          }
        }
      }
    }
    return [];
  }

  List<GridPosition> _checkWordAtPosition(
    String word,
    int row,
    int col,
    int dRow,
    int dCol,
  ) {
    List<GridPosition> positions = [];

    for (int i = 0; i < word.length; i++) {
      final newRow = row + (i * dRow);
      final newCol = col + (i * dCol);

      if (newRow < 0 ||
          newRow >= gridSize ||
          newCol < 0 ||
          newCol >= gridSize) {
        return [];
      }

      if (grid[newRow][newCol] != word[i]) {
        return [];
      }

      positions.add(GridPosition(newRow, newCol));
    }

    return positions;
  }

  void _loadHintsFromProgress() {
    final stats = progressService.getStatistics();
    setState(() {
      _hintsAvailable = stats['hintsRemaining'] as int;
    });
  }

  void _startTimer() {
    _stopwatch = Stopwatch()..start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _elapsedSeconds = _stopwatch.elapsed.inSeconds;
        });
      }
    });
  }

  void _setupAnimations() {
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);

    _successController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).chain(CurveTween(curve: Curves.elasticOut)).animate(_successController);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    _shakeController.dispose();
    _successController.dispose();
    _celebrationController.dispose();
    super.dispose();
  }

  void _onCellTouch(int row, int col) {
    final position = GridPosition(row, col);
    final cellKey = '${row}_$col';

    // منع اختيار خلية مستخدمة مسبقاً
    if (_usedCells.contains(cellKey)) {
      return;
    }

    if (selectedPositions.isEmpty) {
      if (progressService.isVibrationEnabled) {
        HapticFeedback.lightImpact();
      }
      setState(() {
        selectedPositions.add(position);
        currentWord = grid[row][col];
      });
      return;
    }

    if (selectedPositions.any((p) => p.row == row && p.col == col)) {
      return;
    }

    final lastPosition = selectedPositions.last;
    final rowDiff = (row - lastPosition.row).abs();
    final colDiff = (col - lastPosition.col).abs();

    if (rowDiff <= 1 && colDiff <= 1 && (rowDiff + colDiff) > 0) {
      if (progressService.isVibrationEnabled) {
        HapticFeedback.lightImpact();
      }
      setState(() {
        selectedPositions.add(position);
        currentWord += grid[row][col];
      });
    }
  }

  void _onRelease() {
    if (currentWord.isEmpty) {
      setState(() {
        selectedPositions.clear();
      });
      return;
    }

    final wordIndex = words.indexOf(currentWord);
    if (wordIndex != -1 && !wordFound[wordIndex]) {
      // التحقق من أن جميع الخلايا المحددة غير مستخدمة مسبقاً
      bool allCellsAvailable = true;
      for (var pos in selectedPositions) {
        final cellKey = '${pos.row}_${pos.col}';
        if (_usedCells.contains(cellKey)) {
          allCellsAvailable = false;
          break;
        }
      }

      if (allCellsAvailable) {
        if (progressService.isVibrationEnabled) {
          HapticFeedback.mediumImpact();
        }

        setState(() {
          wordFound[wordIndex] = true;
          foundWords.add(currentWord);
          _score += currentWord.length * 10;
          _currentQuestionIndex = wordIndex;

          // إضافة الخلايا المستخدمة إلى القائمة
          for (var pos in selectedPositions) {
            _usedCells.add('${pos.row}_${pos.col}');
          }
        });

        _successController.forward(from: 0).then((_) {
          setState(() {
            _currentQuestionIndex = null;
          });
        });

        if (foundWords.length == words.length) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            _completeLevel();
          });
        }
      } else {
        // خلية مستخدمة مسبقاً
        if (progressService.isVibrationEnabled) {
          HapticFeedback.heavyImpact();
        }
        _shakeController.forward(from: 0);
      }
    } else {
      if (progressService.isVibrationEnabled) {
        HapticFeedback.heavyImpact();
      }
      _shakeController.forward(from: 0);
    }

    setState(() {
      currentWord = '';
      selectedPositions.clear();
    });
  }

  void _useHint() async {
    if (_hintsAvailable <= 0) {
      _showNoHintsDialog();
      return;
    }

    // إيجاد أول كلمة لم يتم العثور عليها
    int hintIndex = -1;
    for (int i = 0; i < wordFound.length; i++) {
      if (!wordFound[i]) {
        hintIndex = i;
        break;
      }
    }

    if (hintIndex == -1) return;

    setState(() {
      _hintsAvailable--;
      _usedHints = true;
    });

    await progressService.useHint();

    if (progressService.isVibrationEnabled) {
      HapticFeedback.mediumImpact();
    }

    _showHintDialog(hintIndex);
  }

  void _showHintDialog(int wordIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lightbulb, color: Colors.amber, size: 32),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'تلميح',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5B6B8C),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blue.shade200, width: 2),
              ),
              child: Column(
                children: [
                  const Text(
                    '❓ السؤال:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    questions[wordIndex],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5B6B8C),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber.shade300, Colors.amber.shade100],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const Text(
                    '✅ الإجابة:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.brown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    words[wordIndex],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF4DD4AC),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'حسناً',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
      ),
    );
  }

  void _showNoHintsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        backgroundColor: Colors.white,
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.block, color: Colors.red.shade400, size: 40),
            ),
            const SizedBox(height: 12),
            const Text(
              'لا توجد تلميحات',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'لقد استنفذت جميع التلميحات المتاحة!\nأكمل المزيد من المستويات للحصول على المزيد.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'حسناً',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
      ),
    );
  }

  Future<void> _completeLevel() async {
    _timer?.cancel();
    _stopwatch.stop();

    await progressService.completeLevel(
      levelNumber: widget.levelNumber,
      score: _score,
      foundWords: foundWords.toList(),
      timeSpent: _elapsedSeconds,
      usedHints: _usedHints,
    );

    if (progressService.isVibrationEnabled) {
      HapticFeedback.heavyImpact();
    }

    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    final levelProgress = progressService.getLevelProgress(widget.levelNumber);
    final stars = levelProgress?.stars ?? 1;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [const Color(0xFF4DD4AC), const Color(0xFF2E7D6A)],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // أيقونة الكأس مع رسوم متحركة
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.emoji_events,
                        size: 80,
                        color: Colors.amber,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text(
                "🎉 مبروك!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "لقد أكملت المستوى ${widget.levelNumber}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 20),
              // النجوم
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: Duration(milliseconds: 400 + (index * 200)),
                    curve: Curves.elasticOut,
                    builder: (context, double value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            Icons.star,
                            size: 50,
                            color: index < stars
                                ? Colors.amber
                                : Colors.white38,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              const SizedBox(height: 24),
              // الإحصائيات
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildStatRow('النقاط', '$_score', Icons.diamond),
                    const SizedBox(height: 12),
                    _buildStatRow('الوقت', '$_elapsedSecondsث', Icons.timer),
                    const SizedBox(height: 12),
                    _buildStatRow(
                      'الكلمات',
                      '${foundWords.length}/${words.length}',
                      Icons.check_circle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // زر المتابعة
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF2E7D6A),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 5,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, {'completed': true, 'score': _score});
                },
                child: const Text(
                  "المتابعة",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await _showExitDialog();
        return shouldPop ?? false;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF4DD4AC).withOpacity(0.3),
                const Color(0xFF5B9FE3).withOpacity(0.3),
                const Color(0xFFE8B4F0).withOpacity(0.2),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 12),
                _buildQuestionsCard(),
                const Spacer(),
                _buildGrid(),
                const Spacer(),
                _buildBottomActions(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final minutes = _elapsedSeconds ~/ 60;
    final seconds = _elapsedSeconds % 60;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // النقاط
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyan.shade300, Colors.cyan.shade100],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyan.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.diamond, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  '$_score',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // المستوى والوقت
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Text(
                  'المستوى ${widget.levelNumber}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5B6B8C),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade300, Colors.orange.shade100],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer, size: 18, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // زر الرجوع
          GestureDetector(
            onTap: () async {
              final shouldPop = await _showExitDialog();
              if (shouldPop == true && mounted) {
                Navigator.pop(context);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFF4DD4AC), const Color(0xFF2E7D6A)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4DD4AC).withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(Icons.home, color: Colors.white, size: 26),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'خذف أو شجار بين طرفين',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5B6B8C),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF4DD4AC), const Color(0xFF2E7D6A)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${foundWords.length}/${words.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final isFound = wordFound[index];
                final isAnimating = _currentQuestionIndex == index;

                return AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: isAnimating ? _scaleAnimation.value : 1.0,
                      child: Container(
                        width: 180,
                        margin: const EdgeInsets.only(left: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: isFound
                              ? LinearGradient(
                                  colors: [
                                    const Color(0xFF4CAF50),
                                    const Color(0xFF66BB6A),
                                  ],
                                )
                              : LinearGradient(
                                  colors: [
                                    Colors.grey.shade100,
                                    Colors.grey.shade200,
                                  ],
                                ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isFound
                                ? const Color(0xFF4CAF50)
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                          boxShadow: [
                            if (isFound)
                              BoxShadow(
                                color: const Color(0xFF4CAF50).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: isFound
                                        ? Colors.white
                                        : Colors.grey.shade300,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: isFound
                                        ? const Icon(
                                            Icons.check,
                                            color: Color(0xFF4CAF50),
                                            size: 16,
                                          )
                                        : Text(
                                            '${index + 1}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade600,
                                              fontSize: 12,
                                            ),
                                          ),
                                  ),
                                ),
                                const Spacer(),
                                if (isFound)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      words[index],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              questions[index],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isFound
                                    ? Colors.white
                                    : const Color(0xFF5B6B8C),
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: AspectRatio(
        aspectRatio: 1,
        child: AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(sin(_shakeAnimation.value) * 3, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(8),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      onPanStart: (details) {
                        _handleTouch(details.localPosition, constraints);
                      },
                      onPanUpdate: (details) {
                        _handleTouch(details.localPosition, constraints);
                      },
                      onPanEnd: (_) => _onRelease(),
                      child: Column(
                        children: List.generate(gridSize, (row) {
                          return Expanded(
                            child: Row(
                              children: List.generate(gridSize, (col) {
                                return Expanded(
                                  child: _buildGridCell(row, col),
                                );
                              }),
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleTouch(Offset position, BoxConstraints constraints) {
    final cellSize = constraints.maxWidth / gridSize;

    final col = (position.dx / cellSize).floor();
    final row = (position.dy / cellSize).floor();

    if (row >= 0 && row < gridSize && col >= 0 && col < gridSize) {
      _onCellTouch(row, col);
    }
  }

  Widget _buildGridCell(int row, int col) {
    final cellKey = '${row}_$col';
    final isSelected = selectedPositions.any(
      (p) => p.row == row && p.col == col,
    );
    final isUsed = _usedCells.contains(cellKey);

    // التحقق إذا كانت الخلية جزء من كلمة تم إيجادها
    bool isPartOfFoundWord = false;
    for (var word in foundWords) {
      final positions = _wordPositionsMap[word];
      if (positions != null) {
        if (positions.any((p) => p.row == row && p.col == col)) {
          isPartOfFoundWord = true;
          break;
        }
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
                colors: [const Color(0xFF4DD4AC), const Color(0xFF2E7D6A)],
              )
            : isUsed || isPartOfFoundWord
            ? LinearGradient(
                colors: [
                  const Color(0xFF4CAF50).withOpacity(0.7),
                  const Color(0xFF66BB6A).withOpacity(0.7),
                ],
              )
            : LinearGradient(
                colors: [Colors.grey.shade100, Colors.grey.shade200],
              ),
        borderRadius: BorderRadius.circular(12),
        border: isUsed
            ? Border.all(color: const Color(0xFF4CAF50), width: 2)
            : null,
        boxShadow: [
          if (isSelected || isPartOfFoundWord)
            BoxShadow(
              color:
                  (isSelected
                          ? const Color(0xFF4DD4AC)
                          : const Color(0xFF4CAF50))
                      .withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              grid[row][col],
              style: TextStyle(
                fontSize: gridSize <= 4
                    ? 32
                    : gridSize <= 6
                    ? 24
                    : 20,
                fontWeight: FontWeight.bold,
                color: isSelected || isPartOfFoundWord || isUsed
                    ? Colors.white
                    : const Color(0xFF5B6B8C),
                decoration: isUsed ? TextDecoration.lineThrough : null,
                decorationColor: Colors.white,
                decorationThickness: 2,
              ),
            ),
          ),
          if (isUsed)
            Positioned(
              top: 2,
              right: 2,
              child: Icon(
                Icons.lock,
                size: 12,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildActionButton(
            icon: Icons.lightbulb,
            gradient: LinearGradient(
              colors: [Colors.amber.shade400, Colors.orange.shade300],
            ),
            count: '$_hintsAvailable',
            onTap: _useHint,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Gradient gradient,
    required String count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          gradient: gradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Text(
                  count,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showExitDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        backgroundColor: Colors.white,
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange.shade600,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'الخروج من المستوى؟',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'سيتم فقدان تقدمك الحالي في هذا المستوى.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.grey.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'إلغاء',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'الخروج',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      ),
    );
  }
}

class GridPosition {
  final int row;
  final int col;

  GridPosition(this.row, this.col);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GridPosition &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;
}
