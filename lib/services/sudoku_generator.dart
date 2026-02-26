import 'dart:math';

import '../core/constants.dart';
import '../models/sudoku_board.dart';
import 'sudoku_solver.dart';

class SudokuGenerator {
  SudokuGenerator({Random? random}) : _random = random ?? Random();

  final Random _random;
  final SudokuSolver _solver = SudokuSolver();

  SudokuBoard generate(Difficulty difficulty) {
    final solved = _generateFullGrid();
    final puzzle = solved.map((row) => List<int>.from(row)).toList();
    _removeCells(puzzle, difficulty.removedCells);
    return SudokuBoard(puzzle: puzzle, solution: solved);
  }

  List<List<int>> _generateFullGrid() {
    final grid = List.generate(9, (_) => List.filled(9, 0));
    _fillDiagonal(grid);
    _solver.solve(grid);
    return grid;
  }

  void _fillDiagonal(List<List<int>> grid) {
    for (var i = 0; i < 9; i += 3) {
      _fillBox(grid, i, i);
    }
  }

  void _fillBox(List<List<int>> grid, int startRow, int startCol) {
    final numbers = List.generate(9, (i) => i + 1)..shuffle(_random);
    var index = 0;
    for (var r = 0; r < 3; r++) {
      for (var c = 0; c < 3; c++) {
        grid[startRow + r][startCol + c] = numbers[index++];
      }
    }
  }

  void _removeCells(List<List<int>> grid, int count) {
    var removed = 0;
    while (removed < count) {
      final row = _random.nextInt(9);
      final col = _random.nextInt(9);
      if (grid[row][col] != 0) {
        grid[row][col] = 0;
        removed++;
      }
    }
  }
}
