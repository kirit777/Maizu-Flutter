import 'package:flutter/material.dart';

enum Difficulty { easy, medium, hard }

extension DifficultyX on Difficulty {
  String get label {
    switch (this) {
      case Difficulty.easy:
        return 'Easy';
      case Difficulty.medium:
        return 'Medium';
      case Difficulty.hard:
        return 'Hard';
    }
  }

  int get removedCells {
    switch (this) {
      case Difficulty.easy:
        return 38;
      case Difficulty.medium:
        return 48;
      case Difficulty.hard:
        return 56;
    }
  }
}

class AppColors {
  static const gradientTop = Color(0xFFF6B545);
  static const gradientBottom = Color(0xFFF28C38);
  static const darkTeal = Color(0xFF12343B);
  static const boardLine = Color(0xFFD3D3D3);
  static const boardBoldLine = Color(0xFFAA9A64);
  static const selectedCell = Color(0xFFFFE1B7);
  static const givenNumber = Color(0xFF111111);
  static const mistakeNumber = Color(0xFFD74747);
  static const softWhite = Color(0xFFF9F9F9);
}

const maxMistakes = 10;
