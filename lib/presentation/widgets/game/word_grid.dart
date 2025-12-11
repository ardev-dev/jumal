import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/grid_position.dart';
import '../../../data/models/level_data_model.dart';

/// شبكة حروف اللعبة
class WordGrid extends StatelessWidget {
  final LevelDataModel levelData;
  final List<GridPosition> selectedPositions;
  final Set<String> usedCells;
  final Set<String> foundWords;
  final Map<String, List<GridPosition>> wordPositionsMap;
  final Animation<double> shakeAnimation;
  final Function(Offset position, BoxConstraints constraints) onPanStart;
  final Function(Offset position, BoxConstraints constraints) onPanUpdate;
  final VoidCallback onPanEnd;

  const WordGrid({
    super.key,
    required this.levelData,
    required this.selectedPositions,
    required this.usedCells,
    required this.foundWords,
    required this.wordPositionsMap,
    required this.shakeAnimation,
    required this.onPanStart,
    required this.onPanUpdate,
    required this.onPanEnd,
  });

  @override
  Widget build(BuildContext context) {
    final gridRows = levelData.gridRows;
    final gridCols = levelData.gridCols;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: levelData.horizontalPadding),
      child: AspectRatio(
        aspectRatio: gridCols / gridRows,
        child: AnimatedBuilder(
          animation: shakeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(sin(shakeAnimation.value) * 3, 0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GestureDetector(
                    onPanStart: (details) {
                      onPanStart(details.localPosition, constraints);
                    },
                    onPanUpdate: (details) {
                      onPanUpdate(details.localPosition, constraints);
                    },
                    onPanEnd: (_) => onPanEnd(),
                    child: Column(
                      children: List.generate(gridRows, (row) {
                        return Expanded(
                          child: Row(
                            children: List.generate(
                              levelData.gridLetters[row].length,
                              (col) {
                                return Expanded(
                                  child: _GridCell(
                                    letter: levelData.getLetterAt(row, col),
                                    fontSize: levelData.gridFontSize,
                                    isSelected: selectedPositions.any(
                                      (p) => p.row == row && p.col == col,
                                    ),
                                    isUsed: usedCells.contains('${row}_$col'),
                                    isPartOfFoundWord: _isPartOfFoundWord(row, col),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  bool _isPartOfFoundWord(int row, int col) {
    for (final word in foundWords) {
      final positions = wordPositionsMap[word];
      if (positions != null) {
        if (positions.any((p) => p.row == row && p.col == col)) {
          return true;
        }
      }
    }
    return false;
  }
}

class _GridCell extends StatelessWidget {
  final String letter;
  final double fontSize;
  final bool isSelected;
  final bool isUsed;
  final bool isPartOfFoundWord;

  const _GridCell({
    required this.letter,
    required this.fontSize,
    required this.isSelected,
    required this.isUsed,
    required this.isPartOfFoundWord,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.all(AppDimens.gridCellMargin),
      decoration: BoxDecoration(
        color: _getCellColor(),
        borderRadius: BorderRadius.circular(AppDimens.gridCellRadius),
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: _getTextColor(),
            decorationColor: Colors.white,
            decorationThickness: 2,
          ),
        ),
      ),
    );
  }

  Color _getCellColor() {
    if (isSelected) return AppColors.gridCellSelected;
    if (isUsed || isPartOfFoundWord) return AppColors.gridCellFound;
    return AppColors.gridCellDefault;
  }

  Color _getTextColor() {
    if (isSelected || isPartOfFoundWord || isUsed) {
      return AppColors.textLight;
    }
    return AppColors.textSecondary;
  }
}
