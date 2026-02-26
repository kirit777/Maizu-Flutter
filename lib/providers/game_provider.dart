import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/constants.dart';
import '../models/sudoku_board.dart';
import '../services/sudoku_generator.dart';

class Move {
  Move({required this.row, required this.col, this.previousValue, this.nextValue, Set<int>? previousNotes, Set<int>? nextNotes})
      : previousNotes = previousNotes ?? <int>{},
        nextNotes = nextNotes ?? <int>{};

  final int row;
  final int col;
  final int? previousValue;
  final int? nextValue;
  final Set<int> previousNotes;
  final Set<int> nextNotes;
}

class GameProvider extends ChangeNotifier {
  GameProvider(this._generator);

  final SudokuGenerator _generator;
  SudokuBoard? board;
  Difficulty difficulty = Difficulty.easy;
  int mistakes = 0;
  int elapsedSeconds = 0;
  bool notesMode = false;
  bool gameWon = false;
  bool gameLost = false;
  int? selectedRow;
  int? selectedCol;
  final List<Move> _undoStack = [];
  Timer? _timer;

  List<Move> get undoStack => List.unmodifiable(_undoStack);

  void startNewGame(Difficulty newDifficulty) {
    difficulty = newDifficulty;
    board = _generator.generate(newDifficulty);
    mistakes = 0;
    elapsedSeconds = 0;
    notesMode = false;
    gameWon = false;
    gameLost = false;
    selectedRow = null;
    selectedCol = null;
    _undoStack.clear();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsedSeconds++;
      notifyListeners();
    });
    notifyListeners();
  }

  void selectCell(int row, int col) {
    if (board == null) return;
    if (board!.cells[row][col].isGiven) return;
    selectedRow = row;
    selectedCol = col;
    notifyListeners();
  }

  void toggleNotesMode() {
    notesMode = !notesMode;
    notifyListeners();
  }

  void setNumber(int number) {
    if (board == null || selectedRow == null || selectedCol == null || gameWon || gameLost) return;
    final cell = board!.cells[selectedRow!][selectedCol!];
    if (cell.isGiven) return;

    if (notesMode) {
      final before = Set<int>.from(cell.notes);
      if (!cell.notes.remove(number)) {
        cell.notes.add(number);
      }
      _undoStack.add(
        Move(
          row: selectedRow!,
          col: selectedCol!,
          previousValue: cell.value,
          nextValue: cell.value,
          previousNotes: before,
          nextNotes: Set<int>.from(cell.notes),
        ),
      );
      notifyListeners();
      return;
    }

    final beforeValue = cell.value;
    final beforeNotes = Set<int>.from(cell.notes);
    cell.value = number;
    cell.notes.clear();

    _undoStack.add(
      Move(
        row: selectedRow!,
        col: selectedCol!,
        previousValue: beforeValue,
        nextValue: cell.value,
        previousNotes: beforeNotes,
        nextNotes: Set<int>.from(cell.notes),
      ),
    );

    if (number != board!.solution[selectedRow!][selectedCol!]) {
      mistakes++;
      if (mistakes >= maxMistakes) {
        gameLost = true;
        _timer?.cancel();
      }
    } else if (board!.isSolved()) {
      gameWon = true;
      _timer?.cancel();
    }

    notifyListeners();
  }

  void eraseCell() {
    if (board == null || selectedRow == null || selectedCol == null) return;
    final cell = board!.cells[selectedRow!][selectedCol!];
    if (cell.isGiven) return;
    final prev = cell.value;
    final prevNotes = Set<int>.from(cell.notes);
    cell.value = null;
    cell.notes.clear();

    _undoStack.add(
      Move(
        row: selectedRow!,
        col: selectedCol!,
        previousValue: prev,
        nextValue: null,
        previousNotes: prevNotes,
        nextNotes: const <int>{},
      ),
    );
    notifyListeners();
  }

  void hint() {
    if (board == null || gameWon || gameLost) return;
    for (var r = 0; r < 9; r++) {
      for (var c = 0; c < 9; c++) {
        final cell = board!.cells[r][c];
        if (!cell.isGiven && cell.value != board!.solution[r][c]) {
          selectedRow = r;
          selectedCol = c;
          final prev = cell.value;
          cell.value = board!.solution[r][c];
          cell.notes.clear();
          _undoStack.add(Move(row: r, col: c, previousValue: prev, nextValue: cell.value));
          if (board!.isSolved()) {
            gameWon = true;
            _timer?.cancel();
          }
          notifyListeners();
          return;
        }
      }
    }
  }

  void undo() {
    if (board == null || _undoStack.isEmpty || gameWon || gameLost) return;
    final move = _undoStack.removeLast();
    final cell = board!.cells[move.row][move.col];
    cell.value = move.previousValue;
    cell.notes = Set<int>.from(move.previousNotes);
    notifyListeners();
  }

  String get formattedTime {
    final mins = (elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final sec = (elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$sec';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
