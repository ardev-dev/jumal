import 'dart:math';
import 'package:flutter/material.dart';

import '../data/game_level.dart';
import 'game_level_screen.dart';

class LevelMapScreen extends StatefulWidget {
  const LevelMapScreen({super.key});

  @override
  State<LevelMapScreen> createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen>
    with TickerProviderStateMixin {
  int currentLevel = 1;
  int totalLevels = GameLevelsDatabase.getTotalLevels();
  Set<int> completedLevels = {}; // سيتم تحميلها من SharedPreferences
  int totalScore = 0;
  
  late AnimationController _floatingController;
  late AnimationController _starController;
  
  @override
  void initState() {
    super.initState();
    _loadProgress();
    
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _starController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }
  
  void _loadProgress() {
    // هنا يمكنك تحميل التقدم من SharedPreferences
    // مثال للتجربة:
    setState(() {
      completedLevels = {1, 2};
      currentLevel = 3;
      totalScore = 340;
    });
  }
  
  @override
  void dispose() {
    _floatingController.dispose();
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade300,
              Colors.purple.shade200,
              Colors.pink.shade200,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildLevelMap(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade600, Colors.purple.shade800],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.shade300,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars, color: Colors.amber, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      '$totalScore',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.settings, color: Colors.deepPurple),
                ),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'التقدم',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'المستوى $currentLevel من $totalLevels',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade700,
                      ),
                    ),
                    Text(
                      'شبكة ${GameLevelsDatabase.getGridSizeForLevel(currentLevel)}×${GameLevelsDatabase.getGridSizeForLevel(currentLevel)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        value: currentLevel / totalLevels,
                        strokeWidth: 6,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.green.shade400,
                        ),
                      ),
                    ),
                    Text(
                      '${((currentLevel / totalLevels) * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelMap() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          // رسم المسار المتعرج
          for (int row = 0; row < (totalLevels / 3).ceil(); row++)
            _buildLevelRow(row),
        ],
      ),
    );
  }

  Widget _buildLevelRow(int row) {
    List<Widget> levels = [];
    bool isEvenRow = row % 2 == 0;
    
    // 3 مستويات في كل صف
    for (int i = 0; i < 3; i++) {
      int levelNumber = (row * 3) + i + 1;
      if (levelNumber > totalLevels) break;
      
      int position = isEvenRow ? i : (2 - i);
      
      levels.add(
        Expanded(
          child: _buildLevelNode(levelNumber, position),
        ),
      );
    }
    
    if (!isEvenRow) {
      levels = levels.reversed.toList();
    }
    
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: levels,
        ),
        if (row < (totalLevels / 3).ceil() - 1)
          _buildPathConnector(isEvenRow),
      ],
    );
  }

  Widget _buildPathConnector(bool isEvenRow) {
    return Container(
      height: 40,
      alignment: isEvenRow ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.only(
        right: isEvenRow ? 60 : 0,
        left: isEvenRow ? 0 : 60,
      ),
      child: CustomPaint(
        size: const Size(double.infinity, 40),
        painter: PathConnectorPainter(isEvenRow: isEvenRow),
      ),
    );
  }

  Widget _buildLevelNode(int levelNumber, int position) {
    bool isCompleted = completedLevels.contains(levelNumber);
    bool isLocked = levelNumber > currentLevel;
    bool isCurrent = levelNumber == currentLevel;
    
    // الحصول على معلومات المستوى
    final levelData = GameLevelsDatabase.getLevel(levelNumber);
    final gridSize = levelData?.gridSize ?? 3;
    
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        double offset = 0;
        if (isCurrent) {
          offset = sin(_floatingController.value * 2 * pi) * 8;
        }
        
        return Transform.translate(
          offset: Offset(0, offset),
          child: GestureDetector(
            onTap: () {
              if (!isLocked) {
                _navigateToLevel(levelNumber);
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      // هالة مضيئة للمستوى الحالي
                      if (isCurrent)
                        AnimatedBuilder(
                          animation: _starController,
                          builder: (context, child) {
                            return Container(
                              width: 100 + (sin(_starController.value * 2 * pi) * 10),
                              height: 100 + (sin(_starController.value * 2 * pi) * 10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amber.withOpacity(0.4),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      
                      // المستوى نفسه
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isLocked
                                ? [Colors.grey.shade400, Colors.grey.shade600]
                                : isCompleted
                                    ? [Colors.green.shade400, Colors.green.shade600]
                                    : isCurrent
                                        ? [Colors.orange.shade400, Colors.deepOrange.shade600]
                                        : [Colors.blue.shade400, Colors.purple.shade500],
                          ),
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isLocked
                                  ? Colors.grey.shade300
                                  : isCompleted
                                      ? Colors.green.shade300
                                      : isCurrent
                                          ? Colors.orange.shade300
                                          : Colors.purple.shade300,
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (isLocked)
                              const Icon(
                                Icons.lock,
                                color: Colors.white,
                                size: 32,
                              )
                            else
                              Text(
                                '$levelNumber',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      offset: Offset(1, 1),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      // حجم الشبكة في الأعلى
                      if (!isLocked)
                        Positioned(
                          top: -8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Text(
                              '${gridSize}×$gridSize',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple.shade700,
                              ),
                            ),
                          ),
                        ),
                      
                      // النجوم للمستوى المكتمل
                      if (isCompleted)
                        Positioned(
                          bottom: -5,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(3, (index) {
                              return Transform.scale(
                                scale: 0.8,
                                child: const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                              );
                            }),
                          ),
                        ),
                      
                      // أيقونة التشغيل للمستوى الحالي
                      if (isCurrent)
                        Positioned(
                          bottom: -8,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.shade300,
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.orange,
                              size: 20,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isCompleted
                        ? 'مكتمل'
                        : isCurrent
                            ? 'العب الآن'
                            : isLocked
                                ? 'مقفل'
                                : 'متاح',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isLocked
                          ? Colors.grey.shade600
                          : Colors.white,
                      shadows: const [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
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

  void _navigateToLevel(int levelNumber) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameConnectArrowScreen(levelNumber: levelNumber),
      ),
    );
    
    if (result != null && result is Map<String, dynamic>) {
      if (result['completed'] == true) {
        setState(() {
          completedLevels.add(levelNumber);
          totalScore += (result['score'] as int? ?? 0);
          
          if (levelNumber == currentLevel && currentLevel < totalLevels) {
            currentLevel++;
          }
        });
        
        // هنا يمكنك حفظ التقدم في SharedPreferences
        _saveProgress();
      }
    }
  }
  
  void _saveProgress() {
    // حفظ التقدم في SharedPreferences
    // SharedPreferences implementation here
  }
}

class PathConnectorPainter extends CustomPainter {
  final bool isEvenRow;

  PathConnectorPainter({required this.isEvenRow});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.purple.shade300, Colors.pink.shade300],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final dashPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    if (isEvenRow) {
      path.moveTo(size.width * 0.3, 0);
      path.quadraticBezierTo(
        size.width * 0.5,
        size.height / 2,
        size.width * 0.7,
        size.height,
      );
    } else {
      path.moveTo(size.width * 0.7, 0);
      path.quadraticBezierTo(
        size.width * 0.5,
        size.height / 2,
        size.width * 0.3,
        size.height,
      );
    }

    canvas.drawPath(path, paint);
    _drawDashedPath(canvas, path, dashPaint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final dashWidth = 8.0;
    final dashSpace = 4.0;
    final metrics = path.computeMetrics();
    
    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final nextDistance = distance + dashWidth;
        final extractPath = metric.extractPath(
          distance,
          nextDistance > metric.length ? metric.length : nextDistance,
        );
        canvas.drawPath(extractPath, paint);
        distance = nextDistance + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}