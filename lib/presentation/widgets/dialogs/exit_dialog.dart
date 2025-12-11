import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';

/// عرض حوار الخروج من المستوى
Future<bool?> showExitDialog(BuildContext context) {
  return showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const _ExitDialog();
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

class _ExitDialog extends StatelessWidget {
  const _ExitDialog();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        margin: const EdgeInsets.all(AppDimens.paddingLG),
        padding: const EdgeInsets.all(AppDimens.paddingLG),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.radiusXXL),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIcon(),
              const SizedBox(height: AppDimens.paddingMD),
              _buildTitle(),
              const SizedBox(height: AppDimens.paddingSM),
              _buildMessage(),
              const SizedBox(height: AppDimens.paddingLG),
              _buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingMD),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.warning.withValues(alpha: 0.2),
            AppColors.warningLight.withValues(alpha: 0.1),
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.paddingMD),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.warning_amber_rounded,
          color: AppColors.warning,
          size: AppDimens.iconXL,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'الخروج من المستوى؟',
      textAlign: TextAlign.center,
      style: AppTextStyles.headline3.copyWith(
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildMessage() {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingMD),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: AppDimens.paddingSM),
          Expanded(
            child: Text(
              'سيتم فقدان تقدمك الحالي في هذا المستوى.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildButton(
            context: context,
            label: 'إلغاء',
            onPressed: () => Navigator.pop(context, false),
            isPrimary: false,
          ),
        ),
        const SizedBox(width: AppDimens.paddingMD),
        Expanded(
          child: _buildButton(
            context: context,
            label: 'الخروج',
            onPressed: () => Navigator.pop(context, true),
            isPrimary: true,
            isDestructive: true,
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
    bool isPrimary = false,
    bool isDestructive = false,
  }) {
    final gradient = isDestructive
        ? AppColors.accentGradient
        : isPrimary
            ? AppColors.primaryGradient
            : null;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingMD),
        decoration: BoxDecoration(
          gradient: gradient != null ? LinearGradient(colors: gradient) : null,
          color: gradient == null ? AppColors.surfaceVariant : null,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          boxShadow: isPrimary || isDestructive
              ? [
                  BoxShadow(
                    color: (isDestructive ? AppColors.accent : AppColors.primary)
                        .withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.button.copyWith(
              color: isPrimary || isDestructive
                  ? Colors.white
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
