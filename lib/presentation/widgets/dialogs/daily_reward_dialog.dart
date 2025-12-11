import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

/// عرض حوار المكافأة اليومية
void showDailyRewardDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const _DailyRewardDialog(),
  );
}

class _DailyRewardDialog extends StatelessWidget {
  const _DailyRewardDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.paddingLG),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber.shade400, Colors.orange.shade400],
          ),
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.card_giftcard, size: 80, color: Colors.white),
            const SizedBox(height: AppDimens.paddingMD),
            const Text(
              '🎁 مكافأة يومية!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppDimens.paddingMD),
            const Text(
              'لقد حصلت على:',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: AppDimens.paddingMD),
            Container(
              padding: const EdgeInsets.all(AppDimens.paddingMD),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lightbulb,
                        color: Colors.orange,
                        size: AppDimens.iconLG,
                      ),
                      const SizedBox(width: AppDimens.paddingSM),
                      Text(
                        '+${AppConstants.dailyRewardHints} تلميحات',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.paddingSM),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.stars,
                        color: Colors.purple,
                        size: AppDimens.iconLG,
                      ),
                      const SizedBox(width: AppDimens.paddingSM),
                      Text(
                        '+${AppConstants.dailyRewardScore} نقطة',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.paddingLG),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.orange.shade700,
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: AppDimens.paddingMD,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusXL),
                ),
              ),
              child: const Text(
                'رائع!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
