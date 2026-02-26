class SudokuCell {
  SudokuCell({
    required this.row,
    required this.col,
    this.value,
    this.isGiven = false,
    Set<int>? notes,
  }) : notes = notes ?? <int>{};

  final int row;
  final int col;
  int? value;
  bool isGiven;
  Set<int> notes;

  SudokuCell copyWith({
    int? value,
    bool? isGiven,
    Set<int>? notes,
  }) {
    return SudokuCell(
      row: row,
      col: col,
      value: value ?? this.value,
      isGiven: isGiven ?? this.isGiven,
      notes: notes ?? Set<int>.from(this.notes),
    );
  }
}
