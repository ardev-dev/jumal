import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// خلفية متدرجة احترافية للتطبيق
class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final bool showPattern;
  final bool showOverlay;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const GradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.showPattern = false,
    this.showOverlay = false,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الخلفية المتدرجة الرئيسية
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: begin,
              end: end,
              colors: colors ?? AppColors.backgroundGradient,
            ),
          ),
        ),

        // نمط الزخرفة (اختياري)
        if (showPattern) _buildPattern(),

        // طبقة التظليل (اختياري)
        if (showOverlay) _buildOverlay(),

        // المحتوى
        child,
      ],
    );
  }

  Widget _buildPattern() {
    return Positioned.fill(
      child: CustomPaint(
        painter: PatternPainter(),
      ),
    );
  }

  Widget _buildOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.1),
              Colors.transparent,
              Colors.black.withValues(alpha: 0.2),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }
}

/// خلفية متدرجة متحركة
class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final List<List<Color>> gradients;
  final Duration duration;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
    this.gradients = const [
      AppColors.backgroundGradient,
      AppColors.oceanGradient,
    ],
    this.duration = const Duration(seconds: 5),
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _currentIndex = (_currentIndex + 1) % widget.gradients.length;
          });
          _controller.forward(from: 0);
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nextIndex = (_currentIndex + 1) % widget.gradients.length;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.lerp(
                      widget.gradients[_currentIndex][0],
                      widget.gradients[nextIndex][0],
                      _controller.value,
                    )!,
                    Color.lerp(
                      widget.gradients[_currentIndex][1],
                      widget.gradients[nextIndex][1],
                      _controller.value,
                    )!,
                  ],
                ),
              ),
            ),
            widget.child,
          ],
        );
      },
    );
  }
}

/// خلفية زجاجية (Glassmorphism)
class GlassBackground extends StatelessWidget {
  final Widget child;
  final double blur;
  final Color? color;
  final BorderRadius? borderRadius;
  final Border? border;

  const GlassBackground({
    super.key,
    required this.child,
    this.blur = 10,
    this.color,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color ?? Colors.white.withValues(alpha: 0.1),
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          border: border ??
              Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
        ),
        child: child,
      ),
    );
  }
}

/// رسام نمط الزخرفة
class PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    const spacing = 60.0;
    const radius = 3.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
