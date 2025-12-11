import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/time_utils.dart';
import '../../../data/models/level_data_model.dart';

/// عرض الأسئلة بشكل carousel
class QuestionsCarousel extends StatelessWidget {
  final LevelDataModel levelData;
  final List<bool> wordFound;
  final int elapsedSeconds;
  final int foundWordsCount;

  const QuestionsCarousel({
    super.key,
    required this.levelData,
    required this.wordFound,
    required this.elapsedSeconds,
    required this.foundWordsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatusRow(),
        const SizedBox(height: AppDimens.paddingMD),
        _buildQuestionsPageView(context),
      ],
    );
  }

  Widget _buildStatusRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingLG),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // الوقت
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.paddingMD,
              vertical: AppDimens.paddingXS,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade300, Colors.orange.shade100],
              ),
              borderRadius: BorderRadius.circular(AppDimens.radiusMD),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer, size: 18, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  TimeUtils.formatSeconds(elapsedSeconds),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimens.paddingMD),
          // عدد الكلمات
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.paddingMD,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: AppColors.primaryGradient),
              borderRadius: BorderRadius.circular(AppDimens.radiusMD),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '$foundWordsCount/${levelData.words.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsPageView(BuildContext context) {
    return SizedBox(
      height: 80,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.8),
        itemCount: levelData.questions.length,
        itemBuilder: (context, index) {
          final isFound = wordFound[index];
          return _QuestionCard(
            question: levelData.questions[index],
            word: levelData.words[index],
            isFound: isFound,
          );
        },
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final String question;
  final String word;
  final bool isFound;

  const _QuestionCard({
    required this.question,
    required this.word,
    required this.isFound,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 80.0,
          width: MediaQuery.of(context).size.width * 0.8,
          margin: const EdgeInsets.only(
            right: AppDimens.paddingMD,
            left: AppDimens.paddingMD,
            bottom: AppDimens.paddingMD,
          ),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppDimens.radiusLG),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              question,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
            ),
          ),
        ),
        if (isFound)
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingMD,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(AppDimens.radiusLG),
              ),
              child: Text(
                word,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  height: 1.2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
