import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../models/sudoku_board.dart';

class SudokuGrid extends StatelessWidget {
  const SudokuGrid({
    required this.board,
    required this.selectedRow,
    required this.selectedCol,
    required this.onCellTap,
    super.key,
  });

  final SudokuBoard board;
  final int? selectedRow;
  final int? selectedCol;
  final void Function(int row, int col) onCellTap;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.boardBoldLine, width: 1.8),
        ),
        child: Column(
          children: List.generate(9, (row) {
            return Expanded(
              child: Row(
                children: List.generate(9, (col) {
                  final cell = board.cells[row][col];
                  final selected = selectedRow == row && selectedCol == col;
                  final isMistake = cell.value != null && cell.value != board.solution[row][col] && !cell.isGiven;
                  final thickRight = (col + 1) % 3 == 0 && col != 8;
                  final thickBottom = (row + 1) % 3 == 0 && row != 8;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onCellTap(row, col),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.selectedCell : Colors.white,
                          border: Border(
                            right: BorderSide(
                              color: thickRight ? AppColors.boardBoldLine : AppColors.boardLine,
                              width: thickRight ? 1.8 : 0.65,
                            ),
                            bottom: BorderSide(
                              color: thickBottom ? AppColors.boardBoldLine : AppColors.boardLine,
                              width: thickBottom ? 1.8 : 0.65,
                            ),
                          ),
                        ),
                        child: Center(
                          child: cell.value != null
                              ? Text(
                                  '${cell.value}',
                                  style: TextStyle(
                                    fontSize: 29,
                                    color: isMistake
                                        ? AppColors.mistakeNumber
                                        : (cell.isGiven ? AppColors.givenNumber : Colors.black87),
                                    fontWeight: cell.isGiven ? FontWeight.w900 : FontWeight.w700,
                                  ),
                                )
                              : cell.notes.isEmpty
                                  ? null
                                  : Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        children: List.generate(
                                          9,
                                          (i) => SizedBox(
                                            width: 12,
                                            child: Text(
                                              cell.notes.contains(i + 1) ? '${i + 1}' : '',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(fontSize: 9, color: Colors.black54),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ),
      ),
    );
  }
}
