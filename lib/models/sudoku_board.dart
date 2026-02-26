import 'sudoku_cell.dart';

class SudokuBoard {
  SudokuBoard({required this.puzzle, required this.solution}) {
    cells = List.generate(
      9,
      (row) => List.generate(9, (col) {
        final value = puzzle[row][col] == 0 ? null : puzzle[row][col];
        return SudokuCell(
          row: row,
          col: col,
          value: value,
          isGiven: value != null,
        );
      }),
    );
  }

  final List<List<int>> puzzle;
  final List<List<int>> solution;
  late List<List<SudokuCell>> cells;

  SudokuBoard copy() {
    final board = SudokuBoard(
      puzzle: puzzle.map((r) => List<int>.from(r)).toList(),
      solution: solution.map((r) => List<int>.from(r)).toList(),
    );
    board.cells = cells
        .map((row) => row.map((cell) => cell.copyWith()).toList())
        .toList();
    return board;
  }

  bool isSolved() {
    for (var r = 0; r < 9; r++) {
      for (var c = 0; c < 9; c++) {
        if (cells[r][c].value != solution[r][c]) return false;
      }
    }
    return true;
  }
}
