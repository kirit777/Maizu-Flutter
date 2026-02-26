import 'package:flutter/foundation.dart';

import '../core/constants.dart';

class SettingsProvider extends ChangeNotifier {
  bool soundOn = true;
  Difficulty defaultDifficulty = Difficulty.easy;

  void toggleSound(bool value) {
    soundOn = value;
    notifyListeners();
  }

  void setDifficulty(Difficulty difficulty) {
    defaultDifficulty = difficulty;
    notifyListeners();
  }

  void resetProgress() {
    defaultDifficulty = Difficulty.easy;
    soundOn = true;
    notifyListeners();
  }
}
