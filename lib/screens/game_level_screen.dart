import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/game_level.dart';

class GameConnectArrowScreen extends StatefulWidget {
  final int levelNumber;
  const GameConnectArrowScreen({super.key, required this.levelNumber});

  @override
  State<GameConnectArrowScreen> createState() => _GameConnectArrowScreenState();
}

class _GameConnectArrowScreenState extends State<GameConnectArrowScreen>
    with TickerProviderStateMixin {
  late String targetWord;
  late List<String> foundWords;
  late List<String> possibleWords;
  late List<List<String>> grid;
  late int gridSize;
  
  List<GridPosition> selectedPositions = [];
  String currentWord = '';
  
  late AnimationController _shakeController;
  late AnimationController _successController;
  late AnimationController _pulseController;
  late AnimationController _foundWordController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _successScale;
  late Animation<double> _foundWordScale;

  int _score = 0;
  int _hints = 3;
  bool _showHint = false;
  
  List<GridPosition> _foundWordPositions = [];

  @override
  void initState() {
    super.initState();
    _initializeLevel();
    _setupAnimations();
  }

  void _initializeLevel() {
    // تحميل بيانات المستوى من قاعدة البيانات
    final levelData = GameLevelsDatabase.getLevel(widget.levelNumber);
    
    if (levelData == null) {
      // في حالة عدم وجود المستوى، استخدم قيم افتراضية
      gridSize = 3;
      targetWord = 'خطأ';
      possibleWords = ['خطأ'];
    } else {
      gridSize = levelData.gridSize;
      targetWord = levelData.targetWord;
      possibleWords = levelData.allWords;
    }
    
    foundWords = [];
    _generateGrid();
  }

  void _generateGrid() {
    // إنشاء شبكة فارغة
    grid = List.generate(
      gridSize,
      (_) => List.generate(gridSize, (_) => ''),
    );

    // وضع جميع الكلمات في الشبكة
    for (var word in possibleWords) {
      _placeWordInGrid(word);
    }

    // ملء الفراغات بأحرف عشوائية
    final arabicLetters = [
      'ا', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ', 'د', 
      'ذ', 'ر', 'ز', 'س', 'ش', 'ص', 'ض', 'ط', 
      'ظ', 'ع', 'غ', 'ف', 'ق', 'ك', 'ل', 'م', 
      'ن', 'ه', 'و', 'ي', 'ى', 'ة'
    ];
    final random = Random();
    
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (grid[i][j].isEmpty) {
          grid[i][j] = arabicLetters[random.nextInt(arabicLetters.length)];
        }
      }
    }
  }

  void _placeWordInGrid(String word) {
    final random = Random();
    bool placed = false;
    int attempts = 0;
    
    while (!placed && attempts < 100) {
      attempts++;
      
      // اختيار اتجاه عشوائي
      final directions = [
        [0, 1],   // أفقي يمين
        [1, 0],   // عمودي أسفل
        [1, 1],   // قطري يمين أسفل
        [1, -1],  // قطري يسار أسفل
        [0, -1],  // أفقي يسار
        [-1, 0],  // عمودي أعلى
        [-1, -1], // قطري يسار أعلى
        [-1, 1],  // قطري يمين أعلى
      ];
      
      final direction = directions[random.nextInt(directions.length)];
      final row = random.nextInt(gridSize);
      final col = random.nextInt(gridSize);
      
      if (_canPlaceWord(word, row, col, direction[0], direction[1])) {
        _placeWord(word, row, col, direction[0], direction[1]);
        placed = true;
      }
    }
  }

  bool _canPlaceWord(String word, int row, int col, int dRow, int dCol) {
    for (int i = 0; i < word.length; i++) {
      final newRow = row + (i * dRow);
      final newCol = col + (i * dCol);
      
      if (newRow < 0 || newRow >= gridSize || newCol < 0 || newCol >= gridSize) {
        return false;
      }
      
      if (grid[newRow][newCol].isNotEmpty && grid[newRow][newCol] != word[i]) {
        return false;
      }
    }
    return true;
  }

  void _placeWord(String word, int row, int col, int dRow, int dCol) {
    for (int i = 0; i < word.length; i++) {
      final newRow = row + (i * dRow);
      final newCol = col + (i * dCol);
      grid[newRow][newCol] = word[i];
    }
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
    _successScale = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(_successController);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _foundWordController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _foundWordScale = Tween<double>(begin: 1.0, end: 1.3)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(_foundWordController);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _successController.dispose();
    _pulseController.dispose();
    _foundWordController.dispose();
    super.dispose();
  }

  void _onCellTouch(int row, int col) {
    final position = GridPosition(row, col);
    
    if (selectedPositions.isEmpty) {
      HapticFeedback.lightImpact();
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
      HapticFeedback.lightImpact();
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

    if (possibleWords.contains(currentWord) && !foundWords.contains(currentWord)) {
      HapticFeedback.mediumImpact();
      
      setState(() {
        foundWords.add(currentWord);
        _score += currentWord.length * 10;
        _foundWordPositions = List.from(selectedPositions);
      });

      _successController.forward(from: 0);
      _foundWordController.forward(from: 0).then((_) {
        _foundWordController.reverse();
      });

      if (foundWords.length == possibleWords.length) {
        Future.delayed(const Duration(milliseconds: 800), () {
          _showSuccessDialog();
        });
      } else {
        _showWordFoundSnackbar(currentWord);
      }
    } else {
      HapticFeedback.heavyImpact();
      _shakeController.forward(from: 0);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.close, color: Colors.white),
              SizedBox(width: 8),
              Text('الكلمة غير صحيحة!', style: TextStyle(fontSize: 16)),
            ],
          ),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(milliseconds: 800),
        ),
      );
    }

    setState(() {
      currentWord = '';
      selectedPositions.clear();
    });
  }

  void _showWordFoundSnackbar(String word) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('وجدت كلمة: $word! 🎉', style: const TextStyle(fontSize: 16)),
          ],
        ),
        backgroundColor: Colors.green.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  void _useHint() {
    if (_hints <= 0) return;

    final remaining = possibleWords.where((w) => !foundWords.contains(w)).toList();
    if (remaining.isEmpty) return;

    setState(() {
      _hints--;
      _showHint = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showHint = false;
        });
      }
    });

    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    final levelData = GameLevelsDatabase.getLevel(widget.levelNumber);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade50,
              Colors.blue.shade50,
              Colors.pink.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(levelData),
              _buildFoundWordsPanel(),
              const SizedBox(height: 20),
              _buildCurrentWordDisplay(),
              const SizedBox(height: 20),
              Expanded(
                child: _buildGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(LevelData? levelData) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.deepPurple),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'المستوى ${widget.levelNumber}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple.shade700,
                  ),
                ),
                if (levelData != null)
                  Text(
                    '${levelData.difficulty} • شبكة ${gridSize}×$gridSize',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
          ),
          _buildScoreCard(),
          const SizedBox(width: 8),
          _buildHintButton(),
        ],
      ),
    );
  }

  Widget _buildScoreCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade400, Colors.purple.shade600],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.stars, color: Colors.amber, size: 18),
          const SizedBox(width: 6),
          Text(
            '$_score',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHintButton() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_pulseController.value * 0.1),
          child: InkWell(
            onTap: _useHint,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _hints > 0
                      ? [Colors.orange.shade400, Colors.deepOrange.shade600]
                      : [Colors.grey.shade300, Colors.grey.shade400],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.shade200.withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lightbulb, color: Colors.white, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '$_hints',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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

  Widget _buildFoundWordsPanel() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.amber.shade700, size: 24),
              const SizedBox(width: 8),
              Text(
                'الكلمات المكتشفة (${foundWords.length}/${possibleWords.length})',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: possibleWords.map((word) {
              final isFound = foundWords.contains(word);
              final isTarget = word == targetWord;
              
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: isFound
                      ? LinearGradient(
                          colors: isTarget
                              ? [Colors.green.shade400, Colors.green.shade600]
                              : [Colors.blue.shade300, Colors.blue.shade500],
                        )
                      : null,
                  color: isFound ? null : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isFound ? word : (_showHint && word == possibleWords.firstWhere(
                    (w) => !foundWords.contains(w),
                    orElse: () => '',
                  ) ? '${word[0]}...' : '?'),
                  style: TextStyle(
                    color: isFound ? Colors.white : Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentWordDisplay() {
    return AnimatedBuilder(
      animation: _successScale,
      builder: (context, child) {
        return Transform.scale(
          scale: _successScale.value > 0 ? _successScale.value : 1.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey.shade50],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Text(
              currentWord.isEmpty ? 'اسحب لتكوين كلمة' : currentWord,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: currentWord.isEmpty
                    ? Colors.grey.shade400
                    : Colors.deepPurple.shade700,
                letterSpacing: 4,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGrid() {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(sin(_shakeAnimation.value) * 3, 0),
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
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
    final isSelected = selectedPositions.any((p) => p.row == row && p.col == col);
    final isFoundWord = _foundWordPositions.any((p) => p.row == row && p.col == col);
    final selectedIndex = selectedPositions.indexWhere((p) => p.row == row && p.col == col);
    
    return AnimatedBuilder(
      animation: _foundWordScale,
      builder: (context, child) {
        return Transform.scale(
          scale: isFoundWord ? _foundWordScale.value : 1.0,
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
                    )
                  : isFoundWord
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.green.shade300, Colors.green.shade500],
                        )
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.blue.shade100, Colors.purple.shade100],
                        ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: isSelected || isFoundWord
                  ? [
                      BoxShadow(
                        color: isSelected 
                            ? Colors.orange.shade300.withOpacity(0.6)
                            : Colors.green.shade300.withOpacity(0.6),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    grid[row][col],
                    style: TextStyle(
                      fontSize: gridSize <= 5 ? 20 : (gridSize <= 7 ? 16 : 14),
                      fontWeight: FontWeight.bold,
                      color: isSelected || isFoundWord 
                          ? Colors.white 
                          : Colors.deepPurple.shade700,
                      shadows: isSelected || isFoundWord
                          ? [
                              const Shadow(
                                color: Colors.black26,
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
                if (isSelected && selectedIndex >= 0 && gridSize <= 6)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${selectedIndex + 1}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessDialog() {
    HapticFeedback.heavyImpact();
    
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
              colors: [Colors.purple.shade400, Colors.pink.shade400],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.emoji_events,
                size: 80,
                color: Colors.amber,
              ),
              const SizedBox(height: 16),
              const Text(
                "🎉 مبروك!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "لقد أكملت المستوى ${widget.levelNumber}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "النقاط: $_score",
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.purple.shade600,
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
                  Navigator.pop(context, {
                    'completed': true,
                    'score': _score,
                  });
                },
                child: const Text(
                  "العودة للخريطة",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
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