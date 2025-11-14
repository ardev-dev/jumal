import 'package:flutter/material.dart';

import '../core/data/game_database.dart';
import '../core/services/game_progress_service.dart';

void showSuccessDialog(
  BuildContext context,
  LevelDataModel levelData,
  int score,
  int timeSpent,
  int wordsLength,
) {
  final levelProgress = progressService.getLevelProgress(levelData.levelNumber);
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
                          color: index < stars ? Colors.amber : Colors.white38,
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
                  _buildStatRow('النقاط', '$score', Icons.diamond),
                  const SizedBox(height: 12),
                  _buildStatRow('الوقت', '$timeSpentث', Icons.timer),
                  const SizedBox(height: 12),
                  _buildStatRow(
                    'الكلمات',
                    '${wordsLength}/${levelData.words.length}',
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
                Navigator.pop(context, {'completed': true, 'score': score});
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
