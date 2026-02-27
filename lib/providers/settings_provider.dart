import 'package:flutter/foundation.dart';

import '../core/constants.dart';
import '../services/audio_service.dart';
import '../services/preference_service.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider() {
    musicOn = PreferenceService.musicEnabled;
    soundEffectsOn = PreferenceService.effectsEnabled;
    volume = PreferenceService.masterVolume;
    defaultDifficulty = PreferenceService.defaultDifficulty;
  }

  bool musicOn = true;
  bool soundEffectsOn = true;
  double volume = 0.4;
  Difficulty defaultDifficulty = Difficulty.easy;

  Future<void> toggleMusic(bool value) async {
    musicOn = value;
    notifyListeners();
    await PreferenceService.setMusicEnabled(value);
    await AudioService.instance.setMusicEnabled(value);
  }

  Future<void> toggleSoundEffects(bool value) async {
    soundEffectsOn = value;
    notifyListeners();
    await PreferenceService.setEffectsEnabled(value);
    await AudioService.instance.setEffectsEnabled(value);
  }

  Future<void> setVolume(double value) async {
    volume = value;
    notifyListeners();
    await PreferenceService.setMasterVolume(value);
    await AudioService.instance.setVolume(value);
  }

  Future<void> setDifficulty(Difficulty difficulty) async {
    defaultDifficulty = difficulty;
    notifyListeners();
    await PreferenceService.setDefaultDifficulty(difficulty);
  }

  Future<void> resetProgress() async {
    defaultDifficulty = Difficulty.easy;
    musicOn = true;
    soundEffectsOn = true;
    volume = 0.4;
    notifyListeners();

    await PreferenceService.reset();
    await AudioService.instance.setMusicEnabled(musicOn);
    await AudioService.instance.setEffectsEnabled(soundEffectsOn);
    await AudioService.instance.setVolume(volume);
  }
}
