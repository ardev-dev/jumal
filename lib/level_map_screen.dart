import 'package:flutter/material.dart';
import 'dart:math';

import 'game_level_screen.dart';

class LevelMapScreen extends StatefulWidget {
  const LevelMapScreen({super.key});

  @override
  State<LevelMapScreen> createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen> {
  int currentLevel = 3;
  final int totalLevels = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB3E5FC),
      appBar: AppBar(
        title: const Text('خريطة المراحل'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Stack(
        children: [
          // الطريق المتعرج
          CustomPaint(
            size: Size.infinite,
            painter: CandyPathPainter(),
          ),

          // المراحل
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double height = constraints.maxHeight;
                final double width = constraints.maxWidth;
                final List<Offset> positions = _generateLevelPositions(width, height);

                return Stack(
                  children: [
                    for (int i = 0; i < totalLevels; i++)
                      _buildLevelNode(
                        i + 1,
                        positions[i],
                        isUnlocked: i + 1 <= currentLevel,
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// يبني شكل المرحلة (دائرة تحتوي على رقم المرحلة)
  Widget _buildLevelNode(int level, Offset pos, {required bool isUnlocked}) {
    return Positioned(
      left: pos.dx - 25,
      top: pos.dy - 25,
      child: GestureDetector(
        onTap: isUnlocked
            ? () async {
                bool? completed = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GameConnectArrowScreen(levelNumber: level),
                  ),
                );
                if (completed == true && level == currentLevel && currentLevel < totalLevels) {
                  setState(() => currentLevel++);
                }
              }
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isUnlocked
                ? const LinearGradient(colors: [Colors.pinkAccent, Colors.orangeAccent])
                : const LinearGradient(colors: [Colors.grey, Colors.black26]),
            boxShadow: [
              if (isUnlocked)
                BoxShadow(
                  color: Colors.pinkAccent.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: Center(
            child: Text(
              '$level',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// يولّد مواقع المراحل على شكل مسار متعرج
  List<Offset> _generateLevelPositions(double width, double height) {
    const int steps = 15;
    final List<Offset> positions = [];
    final double verticalSpacing = height / steps;

    for (int i = 0; i < steps; i++) {
      double x = (i % 2 == 0)
          ? width * 0.2 + Random(i).nextDouble() * 40
          : width * 0.7 + Random(i).nextDouble() * 40;
      double y = height - (i * verticalSpacing) - 80;
      positions.add(Offset(x, y));
    }
    return positions;
  }
}

class CandyPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final double step = size.height / 15;
    for (int i = 0; i < 15; i++) {
      double x = (i % 2 == 0) ? size.width * 0.25 : size.width * 0.75;
      double y = size.height - (i * step) - 100;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawShadow(path, Colors.black45, 6, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
