import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/level_data_model.dart';
import '../../../services/service_locator.dart';

/// عرض حوار النجاح بعد إكمال المستوى
void showSuccessDialog(
  BuildContext context,
  LevelDataModel levelData,
  int score,
  int timeSpent,
  int wordsLength,
) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, animation, secondaryAnimation) {
      return _SuccessDialog(
        levelData: levelData,
        score: score,
        timeSpent: timeSpent,
        wordsLength: wordsLength,
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        ),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  );
}

class _SuccessDialog extends StatefulWidget {
  final LevelDataModel levelData;
  final int score;
  final int timeSpent;
  final int wordsLength;

  const _SuccessDialog({
    required this.levelData,
    required this.score,
    required this.timeSpent,
    required this.wordsLength,
  });

  @override
  State<_SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<_SuccessDialog>
    with TickerProviderStateMixin {
  late AnimationController _confettiController;
  late AnimationController _starsController;
  late AnimationController _bounceController;
  late AnimationController _statsController;

  late Animation<double> _bounceAnimation;
  late List<Animation<double>> _starAnimations;
  late Animation<double> _statsAnimation;

  late int stars;

  @override
  void initState() {
    super.initState();
    final levelProgress =
        gameRepository.getLevelProgress(widget.levelData.levelNumber);
    stars = levelProgress?.stars ?? 1;

    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _confettiController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _starsController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _statsController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _starAnimations = List.generate(3, (index) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _starsController,
          curve: Interval(
            index * 0.2,
            0.6 + (index * 0.2),
            curve: Curves.elasticOut,
          ),
        ),
      );
    });

    _statsAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _statsController, curve: Curves.easeOutCubic),
    );
  }

  void _startAnimations() {
    _confettiController.repeat();
    _bounceController.forward();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _starsController.forward();
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _statsController.forward();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _starsController.dispose();
    _bounceController.dispose();
    _statsController.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // الحوار الرئيسي
          _buildMainDialog(),

          // الكونفيتي
          _buildConfetti(),
        ],
      ),
    );
  }

  Widget _buildMainDialog() {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _bounceAnimation.value,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            margin: const EdgeInsets.all(AppDimens.paddingLG),
            padding: const EdgeInsets.all(AppDimens.paddingLG),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppColors.primaryGradient,
              ),
              borderRadius: BorderRadius.circular(AppDimens.radiusXXL),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTrophyIcon(),
                const SizedBox(height: AppDimens.paddingMD),
                _buildTitle(),
                const SizedBox(height: AppDimens.paddingSM),
                _buildSubtitle(),
                const SizedBox(height: AppDimens.paddingLG),
                _buildStars(),
                const SizedBox(height: AppDimens.paddingLG),
                _buildStatsCard(),
                const SizedBox(height: AppDimens.paddingLG),
                _buildContinueButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrophyIcon() {
    return AnimatedBuilder(
      animation: _bounceController,
      builder: (context, child) {
        return Transform.scale(
          scale: _bounceAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(AppDimens.paddingLG),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.starFilled.withValues(alpha: 0.4),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: AppColors.goldGradient,
              ).createShader(bounds),
              child: const Icon(
                Icons.emoji_events,
                size: 80,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return Text(
      'مبروك!',
      textAlign: TextAlign.center,
      style: AppTextStyles.displaySmall.copyWith(
        color: Colors.white,
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.3),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingMD,
        vertical: AppDimens.paddingSM,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
      ),
      child: Text(
        'لقد أكملت المستوى ${widget.levelData.levelNumber}',
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
      ),
    );
  }

  Widget _buildStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _starAnimations[index],
          builder: (context, child) {
            final isEarned = index < stars;
            return Transform.scale(
              scale: _starAnimations[index].value,
              child: Transform.rotate(
                angle: (1 - _starAnimations[index].value) * math.pi,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingSM,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (isEarned)
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.starFilled.withValues(alpha: 0.6),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      Icon(
                        Icons.star_rounded,
                        size: 56,
                        color: isEarned
                            ? AppColors.starFilled
                            : Colors.white.withValues(alpha: 0.3),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildStatsCard() {
    return AnimatedBuilder(
      animation: _statsAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _statsAnimation.value)),
          child: Opacity(
            opacity: _statsAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(AppDimens.paddingMD),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  _buildStatRow(
                    Icons.diamond_outlined,
                    'النقاط',
                    '${widget.score}',
                    AppColors.scoreColor,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppDimens.paddingSM),
                    child: Divider(
                      color: Colors.white.withValues(alpha: 0.2),
                      height: 1,
                    ),
                  ),
                  _buildStatRow(
                    Icons.timer_outlined,
                    'الوقت',
                    _formatTime(widget.timeSpent),
                    AppColors.info,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppDimens.paddingSM),
                    child: Divider(
                      color: Colors.white.withValues(alpha: 0.2),
                      height: 1,
                    ),
                  ),
                  _buildStatRow(
                    Icons.check_circle_outline,
                    'الكلمات',
                    '${widget.wordsLength}/${widget.levelData.words.length}',
                    AppColors.success,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppDimens.radiusSM),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: AppDimens.paddingMD),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.headline4.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingMD),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusXL),
          ),
          elevation: 8,
          shadowColor: Colors.black.withValues(alpha: 0.3),
        ),
        onPressed: () {
          Navigator.pop(context);
          Navigator.pop(context, {'completed': true, 'score': widget.score});
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'المتابعة',
              style: AppTextStyles.button.copyWith(
                color: AppColors.primary,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: AppDimens.paddingSM),
            const Icon(Icons.arrow_forward_rounded, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildConfetti() {
    return AnimatedBuilder(
      animation: _confettiController,
      builder: (context, child) {
        return CustomPaint(
          painter: ConfettiPainter(
            animation: _confettiController.value,
          ),
          size: Size(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height,
          ),
        );
      },
    );
  }
}

/// رسام الكونفيتي
class ConfettiPainter extends CustomPainter {
  final double animation;
  final List<ConfettiParticle> particles;

  ConfettiPainter({required this.animation})
      : particles = List.generate(
          50,
          (index) => ConfettiParticle(
            x: (index * 23) % 100 / 100,
            startY: -0.1 - ((index * 17) % 30) / 100,
            size: 6 + (index % 4) * 2,
            speed: 0.3 + (index % 5) * 0.1,
            rotation: (index * 37) % 360 / 360 * math.pi * 2,
            color: _getConfettiColor(index),
          ),
        );

  static Color _getConfettiColor(int index) {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.accent,
      AppColors.starFilled,
      AppColors.success,
    ];
    return colors[index % colors.length];
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      final x = size.width * particle.x;
      final y = size.height * (particle.startY + animation * particle.speed * 2);

      if (y > size.height) continue;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(particle.rotation + animation * math.pi * 2);

      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: particle.size.toDouble(),
        height: particle.size.toDouble() * 0.6,
      );
      canvas.drawRect(rect, paint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

class ConfettiParticle {
  final double x;
  final double startY;
  final int size;
  final double speed;
  final double rotation;
  final Color color;

  ConfettiParticle({
    required this.x,
    required this.startY,
    required this.size,
    required this.speed,
    required this.rotation,
    required this.color,
  });
}
