import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// شارة إحصائيات مع أيقونة ورقم
class StatBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const StatBadge({
    super.key,
    required this.icon,
    required this.value,
    this.gradient,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingLG,
        vertical: AppDimens.paddingMD,
      ),
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? backgroundColor ?? Colors.white : null,
        borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        boxShadow: [
          BoxShadow(
            color: (gradient != null ? gradient!.colors.first : Colors.black)
                .withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: iconColor ?? Colors.white,
            size: AppDimens.iconMD,
          ),
          const SizedBox(width: AppDimens.paddingSM),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              value,
              key: ValueKey(value),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor ?? Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }

    return content;
  }
}
