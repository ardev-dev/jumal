import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';

/// زر عمل دائري مع عداد
class ActionButton extends StatelessWidget {
  final IconData icon;
  final Gradient? gradient;
  final String? count;
  final VoidCallback onTap;
  final double size;
  final Color? shadowColor;

  const ActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.gradient,
    this.count,
    this.size = AppDimens.fabSize,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: gradient ?? const LinearGradient(colors: AppColors.hintGradient),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (shadowColor ?? Colors.orange).withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: AppColors.textLight, size: AppDimens.iconXL),
            if (count != null)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingSM,
                    vertical: AppDimens.paddingXS,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    count!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
