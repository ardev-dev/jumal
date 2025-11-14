import 'dart:math';
import 'package:flutter/material.dart';

import '../core/services/game_progress_service.dart';
import '../core/data/game_database.dart';
import 'game_level_screen.dart';
import 'settings_screen.dart';

class LevelMapScreen extends StatefulWidget {
  const LevelMapScreen({super.key});

  @override
  State<LevelMapScreen> createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen>
    with TickerProviderStateMixin {
  late int currentLevel;
  late int totalLevels;
  late Set<int> completedLevels;
  late int totalScore;
  late int hintsRemaining;

  late AnimationController _floatingController;
  late AnimationController _starController;
  late AnimationController _coinController;

  @override
  void initState() {
    super.initState();
    totalLevels = GameDatabase.getTotalLevels();
    _loadProgress();
    _setupAnimations();
  }

  void _setupAnimations() {
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _starController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _coinController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  void _loadProgress() {
    final stats = progressService.getStatistics();
    setState(() {
      currentLevel = stats['currentLevel'] as int;
      totalScore = stats['totalScore'] as int;
      hintsRemaining = stats['hintsRemaining'] as int;
      completedLevels = progressService.getCompletedLevels();
    });
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _starController.dispose();
    _coinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Expanded(child: _buildLevelMap()),
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
              // النقاط
              GestureDetector(
                onTap: _showStatistics,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
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
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          '$totalScore',
                          key: ValueKey(totalScore),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // التلميحات
              GestureDetector(
                onTap: _showHintsDialog,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade400, Colors.orange.shade600],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.shade300,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lightbulb,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$hintsRemaining',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // الإعدادات
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
                onPressed: _showSettingsDialog,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildProgressCard(),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    final progress = currentLevel / totalLevels;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'التقدم',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
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
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 6,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.green.shade400,
                  ),
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
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
    );
  }

  Widget _buildLevelMap() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          for (int row = 0; row < (totalLevels / 3).ceil(); row++)
            _buildLevelRow(row),
        ],
      ),
    );
  }

  Widget _buildLevelRow(int row) {
    List<Widget> levels = [];
    bool isEvenRow = row % 2 == 0;

    for (int i = 0; i < 3; i++) {
      int levelNumber = (row * 3) + i + 1;
      if (levelNumber > totalLevels) break;

      int position = isEvenRow ? i : (2 - i);
      levels.add(Expanded(child: _buildLevelNode(levelNumber, position)));
    }

    if (!isEvenRow) {
      levels = levels.reversed.toList();
    }

    return Column(
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: levels),
        if (row < (totalLevels / 3).ceil() - 1) _buildPathConnector(isEvenRow),
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

    final levelData = GameDatabase.getLevel(levelNumber);

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
                _navigateToLevel(levelData ?? LevelDataModel.empty());
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
                              width:
                                  100 +
                                  (sin(_starController.value * 2 * pi) * 10),
                              height:
                                  100 +
                                  (sin(_starController.value * 2 * pi) * 10),
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
                            colors: isCompleted
                                ? [Colors.green.shade400, Colors.green.shade600]
                                : isLocked
                                ? [Colors.grey.shade400, Colors.grey.shade600]
                                : isCurrent
                                ? [
                                    Colors.orange.shade400,
                                    Colors.deepOrange.shade600,
                                  ]
                                : [
                                    Colors.blue.shade400,
                                    Colors.purple.shade500,
                                  ],
                          ),
                          border: Border.all(color: Colors.white, width: 4),
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
                      color: isLocked ? Colors.grey.shade600 : Colors.white,
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

  void _navigateToLevel(LevelDataModel level) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameLevelScreen(level: level)),
    );

    if (result != null && result is Map<String, dynamic>) {
      if (result['completed'] == true) {
        _coinController.forward(from: 0);
        _loadProgress();
      }
    }
  }

  void _showStatistics() {
    final stats = progressService.getStatistics();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'الإحصائيات',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade700,
                ),
              ),
              const SizedBox(height: 20),
              _buildStatItem(
                Icons.emoji_events,
                'المستويات المكتملة',
                '${stats['levelsCompleted']}',
                Colors.green,
              ),
              _buildStatItem(
                Icons.star,
                'المستويات المثالية',
                '${stats['perfectLevels']}',
                Colors.amber,
              ),
              _buildStatItem(
                Icons.timer,
                'وقت اللعب',
                '${(stats['totalPlayTime'] / 60).round()} دقيقة',
                Colors.blue,
              ),
              _buildStatItem(
                Icons.trending_up,
                'متوسط النقاط',
                '${stats['averageScore']}',
                Colors.purple,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'إغلاق',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple.shade700,
            ),
          ),
        ],
      ),
    );
  }

  void _showHintsDialog() {
    // يمكن إضافة نافذة لشراء التلميحات
  }

  void _showSettingsDialog() {
    // يمكن إضافة نافذة الإعدادات
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
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
