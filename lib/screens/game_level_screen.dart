import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/services/game_progress_service.dart';
import '../core/data/game_database.dart';

class GameLevelScreen extends StatefulWidget {
  const GameLevelScreen({super.key, required this.level});
  final LevelData level;

  @override
  State<GameLevelScreen> createState() => _GameLevelScreenState();
}

class _GameLevelScreenState extends State<GameLevelScreen>
    with TickerProviderStateMixin {
  late LevelData levelData;
  late List<bool> wordFound;

  List<GridPosition> selectedPositions = [];
  String currentWord = '';

  late AnimationController _shakeController;
  late AnimationController _successController;
  late AnimationController _celebrationController;
  late Animation<double> _shakeAnimation;

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

  @override
  void initState() {
    super.initState();
    _initializeLevel();
    _setupAnimations();
    _startTimer();
    _loadHintsFromProgress();
  }

  void _initializeLevel() {
    levelData = widget.level;
    wordFound = List.generate(levelData.words.length, (_) => false);

    // إيجاد مواقع كل كلمة في الشبكة
    for (var word in levelData.words) {
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

    for (int row = 0; row < levelData.gridSize; row++) {
      for (int col = 0; col < levelData.gridSize; col++) {
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
          newRow >= levelData.gridSize ||
          newCol < 0 ||
          newCol >= levelData.gridSize) {
        return [];
      }

      if (levelData.getLetterAt(newRow, newCol) != word[i]) {
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

  void _onRelease() {
    if (currentWord.isEmpty) {
      setState(() {
        selectedPositions.clear();
      });
      return;
    }

    final wordIndex = levelData.words.indexOf(currentWord);
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

          // إضافة الخلايا المستخدمة إلى القائمة
          for (var pos in selectedPositions) {
            _usedCells.add('${pos.row}_${pos.col}');
          }
        });

        if (foundWords.length == levelData.words.length) {
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
                    levelData.questions[wordIndex],
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
                    levelData.words[wordIndex],
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
      levelNumber: levelData.levelNumber,
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
    final levelProgress = progressService.getLevelProgress(
      levelData.levelNumber,
    );
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
                "لقد أكملت المستوى ${levelData.levelNumber}",
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
                      '${foundWords.length}/${levelData.words.length}',
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
                const SizedBox(height: 8.0),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
              ],
            ),
            child: Text(
              'المستوى ${levelData.levelNumber}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5B6B8C),
              ),
            ),
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
    final minutes = _elapsedSeconds ~/ 60;
    final seconds = _elapsedSeconds % 60;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16.0,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16.0,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
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
                      '${foundWords.length}/${levelData.words.length}',
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
        ),
        SizedBox(
          height: 80,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.8),
            itemCount: levelData.questions.length,
            itemBuilder: (context, index) {
              final isFound = wordFound[index];

              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 80.0,
                    width: MediaQuery.of(context).size.width * 0.8,
                    margin: const EdgeInsets.only(
                      right: 12,
                      left: 12,
                      bottom: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        levelData.questions[index],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF060707),
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                  if (isFound)
                    Positioned(
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          levelData.words[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  /// Build the game grid
  Widget _buildGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(sin(_shakeAnimation.value) * 3, 0),
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
                      children: List.generate(levelData.gridSize, (row) {
                        return Expanded(
                          child: Row(
                            children: List.generate(levelData.gridSize, (col) {
                              return Expanded(child: _buildGridCell(row, col));
                            }),
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleTouch(Offset position, BoxConstraints constraints) {
    final cellSize = constraints.maxWidth / levelData.gridSize;

    // حساب العمود بناءً على اتجاه النص
    final textDirection = Directionality.of(context);
    int col;

    if (textDirection == TextDirection.rtl) {
      // في حالة RTL، نعكس حساب العمود
      col = (levelData.gridSize - 1 - (position.dx / cellSize).floor());
    } else {
      // في حالة LTR، الحساب الطبيعي
      col = (position.dx / cellSize).floor();
    }

    final row = (position.dy / cellSize).floor();

    if (row >= 0 &&
        row < levelData.gridSize &&
        col >= 0 &&
        col < levelData.gridSize) {
      _onCellTouch(row, col);
    }
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
        currentWord = levelData.getLetterAt(row, col);
      });
      return;
    }

    // التحقق إذا كانت الخلية محددة مسبقاً
    if (selectedPositions.any((p) => p.row == row && p.col == col)) {
      return;
    }

    final lastPosition = selectedPositions.last;
    final rowDiff = (row - lastPosition.row).abs();
    final colDiff = (col - lastPosition.col).abs();

    // السماح فقط بالحركة الأفقية أو العمودية (منع القطرية)
    // الحركة الصحيحة: خطوة واحدة أفقياً أو عمودياً فقط
    bool isValidMove =
        (rowDiff == 1 && colDiff == 0) || // حركة عمودية
        (rowDiff == 0 && colDiff == 1); // حركة أفقية

    if (isValidMove) {
      if (progressService.isVibrationEnabled) {
        HapticFeedback.lightImpact();
      }
      setState(() {
        selectedPositions.add(position);
        currentWord += levelData.getLetterAt(row, col);
      });
    } else {
      // حركة غير صالحة - قطرية أو بعيدة
      if (progressService.isVibrationEnabled) {
        HapticFeedback.heavyImpact();
      }
      _shakeController.forward(from: 0);
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
        color: isSelected
            ? const Color(0xFF4DD4AC)
            : isUsed || isPartOfFoundWord
            ? const Color(0xFF4CAF50).withOpacity(0.7)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          levelData.getLetterAt(row, col),
          style: TextStyle(
            fontSize: levelData.gridSize <= 4
                ? 32
                : levelData.gridSize <= 6
                ? 24
                : 20,
            fontWeight: FontWeight.bold,
            color: isSelected || isPartOfFoundWord || isUsed
                ? Colors.white
                : const Color(0xFF5B6B8C),
            decorationColor: Colors.white,
            decorationThickness: 2,
          ),
        ),
      ),
    );
  }

  // build bottom actions
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
