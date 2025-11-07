// ========================================
// ميزات إضافية يمكن إضافتها للعبة
// ========================================

import 'dart:math';

import 'package:flutter/material.dart';
import '../core/services/game_progress_service.dart';

// ========================================
// 1. شاشة الإعدادات الكاملة
// ========================================

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool soundEnabled;
  late bool musicEnabled;
  late bool vibrationEnabled;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      soundEnabled = progressService.isSoundEnabled;
      musicEnabled = progressService.isMusicEnabled;
      vibrationEnabled = progressService.isVibrationEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingCard(
            icon: Icons.volume_up,
            title: 'المؤثرات الصوتية',
            value: soundEnabled,
            onChanged: (value) async {
              await progressService.setSoundEnabled(value);
              setState(() => soundEnabled = value);
            },
          ),
          const SizedBox(height: 12),
          _buildSettingCard(
            icon: Icons.music_note,
            title: 'الموسيقى',
            value: musicEnabled,
            onChanged: (value) async {
              await progressService.setMusicEnabled(value);
              setState(() => musicEnabled = value);
            },
          ),
          const SizedBox(height: 12),
          _buildSettingCard(
            icon: Icons.vibration,
            title: 'الاهتزاز',
            value: vibrationEnabled,
            onChanged: (value) async {
              await progressService.setVibrationEnabled(value);
              setState(() => vibrationEnabled = value);
            },
          ),
          const SizedBox(height: 24),
          _buildActionButton(
            icon: Icons.refresh,
            title: 'إعادة تعيين التقدم',
            subtitle: 'حذف جميع البيانات والبدء من جديد',
            color: Colors.red,
            onTap: _showResetConfirmation,
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.info,
            title: 'حول اللعبة',
            subtitle: 'معلومات عن التطبيق',
            color: Colors.blue,
            onTap: _showAboutDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.deepPurple),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.deepPurple,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ تحذير'),
        content: const Text(
          'هل أنت متأكد من رغبتك في حذف جميع البيانات؟\n'
          'سيتم فقدان كل التقدم والنقاط!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              await progressService.resetProgress();
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم إعادة التعيين بنجاح')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('تأكيد الحذف'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حول اللعبة'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🎮 لعبة البحث عن الكلمات العربية'),
            SizedBox(height: 8),
            Text('الإصدار: 1.0.0'),
            SizedBox(height: 16),
            Text('لعبة ممتعة لتعلم الكلمات العربية وتحسين المفردات'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}

// ========================================
// 2. نظام الإنجازات
// ========================================

class Achievement {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final int targetValue;
  bool unlocked;
  int currentValue;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.targetValue,
    this.unlocked = false,
    this.currentValue = 0,
  });

  double get progress => currentValue / targetValue;
}

class AchievementsManager {
  static List<Achievement> getAchievements() {
    return [
      Achievement(
        id: 'first_level',
        name: 'البداية',
        description: 'أكمل أول مستوى',
        icon: Icons.flag,
        color: Colors.green,
        targetValue: 1,
      ),
      Achievement(
        id: 'level_10',
        name: 'عشر مستويات',
        description: 'أكمل 10 مستويات',
        icon: Icons.emoji_events,
        color: Colors.orange,
        targetValue: 10,
      ),
      Achievement(
        id: 'perfect_5',
        name: 'الكمال',
        description: 'احصل على 3 نجوم في 5 مستويات',
        icon: Icons.star,
        color: Colors.amber,
        targetValue: 5,
      ),
      Achievement(
        id: 'score_1000',
        name: 'جامع النقاط',
        description: 'احصل على 1000 نقطة',
        icon: Icons.diamond,
        color: Colors.blue,
        targetValue: 1000,
      ),
      Achievement(
        id: 'speed_demon',
        name: 'السرعة',
        description: 'أكمل مستوى في أقل من 30 ثانية',
        icon: Icons.flash_on,
        color: Colors.red,
        targetValue: 1,
      ),
    ];
  }

  static void checkAchievements() {
    final stats = progressService.getStatistics();
    final achievements = getAchievements();

    for (var achievement in achievements) {
      switch (achievement.id) {
        case 'first_level':
          achievement.currentValue = stats['levelsCompleted'];
          achievement.unlocked = achievement.currentValue >= 1;
          break;
        case 'level_10':
          achievement.currentValue = stats['levelsCompleted'];
          achievement.unlocked = achievement.currentValue >= 10;
          break;
        case 'perfect_5':
          achievement.currentValue = stats['perfectLevels'];
          achievement.unlocked = achievement.currentValue >= 5;
          break;
        case 'score_1000':
          achievement.currentValue = stats['totalScore'];
          achievement.unlocked = achievement.currentValue >= 1000;
          break;
      }
    }
  }
}

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final achievements = AchievementsManager.getAchievements();
    AchievementsManager.checkAchievements();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإنجازات'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];
          return _buildAchievementCard(achievement);
        },
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: achievement.unlocked ? achievement.color.withOpacity(0.1) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: achievement.unlocked ? achievement.color : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: achievement.unlocked ? achievement.color : Colors.grey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              achievement.icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: achievement.unlocked ? Colors.black87 : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: achievement.unlocked ? Colors.black54 : Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                if (!achievement.unlocked)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: achievement.progress,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation(achievement.color),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${achievement.currentValue}/${achievement.targetValue}',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (achievement.unlocked)
            const Icon(Icons.check_circle, color: Colors.green, size: 30),
        ],
      ),
    );
  }
}

// ========================================
// 3. نظام المتجر (شراء التلميحات)
// ========================================

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المتجر'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildShopItem(
            context: context,
            title: '5 تلميحات',
            price: 100,
            icon: Icons.lightbulb,
            color: Colors.orange,
            onPurchase: () => _purchaseHints(context, 5, 100),
          ),
          const SizedBox(height: 12),
          _buildShopItem(
            context: context,
            title: '10 تلميحات',
            price: 180,
            icon: Icons.lightbulb,
            color: Colors.orange,
            badge: 'وفر 20 نقطة',
            onPurchase: () => _purchaseHints(context, 10, 180),
          ),
          const SizedBox(height: 12),
          _buildShopItem(
            context: context,
            title: '25 تلميحات',
            price: 400,
            icon: Icons.lightbulb,
            color: Colors.orange,
            badge: 'الأفضل قيمة',
            onPurchase: () => _purchaseHints(context, 25, 400),
          ),
        ],
      ),
    );
  }

  Widget _buildShopItem({
    required BuildContext context,
    required String title,
    required int price,
    required IconData icon,
    required Color color,
    String? badge,
    required VoidCallback onPurchase,
  }) {
    final stats = progressService.getStatistics();
    final currentScore = stats['totalScore'] as int;
    final canAfford = currentScore >= price;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: canAfford ? color : Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (badge != null)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.stars, color: Colors.purple, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '$price نقطة',
                          style: TextStyle(
                            fontSize: 14,
                            color: canAfford ? Colors.black87 : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: canAfford ? onPurchase : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('شراء', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _purchaseHints(BuildContext context, int hints, int cost) async {
    final stats = progressService.getStatistics();
    final currentScore = stats['totalScore'] as int;

    if (currentScore >= cost) {
      // خصم النقاط
      await progressService.addScore(-cost);
      // إضافة التلميحات
      await progressService.addHints(hints);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم شراء $hints تلميحات بنجاح!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}

// ========================================
// 4. نظام التحديات اليومية
// ========================================

class DailyChallenge {
  final int levelNumber;
  final DateTime date;
  final int targetScore;
  final int reward;

  DailyChallenge({
    required this.levelNumber,
    required this.date,
    required this.targetScore,
    required this.reward,
  });

  bool isToday() {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }
}

class DailyChallengeManager {
  static DailyChallenge generateDailyChallenge() {
    final today = DateTime.now();
    final seed = today.year * 10000 + today.month * 100 + today.day;
    final random = Random(seed);
    
    return DailyChallenge(
      levelNumber: random.nextInt(60) + 1,
      date: today,
      targetScore: 100 + random.nextInt(150),
      reward: 50 + random.nextInt(50),
    );
  }
}

// ========================================
// 5. نظام الترتيب المحلي
// ========================================

class LocalLeaderboard {
  static List<LeaderboardEntry> getTopScores() {
    // يمكن توسيع هذا لحفظ أفضل النتائج
    return [
      LeaderboardEntry(
        rank: 1,
        playerName: 'أنت',
        score: progressService.getStatistics()['totalScore'] as int,
        levels: progressService.getStatistics()['levelsCompleted'] as int,
      ),
    ];
  }
}

class LeaderboardEntry {
  final int rank;
  final String playerName;
  final int score;
  final int levels;

  LeaderboardEntry({
    required this.rank,
    required this.playerName,
    required this.score,
    required this.levels,
  });
}