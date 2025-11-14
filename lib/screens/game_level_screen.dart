import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/services/game_progress_service.dart';
import '../core/data/game_database.dart';
import '../widgets/build_action_button.dart';
import '../widgets/show_exit_dialog.dart';
import '../widgets/show_hint_dialog.dart';
import '../widgets/show_success_dialog.dart';

class GameLevelScreen extends StatefulWidget {
  const GameLevelScreen({super.key, required this.level});
  final LevelDataModel level;

  @override
  State<GameLevelScreen> createState() => _GameLevelScreenState();
}

class _GameLevelScreenState extends State<GameLevelScreen>
    with TickerProviderStateMixin {
  late LevelDataModel levelData;
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

  final Set<String> _usedCells = {};

  late Stopwatch _stopwatch;
  Timer? _timer;
  int _elapsedSeconds = 0;

  // إضافة متغيرات لتتبع أبعاد الشبكة الحقيقية
  late int _gridRows;
  late int _gridCols;

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

    // حساب أبعاد الشبكة الحقيقية
    _gridRows = levelData.gridLetters.length;
    _gridCols = levelData.gridLetters.isEmpty 
        ? 0 
        : levelData.gridLetters.map((row) => row.length).reduce(max);

    // إيجاد مواقع كل كلمة في الشبكة
    for (var word in levelData.words) {
      final positions = _findWordInGridDynamic(word);
      if (positions.isNotEmpty) {
        _wordPositionsMap[word] = positions;
      }
    }
  }

  List<GridPosition> _findWordInGridDynamic(String word) {
    if (word.isEmpty) return [];

    for (int row = 0; row < _gridRows; row++) {
      for (int col = 0; col < levelData.gridLetters[row].length; col++) {
        if (levelData.getLetterAt(row, col) == word[0]) {
          final visited = <String>{};
          final result = _searchWordDFS(
            word,
            0,
            row,
            col,
            [],
            visited,
          );
          if (result.isNotEmpty) {
            return result;
          }
        }
      }
    }
    return [];
  }

  List<GridPosition> _searchWordDFS(
    String word,
    int charIndex,
    int row,
    int col,
    List<GridPosition> currentPath,
    Set<String> visited,
  ) {
    // التحقق من الحدود بشكل صحيح
    if (row < 0 || row >= _gridRows) {
      return [];
    }
    
    // التحقق من طول السطر الحالي
    if (col < 0 || col >= levelData.gridLetters[row].length) {
      return [];
    }

    final cellKey = '${row}_$col';
    
    if (visited.contains(cellKey)) {
      return [];
    }

    if (levelData.getLetterAt(row, col) != word[charIndex]) {
      return [];
    }

    final newPath = List<GridPosition>.from(currentPath)
      ..add(GridPosition(row, col));
    final newVisited = Set<String>.from(visited)..add(cellKey);

    if (charIndex == word.length - 1) {
      return newPath;
    }

    // الاتجاهات الثمانية
    final directions = [
      [-1, -1], [-1, 0], [-1, 1],
      [0, -1],           [0, 1],
      [1, -1],  [1, 0],  [1, 1],
    ];

    for (var dir in directions) {
      final newRow = row + dir[0];
      final newCol = col + dir[1];

      final result = _searchWordDFS(
        word,
        charIndex + 1,
        newRow,
        newCol,
        newPath,
        newVisited,
      );

      if (result.isNotEmpty) {
        return result;
      }
    }

    return [];
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
      showNoHintsDialog(context);
      return;
    }

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

    if (mounted) showHintDialog(context, hintIndex, levelData);
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

    if (mounted) {
      showSuccessDialog(
        context,
        levelData,
        _score,
        _elapsedSeconds,
        foundWords.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showExitDialog(context);
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
                BuildActionButton(
                  icon: Icons.lightbulb,
                  gradient: LinearGradient(
                    colors: [Colors.amber.shade400, Colors.orange.shade300],
                  ),
                  count: '$_hintsAvailable',
                  onTap: _useHint,
                ),
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
          GestureDetector(
            onTap: () async {
              final shouldPop = await showExitDialog(context);
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

  Widget _buildGrid() {
    final double horizontal = levelData.horizontal;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal),
      child: AspectRatio(
        // نسبة العرض إلى الارتفاع بناءً على أبعاد الشبكة الفعلية
        aspectRatio: _gridCols / _gridRows,
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
                      children: List.generate(_gridRows, (row) {
                        return Expanded(
                          child: Row(
                            children: List.generate(
                              levelData.gridLetters[row].length,
                              (col) {
                                return Expanded(
                                  child: _buildGridCell(row, col),
                                );
                              },
                            ),
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
    // حساب حجم الخلية بناءً على الأبعاد الحقيقية
    final cellWidth = constraints.maxWidth / _gridCols;
    final cellHeight = constraints.maxHeight / _gridRows;

    final textDirection = Directionality.of(context);
    int col;

    if (textDirection == TextDirection.rtl) {
      col = _gridCols - 1 - (position.dx / cellWidth).floor();
    } else {
      col = (position.dx / cellWidth).floor();
    }

    final row = (position.dy / cellHeight).floor();

    // التحقق من الحدود الصحيحة
    if (row >= 0 && row < _gridRows && 
        col >= 0 && col < levelData.gridLetters[row].length) {
      _onCellTouch(row, col);
    }
  }

  void _onCellTouch(int row, int col) {
    final position = GridPosition(row, col);
    final cellKey = '${row}_$col';

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

    if (selectedPositions.any((p) => p.row == row && p.col == col)) {
      return;
    }

    final lastPosition = selectedPositions.last;
    final rowDiff = (row - lastPosition.row).abs();
    final colDiff = (col - lastPosition.col).abs();

    bool isValidMove =
        (rowDiff == 1 && colDiff == 0) ||
        (rowDiff == 0 && colDiff == 1);

    if (isValidMove) {
      if (progressService.isVibrationEnabled) {
        HapticFeedback.lightImpact();
      }
      setState(() {
        selectedPositions.add(position);
        currentWord += levelData.getLetterAt(row, col);
      });
    } else {
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
            ? const Color(0xFF4CAF50)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          levelData.getLetterAt(row, col),
          style: TextStyle(
            fontSize: levelData.horizontal - 4,
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