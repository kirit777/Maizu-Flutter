class SudokuSolver {
  bool solve(List<List<int>> board) {
    final empty = _findEmpty(board);
    if (empty == null) return true;

    final row = empty.$1;
    final col = empty.$2;

    for (var num = 1; num <= 9; num++) {
      if (_isValid(board, row, col, num)) {
        board[row][col] = num;
        if (solve(board)) {
          return true;
        }
        board[row][col] = 0;
      }
    }
    return false;
  }

  (int, int)? _findEmpty(List<List<int>> board) {
    for (var r = 0; r < 9; r++) {
      for (var c = 0; c < 9; c++) {
        if (board[r][c] == 0) return (r, c);
      }
    }
    return null;
  }

  bool _isValid(List<List<int>> board, int row, int col, int value) {
    for (var i = 0; i < 9; i++) {
      if (board[row][i] == value || board[i][col] == value) {
        return false;
      }
    }

    final boxRow = (row ~/ 3) * 3;
    final boxCol = (col ~/ 3) * 3;

    for (var r = boxRow; r < boxRow + 3; r++) {
      for (var c = boxCol; c < boxCol + 3; c++) {
        if (board[r][c] == value) return false;
      }
    }
    return true;
  }

  bool isValidComplete(List<List<int>> board) {
    for (var r = 0; r < 9; r++) {
      for (var c = 0; c < 9; c++) {
        final value = board[r][c];
        if (value == 0) return false;
        board[r][c] = 0;
        final valid = _isValid(board, r, c, value);
        board[r][c] = value;
        if (!valid) return false;
      }
    }
    return true;
  }
}
