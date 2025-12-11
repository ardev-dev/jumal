import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/level_data_model.dart';

/// عرض حوار التلميح
void showHintDialog(
  BuildContext context,
  int wordIndex,
  LevelDataModel levelData,
) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return _HintDialog(
        wordIndex: wordIndex,
        levelData: levelData,
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

/// عرض حوار عدم وجود تلميحات
void showNoHintsDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const _NoHintsDialog();
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

class _HintDialog extends StatefulWidget {
  final int wordIndex;
  final LevelDataModel levelData;

  const _HintDialog({
    required this.wordIndex,
    required this.levelData,
  });

  @override
  State<_HintDialog> createState() => _HintDialogState();
}

class _HintDialogState extends State<_HintDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _revealController;
  late Animation<double> _revealAnimation;
  bool _isRevealed = false;

  @override
  void initState() {
    super.initState();
    _revealController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _revealAnimation = CurvedAnimation(
      parent: _revealController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _revealController.dispose();
    super.dispose();
  }

  void _revealAnswer() {
    setState(() => _isRevealed = true);
    _revealController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        margin: const EdgeInsets.all(AppDimens.paddingLG),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.radiusXXL),
          boxShadow: [
            BoxShadow(
              color: AppColors.hintColor.withValues(alpha: 0.3),
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
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.all(AppDimens.paddingLG),
                child: Column(
                  children: [
                    _buildQuestionCard(),
                    const SizedBox(height: AppDimens.paddingMD),
                    _buildAnswerCard(),
                    const SizedBox(height: AppDimens.paddingLG),
                    _buildButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingLG),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: AppColors.hintGradient),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusXXL),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimens.paddingSM),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              color: Colors.white,
              size: AppDimens.iconLG,
            ),
          ),
          const SizedBox(width: AppDimens.paddingMD),
          Text(
            'تلميح',
            style: AppTextStyles.headline3.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingMD),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.help_outline_rounded,
                color: AppColors.info,
                size: 18,
              ),
              const SizedBox(width: AppDimens.paddingSM),
              Text(
                'السؤال',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.paddingSM),
          Text(
            widget.levelData.questions[widget.wordIndex],
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerCard() {
    return GestureDetector(
      onTap: _isRevealed ? null : _revealAnswer,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(AppDimens.paddingMD),
        decoration: BoxDecoration(
          gradient: _isRevealed
              ? const LinearGradient(colors: AppColors.successGradient)
              : LinearGradient(
                  colors: [
                    AppColors.hintColor.withValues(alpha: 0.1),
                    AppColors.hintGlow.withValues(alpha: 0.1),
                  ],
                ),
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          border: _isRevealed
              ? null
              : Border.all(
                  color: AppColors.hintColor.withValues(alpha: 0.3),
                  width: 2,
                ),
        ),
        child: _isRevealed ? _buildRevealedAnswer() : _buildHiddenAnswer(),
      ),
    );
  }

  Widget _buildHiddenAnswer() {
    return Column(
      children: [
        Icon(
          Icons.touch_app_rounded,
          color: AppColors.hintColor,
          size: AppDimens.iconXL,
        ),
        const SizedBox(height: AppDimens.paddingSM),
        Text(
          'اضغط لكشف الإجابة',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.hintColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildRevealedAnswer() {
    return AnimatedBuilder(
      animation: _revealAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * _revealAnimation.value),
          child: Opacity(
            opacity: _revealAnimation.value,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: AppDimens.paddingSM),
                    Text(
                      'الإجابة',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.paddingSM),
                Text(
                  widget.levelData.words[widget.wordIndex],
                  style: AppTextStyles.headline2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingMD),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          ),
          elevation: 4,
          shadowColor: AppColors.primary.withValues(alpha: 0.4),
        ),
        child: Text(
          'فهمت',
          style: AppTextStyles.button,
        ),
      ),
    );
  }
}

class _NoHintsDialog extends StatelessWidget {
  const _NoHintsDialog();

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
              color: AppColors.error.withValues(alpha: 0.2),
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
              _buildButton(context),
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
            AppColors.error.withValues(alpha: 0.2),
            AppColors.errorLight.withValues(alpha: 0.1),
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.paddingMD),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.lightbulb_outline,
          color: AppColors.error,
          size: AppDimens.iconXL,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'لا توجد تلميحات',
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
      child: Column(
        children: [
          Text(
            'لقد استنفذت جميع التلميحات المتاحة!',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimens.paddingSM),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.emoji_events_outlined,
                color: AppColors.hintColor,
                size: 18,
              ),
              const SizedBox(width: AppDimens.paddingSM),
              Text(
                'أكمل المزيد من المستويات للحصول على المزيد',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.hintColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingMD),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          ),
          elevation: 4,
          shadowColor: AppColors.error.withValues(alpha: 0.4),
        ),
        child: Text(
          'حسنًا',
          style: AppTextStyles.button,
        ),
      ),
    );
  }
}
