/// موقع في الشبكة
class GridPosition {
  final int row;
  final int col;

  const GridPosition(this.row, this.col);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GridPosition &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;

  @override
  String toString() => 'GridPosition($row, $col)';

  /// مفتاح فريد للموقع
  String get key => '${row}_$col';

  /// التحقق من التجاور مع موقع آخر
  bool isAdjacentTo(GridPosition other) {
    final rowDiff = (row - other.row).abs();
    final colDiff = (col - other.col).abs();
    return (rowDiff == 1 && colDiff == 0) || (rowDiff == 0 && colDiff == 1);
  }

  /// التحقق من التجاور القطري
  bool isDiagonallyAdjacentTo(GridPosition other) {
    final rowDiff = (row - other.row).abs();
    final colDiff = (col - other.col).abs();
    return rowDiff <= 1 && colDiff <= 1 && !(rowDiff == 0 && colDiff == 0);
  }
}
