import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/time_utils.dart';
import '../../../data/models/level_data_model.dart';
import '../../../services/service_locator.dart';
import '../../widgets/common/gradient_background.dart';
import '../game/game_level_screen.dart';
import '../settings/settings_screen.dart';

/// شاشة خريطة المستويات الاحترافية
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

  late AnimationController _pulseController;
  late AnimationController _floatController;
  late AnimationController _shimmerController;

  late Animation<double> _pulseAnimation;
  late Animation<double> _floatAnimation;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _setStatusBar();
    totalLevels = gameRepository.getTotalLevels();
    _loadProgress();
    _setupAnimations();
    _scrollToCurrentLevel();
  }

  void _setStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  void _loadProgress() {
    final stats = gameRepository.getStatistics();
    setState(() {
      currentLevel = stats['currentLevel'] as int;
      totalScore = stats['totalScore'] as int;
      hintsRemaining = stats['hintsRemaining'] as int;
      completedLevels = gameRepository.getCompletedLevels();
    });
  }

  void _scrollToCurrentLevel() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final targetRow = (currentLevel - 1) ~/ 3;
        final offset = (targetRow * 160.0).clamp(
          0.0,
          _scrollController.position.maxScrollExtent,
        );
        _scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatController.dispose();
    _shimmerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        showOverlay: true,
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
      padding: const EdgeInsets.all(AppDimens.paddingMD),
      child: Column(
        children: [
          Row(
            children: [
              // شارة النقاط
              _buildScoreBadge(),
              const SizedBox(width: AppDimens.paddingSM),

              // شارة التلميحات
              _buildHintsBadge(),

              const Spacer(),

              // زر الإعدادات
              _buildSettingsButton(),
            ],
          ),
          const SizedBox(height: AppDimens.paddingMD),
          _buildProgressCard(),
        ],
      ),
    );
  }

  Widget _buildScoreBadge() {
    return GestureDetector(
      onTap: _showStatistics,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingMD,
          vertical: AppDimens.paddingSM,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppColors.primaryGradient,
          ),
          borderRadius: BorderRadius.circular(AppDimens.radiusXL),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.diamond_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: AppDimens.paddingSM),
            Text(
              '$totalScore',
              style: AppTextStyles.button.copyWith(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHintsBadge() {
    return GestureDetector(
      onTap: _showHintsInfo,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingMD,
          vertical: AppDimens.paddingSM,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: AppColors.hintGradient),
          borderRadius: BorderRadius.circular(AppDimens.radiusXL),
          boxShadow: [
            BoxShadow(
              color: AppColors.hintColor.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lightbulb, color: Colors.white, size: 20),
            const SizedBox(width: AppDimens.paddingSM),
            Text(
              '$hintsRemaining',
              style: AppTextStyles.button.copyWith(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsButton() {
    return GestureDetector(
      onTap: _navigateToSettings,
      child: Container(
        padding: const EdgeInsets.all(AppDimens.paddingSM + 4),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: AppShadows.medium,
        ),
        child: const Icon(
          Icons.settings_outlined,
          color: AppColors.primary,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    final progress = completedLevels.length / totalLevels;

    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingMD),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        boxShadow: AppShadows.medium,
      ),
      child: Row(
        children: [
          // معلومات التقدم
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'رحلتك في جُمَل',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.headline4.copyWith(
                      color: AppColors.primary,
                    ),
                    children: [
                      TextSpan(text: 'المستوى $currentLevel'),
                      TextSpan(
                        text: ' من $totalLevels',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimens.paddingSM),
                // شريط التقدم
                Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.borderLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: AppColors.successGradient,
                          ),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.success.withValues(alpha: 0.4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimens.paddingMD),
          // دائرة النسبة المئوية
          _buildProgressCircle(progress),
        ],
      ),
    );
  }

  Widget _buildProgressCircle(double progress) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 70,
          height: 70,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 8,
            backgroundColor: AppColors.borderLight,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
            strokeCap: StrokeCap.round,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${(progress * 100).toInt()}%',
              style: AppTextStyles.headline4.copyWith(
                color: AppColors.success,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLevelMap() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingMD,
        vertical: AppDimens.paddingLG,
      ),
      itemCount: (totalLevels / 3).ceil() * 2 - 1,
      itemBuilder: (context, index) {
        if (index.isOdd) {
          // موصل المسار
          return _buildPathConnector(index ~/ 2);
        }
        // صف المستويات
        return _buildLevelRow(index ~/ 2);
      },
    );
  }

  Widget _buildLevelRow(int row) {
    List<Widget> levels = [];
    bool isEvenRow = row % 2 == 0;

    for (int i = 0; i < 3; i++) {
      int levelNumber = (row * 3) + i + 1;
      if (levelNumber > totalLevels) {
        levels.add(const Expanded(child: SizedBox()));
        continue;
      }

      levels.add(Expanded(child: _buildLevelNode(levelNumber)));
    }

    if (!isEvenRow) {
      levels = levels.reversed.toList();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingSM),
      child: Row(children: levels),
    );
  }

  Widget _buildLevelNode(int levelNumber) {
    bool isCompleted = completedLevels.contains(levelNumber);
    bool isLocked = levelNumber > currentLevel;
    bool isCurrent = levelNumber == currentLevel;

    final levelData = gameRepository.getLevel(levelNumber);
    final levelProgress = gameRepository.getLevelProgress(levelNumber);
    final stars = levelProgress?.stars ?? 0;

    return GestureDetector(
      onTap: () {
        if (!isLocked && levelData != null) {
          _navigateToLevel(levelData);
        }
      },
      child: AnimatedBuilder(
        animation: _floatAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, isCurrent ? _floatAnimation.value : 0),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // تأثير التوهج للمستوى الحالي
                    if (isCurrent) _buildCurrentLevelGlow(),

                    // دائرة المستوى
                    _buildLevelCircle(
                      levelNumber: levelNumber,
                      isCompleted: isCompleted,
                      isLocked: isLocked,
                      isCurrent: isCurrent,
                    ),

                    // النجوم للمستويات المكتملة
                    if (isCompleted)
                      Positioned(
                        bottom: -8,
                        child: _buildStars(stars),
                      ),

                    // زر التشغيل للمستوى الحالي
                    if (isCurrent)
                      Positioned(
                        bottom: -12,
                        child: _buildPlayButton(),
                      ),
                  ],
                ),
                const SizedBox(height: AppDimens.paddingMD),
                _buildLevelLabel(isCompleted, isLocked, isCurrent),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentLevelGlow() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          width: AppDimens.levelNodeSizeLG * _pulseAnimation.value,
          height: AppDimens.levelNodeSizeLG * _pulseAnimation.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.levelCurrentGlow.withValues(alpha: 0.6),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLevelCircle({
    required int levelNumber,
    required bool isCompleted,
    required bool isLocked,
    required bool isCurrent,
  }) {
    final size = isCurrent ? AppDimens.levelNodeSizeLG : AppDimens.levelNodeSize;
    final colors = _getLevelColors(isCompleted, isLocked, isCurrent);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        border: Border.all(
          color: Colors.white,
          width: isCurrent ? 5 : 4,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.last.withValues(alpha: 0.5),
            blurRadius: isCurrent ? 20 : 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: isLocked
            ? Icon(
                Icons.lock_outline,
                color: Colors.white.withValues(alpha: 0.8),
                size: isCurrent ? 36 : 28,
              )
            : Text(
                '$levelNumber',
                style: AppTextStyles.levelNumber.copyWith(
                  fontSize: isCurrent ? 32 : 26,
                ),
              ),
      ),
    );
  }

  List<Color> _getLevelColors(bool isCompleted, bool isLocked, bool isCurrent) {
    if (isCompleted) {
      return [AppColors.levelCompletedGlow, AppColors.levelCompleted];
    }
    if (isLocked) {
      return [AppColors.levelLocked, AppColors.levelLockedDark];
    }
    if (isCurrent) {
      return [AppColors.levelCurrentGlow, AppColors.levelCurrent];
    }
    return [AppColors.primaryLight, AppColors.primary];
  }

  Widget _buildStars(int stars) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        boxShadow: AppShadows.small,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return Icon(
            index < stars ? Icons.star : Icons.star_border,
            color: index < stars ? AppColors.starFilled : AppColors.starEmpty,
            size: AppDimens.levelStarSize,
          );
        }),
      ),
    );
  }

  Widget _buildPlayButton() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.levelCurrent.withValues(alpha: 0.5),
                  blurRadius: 12,
                ),
              ],
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: AppColors.levelCurrent,
              size: 24,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLevelLabel(bool isCompleted, bool isLocked, bool isCurrent) {
    String text;
    Color color;

    if (isCompleted) {
      text = 'مكتمل';
      color = AppColors.success;
    } else if (isCurrent) {
      text = 'العب الآن';
      color = AppColors.levelCurrent;
    } else if (isLocked) {
      text = 'مقفل';
      color = AppColors.textTertiary;
    } else {
      text = 'متاح';
      color = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDimens.radiusSM),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPathConnector(int row) {
    bool isEvenRow = row % 2 == 0;

    return SizedBox(
      height: 50,
      child: CustomPaint(
        painter: PathConnectorPainter(
          isEvenRow: isEvenRow,
          color: AppColors.levelPath,
          activeColor: AppColors.primary,
          progress: _calculatePathProgress(row),
        ),
        size: const Size(double.infinity, 50),
      ),
    );
  }

  double _calculatePathProgress(int row) {
    final rowStartLevel = (row * 3) + 1;
    if (currentLevel <= rowStartLevel) return 0.0;
    if (currentLevel > rowStartLevel + 3) return 1.0;
    return (currentLevel - rowStartLevel) / 3;
  }

  void _navigateToLevel(LevelDataModel level) async {
    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            GameLevelScreen(level: level),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      if (result['completed'] == true) {
        _loadProgress();
      }
    }
  }

  void _showStatistics() {
    final stats = gameRepository.getStatistics();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _StatisticsBottomSheet(stats: stats),
    );
  }

  void _showHintsInfo() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.lightbulb, color: AppColors.hintColor),
            const SizedBox(width: AppDimens.paddingSM),
            Text('لديك $hintsRemaining تلميحات متاحة'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.backgroundDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        ),
      ),
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SettingsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}

/// صفحة الإحصائيات السفلية
class _StatisticsBottomSheet extends StatelessWidget {
  final Map<String, dynamic> stats;

  const _StatisticsBottomSheet({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusXL),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // المقبض
          Container(
            margin: const EdgeInsets.only(top: AppDimens.paddingSM),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderMedium,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimens.paddingLG),
            child: Column(
              children: [
                Text(
                  'إحصائياتك',
                  style: AppTextStyles.headline3.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppDimens.paddingLG),
                _buildStatGrid(),
                const SizedBox(height: AppDimens.paddingLG),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إغلاق'),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: AppDimens.paddingMD,
      crossAxisSpacing: AppDimens.paddingMD,
      childAspectRatio: 1.5,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _StatCard(
          icon: Icons.emoji_events,
          label: 'المستويات المكتملة',
          value: '${stats['levelsCompleted']}',
          color: AppColors.success,
        ),
        _StatCard(
          icon: Icons.star,
          label: 'المستويات المثالية',
          value: '${stats['perfectLevels']}',
          color: AppColors.starFilled,
        ),
        _StatCard(
          icon: Icons.timer_outlined,
          label: 'وقت اللعب',
          value: TimeUtils.formatToMinutes(stats['totalPlayTime'] as int),
          color: AppColors.info,
        ),
        _StatCard(
          icon: Icons.trending_up,
          label: 'متوسط النقاط',
          value: '${stats['averageScore']}',
          color: AppColors.primary,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingMD),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Text(
                value,
                style: AppTextStyles.headline4.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// رسام موصل المسار
class PathConnectorPainter extends CustomPainter {
  final bool isEvenRow;
  final Color color;
  final Color activeColor;
  final double progress;

  PathConnectorPainter({
    required this.isEvenRow,
    required this.color,
    required this.activeColor,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = AppDimens.levelPathWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final activePaint = Paint()
      ..shader = LinearGradient(
        colors: [AppColors.primaryLight, AppColors.primary],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = AppDimens.levelPathWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final startX = isEvenRow ? size.width * 0.7 : size.width * 0.3;
    final endX = isEvenRow ? size.width * 0.3 : size.width * 0.7;

    path.moveTo(startX, 0);
    path.cubicTo(
      startX,
      size.height * 0.5,
      endX,
      size.height * 0.5,
      endX,
      size.height,
    );

    // رسم المسار الخلفي
    canvas.drawPath(path, paint);

    // رسم المسار النشط
    if (progress > 0) {
      final metrics = path.computeMetrics().first;
      final activePath = metrics.extractPath(0, metrics.length * progress);
      canvas.drawPath(activePath, activePaint);
    }
  }

  @override
  bool shouldRepaint(covariant PathConnectorPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isEvenRow != isEvenRow;
  }
}
