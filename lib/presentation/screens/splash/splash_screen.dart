import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/service_locator.dart';
import '../../widgets/dialogs/daily_reward_dialog.dart';
import '../home/level_map_screen.dart';

/// شاشة البداية الاحترافية
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  late AnimationController _loadingController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotateAnimation;
  late Animation<double> _titleFadeAnimation;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<double> _subtitleFadeAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _loadingAnimation;

  @override
  void initState() {
    super.initState();
    _setStatusBar();
    _setupAnimations();
    _startAnimations();
    _navigateToHome();
    _checkDailyReward();
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
    // المتحكم الرئيسي
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // متحكم النبض للشعار
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // متحكم الجسيمات
    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // متحكم التحميل
    _loadingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // حركة تكبير الشعار مع تأثير مطاطي
    _logoScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 40,
      ),
    ]).animate(_mainController);

    // حركة دوران خفيف للشعار
    _logoRotateAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // حركة ظهور العنوان
    _titleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );

    // حركة انزلاق العنوان
    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    // حركة ظهور العنوان الفرعي
    _subtitleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.6, 0.85, curve: Curves.easeOut),
      ),
    );

    // تأثير التوهج
    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // حركة شريط التحميل
    _loadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() {
    _mainController.forward();
    _pulseController.repeat(reverse: true);
    _particleController.repeat();
    _loadingController.forward();
  }

  void _navigateToHome() {
    Future.delayed(
      const Duration(seconds: AppConstants.splashDuration),
      () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const LevelMapScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.1),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    )),
                    child: child,
                  ),
                );
              },
              transitionDuration: const Duration(milliseconds: 800),
            ),
          );
        }
      },
    );
  }

  void _checkDailyReward() async {
    final canClaim = await gameRepository.claimDailyReward();
    if (canClaim && mounted) {
      Future.delayed(
        const Duration(seconds: AppConstants.splashDuration),
        () {
          if (mounted) {
            showDailyRewardDialog(context);
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية المتدرجة
          _buildBackground(),

          // الجسيمات المتحركة
          _buildParticles(),

          // المحتوى الرئيسي
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  _buildAnimatedLogo(),
                  const SizedBox(height: AppDimens.paddingXL),
                  _buildAnimatedTitle(),
                  const SizedBox(height: AppDimens.paddingSM),
                  _buildAnimatedSubtitle(),
                  const Spacer(flex: 2),
                  _buildLoadingProgress(),
                  const SizedBox(height: AppDimens.paddingXL),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.backgroundGradient,
          stops: [0.0, 1.0],
        ),
      ),
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  AppColors.primaryLight
                      .withValues(alpha: 0.2 * _glowAnimation.value),
                  Colors.transparent,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildParticles() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlesPainter(
            animation: _particleController.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Transform.rotate(
            angle: _logoRotateAnimation.value,
            child: AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, Color(0xFFF0F0F0)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryLight.withValues(
                            alpha: 0.4 + (0.3 * _glowAnimation.value)),
                        blurRadius: 30 + (20 * _glowAnimation.value),
                        spreadRadius: 5,
                      ),
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: -5,
                        offset: const Offset(-5, -5),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // الدائرة الداخلية المتدرجة
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: AppColors.primarySoftGradient,
                          ),
                        ),
                      ),
                      // الأيقونة
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.white, Colors.white70],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(bounds),
                        child: const Icon(
                          Icons.grid_view_rounded,
                          size: 70,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedTitle() {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _titleFadeAnimation,
          child: SlideTransition(
            position: _titleSlideAnimation,
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.white, Color(0xFFE8E8E8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(bounds),
              child: Text(
                AppConstants.appName,
                style: AppTextStyles.displayLarge.copyWith(
                  fontSize: 56,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: AppColors.primaryDark.withValues(alpha: 0.5),
                      offset: const Offset(2, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedSubtitle() {
    return FadeTransition(
      opacity: _subtitleFadeAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingLG,
          vertical: AppDimens.paddingSM,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppDimens.radiusXL),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Text(
          AppConstants.appTitle,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textMuted,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingProgress() {
    return AnimatedBuilder(
      animation: _loadingAnimation,
      builder: (context, child) {
        return Column(
          children: [
            // شريط التحميل
            Container(
              width: 200,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: 200 * _loadingAnimation.value,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.secondaryLight,
                          AppColors.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondary.withValues(alpha: 0.5),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.paddingMD),
            // نص التحميل
            Text(
              'جاري التحميل...',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// رسام الجسيمات المتحركة
class ParticlesPainter extends CustomPainter {
  final double animation;
  final List<Particle> particles;

  ParticlesPainter({required this.animation})
      : particles = List.generate(
          30,
          (index) => Particle(
            x: (index * 37) % 100 / 100,
            y: (index * 53) % 100 / 100,
            size: 2 + (index % 4),
            speed: 0.3 + (index % 5) * 0.1,
            opacity: 0.1 + (index % 5) * 0.1,
          ),
        );

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: particle.opacity)
        ..style = PaintingStyle.fill;

      final x = size.width * particle.x;
      final y = (size.height * particle.y +
              (animation * size.height * particle.speed)) %
          size.height;

      canvas.drawCircle(
        Offset(x, y),
        particle.size.toDouble(),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ParticlesPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

class Particle {
  final double x;
  final double y;
  final int size;
  final double speed;
  final double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}
