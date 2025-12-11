import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../../data/models/grid_position.dart';
import '../../../data/models/level_data_model.dart';
import '../../../services/service_locator.dart';
import '../../widgets/common/gradient_background.dart';
import '../../widgets/dialogs/exit_dialog.dart';
import '../../widgets/dialogs/hint_dialog.dart';
import '../../widgets/dialogs/success_dialog.dart';
import '../../widgets/game/questions_carousel.dart';
import '../../widgets/game/word_grid.dart';

/// شاشة اللعب الرئيسية المحسنة
class GameLevelScreen extends StatefulWidget {
  final LevelDataModel level;

  const GameLevelScreen({super.key, required this.level});

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
  late AnimationController _pulseController;
  late AnimationController _headerAnimController;

  late Animation<double> _shakeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _headerSlideAnimation;
  late Animation<double> _headerFadeAnimation;

  int _score = 0;
  int _hintsAvailable = 0;
  bool _usedHints = false;

  final Map<String, List<GridPosition>> _wordPositionsMap = {};
  Set<String> foundWords = {};
  final Set<String> _usedCells = {};

  late Stopwatch _stopwatch;
  Timer? _timer;
  int _elapsedSeconds = 0;

  late int _gridRows;
  late int _gridCols;

  @override
  void initState() {
    super.initState();
    _setStatusBar();
    _initializeLevel();
    _setupAnimations();
    _startTimer();
    _loadHintsFromProgress();
    _startEntryAnimations();
  }

  void _setStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  void _initializeLevel() {
    levelData = widget.level;
    wordFound = List.generate(levelData.words.length, (_) => false);

    _gridRows = levelData.gridRows;
    _gridCols = levelData.gridCols;

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
          final result = _searchWordDFS(word, 0, row, col, [], visited);
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
    if (row < 0 || row >= _gridRows) return [];
    if (col < 0 || col >= levelData.gridLetters[row].length) return [];

    final cellKey = '${row}_$col';
    if (visited.contains(cellKey)) return [];
    if (levelData.getLetterAt(row, col) != word[charIndex]) return [];

    final newPath = List<GridPosition>.from(currentPath)
      ..add(GridPosition(row, col));
    final newVisited = Set<String>.from(visited)..add(cellKey);

    if (charIndex == word.length - 1) return newPath;

    final directions = [
      [-1, -1], [-1, 0], [-1, 1],
      [0, -1],           [0, 1],
      [1, -1],  [1, 0],  [1, 1],
    ];

    for (var dir in directions) {
      final result = _searchWordDFS(
        word,
        charIndex + 1,
        row + dir[0],
        col + dir[1],
        newPath,
        newVisited,
      );
      if (result.isNotEmpty) return result;
    }

    return [];
  }

  void _loadHintsFromProgress() {
    final stats = gameRepository.getStatistics();
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
    _shakeAnimation = Tween<double>(begin: 0, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);

    _successController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _headerAnimController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _headerSlideAnimation = Tween<double>(begin: -50, end: 0).animate(
      CurvedAnimation(
        parent: _headerAnimController,
        curve: Curves.easeOutCubic,
      ),
    );

    _headerFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _headerAnimController,
        curve: Curves.easeOut,
      ),
    );
  }

  void _startEntryAnimations() {
    _headerAnimController.forward();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    _shakeController.dispose();
    _successController.dispose();
    _pulseController.dispose();
    _headerAnimController.dispose();
    super.dispose();
  }

  void _handlePanStart(Offset position, BoxConstraints constraints) {
    _handleTouch(position, constraints);
  }

  void _handlePanUpdate(Offset position, BoxConstraints constraints) {
    _handleTouch(position, constraints);
  }

  void _handleTouch(Offset position, BoxConstraints constraints) {
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

    if (row >= 0 &&
        row < _gridRows &&
        col >= 0 &&
        col < levelData.gridLetters[row].length) {
      _onCellTouch(row, col);
    }
  }

  void _onCellTouch(int row, int col) {
    final position = GridPosition(row, col);
    final cellKey = position.key;

    if (_usedCells.contains(cellKey)) return;

    if (selectedPositions.isEmpty) {
      if (gameRepository.isVibrationEnabled) {
        HapticUtils.lightImpact();
      }
      setState(() {
        selectedPositions.add(position);
        currentWord = levelData.getLetterAt(row, col);
      });
      return;
    }

    if (selectedPositions.any((p) => p.row == row && p.col == col)) return;

    final lastPosition = selectedPositions.last;
    final isValidMove = position.isAdjacentTo(lastPosition);

    if (isValidMove) {
      if (gameRepository.isVibrationEnabled) {
        HapticUtils.lightImpact();
      }
      setState(() {
        selectedPositions.add(position);
        currentWord += levelData.getLetterAt(row, col);
      });
    } else {
      if (gameRepository.isVibrationEnabled) {
        HapticUtils.heavyImpact();
      }
      _shakeController.forward(from: 0);
    }
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
        if (_usedCells.contains(pos.key)) {
          allCellsAvailable = false;
          break;
        }
      }

      if (allCellsAvailable) {
        if (gameRepository.isVibrationEnabled) {
          HapticUtils.mediumImpact();
        }

        setState(() {
          wordFound[wordIndex] = true;
          foundWords.add(currentWord);
          _score += currentWord.length * 10;

          for (var pos in selectedPositions) {
            _usedCells.add(pos.key);
          }
        });

        _successController.forward(from: 0);

        if (foundWords.length == levelData.words.length) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            _completeLevel();
          });
        }
      } else {
        if (gameRepository.isVibrationEnabled) {
          HapticUtils.heavyImpact();
        }
        _shakeController.forward(from: 0);
      }
    } else {
      if (gameRepository.isVibrationEnabled) {
        HapticUtils.heavyImpact();
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

    await gameRepository.useHint();

    if (gameRepository.isVibrationEnabled) {
      HapticUtils.mediumImpact();
    }

    if (mounted) showHintDialog(context, hintIndex, levelData);
  }

  Future<void> _completeLevel() async {
    _timer?.cancel();
    _stopwatch.stop();

    await gameRepository.completeLevel(
      levelNumber: levelData.levelNumber,
      score: _score,
      foundWords: foundWords.toList(),
      timeSpent: _elapsedSeconds,
      usedHints: _usedHints,
    );

    if (gameRepository.isVibrationEnabled) {
      HapticUtils.heavyImpact();
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

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await showExitDialog(context);
        if (shouldPop == true && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: GradientBackground(
          showOverlay: true,
          child: SafeArea(
            child: Column(
              children: [
                _buildAnimatedHeader(),
                const SizedBox(height: AppDimens.paddingSM),
                _buildQuestionsSection(),
                const Spacer(),
                _buildGameGrid(),
                const Spacer(),
                _buildHintButton(),
                const SizedBox(height: AppDimens.paddingLG),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader() {
    return AnimatedBuilder(
      animation: _headerAnimController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _headerSlideAnimation.value),
          child: Opacity(
            opacity: _headerFadeAnimation.value,
            child: _buildHeader(),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.paddingMD),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // شارة النقاط
          _buildScoreBadge(),

          // رقم المستوى والوقت
          _buildLevelInfo(),

          // زر الرجوع
          _buildBackButton(),
        ],
      ),
    );
  }

  Widget _buildScoreBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingMD,
        vertical: AppDimens.paddingSM,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: AppColors.scoreGradient),
        borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.scoreColor.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.diamond, color: Colors.white, size: 22),
          const SizedBox(width: AppDimens.paddingSM),
          Text(
            '$_score',
            style: AppTextStyles.button.copyWith(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingMD,
        vertical: AppDimens.paddingSM,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        boxShadow: AppShadows.medium,
      ),
      child: Column(
        children: [
          Text(
            'المستوى ${levelData.levelNumber}',
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timer_outlined,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                _formatTime(_elapsedSeconds),
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () async {
        final shouldPop = await showExitDialog(context);
        if (shouldPop == true && mounted) {
          Navigator.pop(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(AppDimens.paddingSM + 4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: AppColors.primaryGradient),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Icon(Icons.home_rounded, color: Colors.white, size: 26),
      ),
    );
  }

  Widget _buildQuestionsSection() {
    return QuestionsCarousel(
      levelData: levelData,
      wordFound: wordFound,
      elapsedSeconds: _elapsedSeconds,
      foundWordsCount: foundWords.length,
    );
  }

  Widget _buildGameGrid() {
    return WordGrid(
      levelData: levelData,
      selectedPositions: selectedPositions,
      usedCells: _usedCells,
      foundWords: foundWords,
      wordPositionsMap: _wordPositionsMap,
      shakeAnimation: _shakeAnimation,
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _onRelease,
    );
  }

  Widget _buildHintButton() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        final isAvailable = _hintsAvailable > 0;
        return Transform.scale(
          scale: isAvailable ? _pulseAnimation.value : 1.0,
          child: GestureDetector(
            onTap: _useHint,
            child: Container(
              width: AppDimens.fabSizeLG,
              height: AppDimens.fabSizeLG,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isAvailable
                      ? AppColors.hintGradient
                      : [AppColors.levelLocked, AppColors.levelLockedDark],
                ),
                shape: BoxShape.circle,
                boxShadow: isAvailable
                    ? [
                        BoxShadow(
                          color: AppColors.hintColor.withValues(alpha: 0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : AppShadows.medium,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.lightbulb_rounded,
                    color: Colors.white,
                    size: AppDimens.iconXL,
                  ),
                  // عداد التلميحات
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                        boxShadow: AppShadows.small,
                      ),
                      child: Text(
                        '$_hintsAvailable',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: isAvailable
                              ? AppColors.hintColor
                              : AppColors.textTertiary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
