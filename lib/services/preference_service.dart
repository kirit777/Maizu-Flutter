import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';

class PreferenceService {
  PreferenceService._();

  static late SharedPreferences _prefs;

  static const _musicEnabledKey = 'music_enabled';
  static const _effectsEnabledKey = 'effects_enabled';
  static const _masterVolumeKey = 'master_volume';
  static const _difficultyKey = 'default_difficulty';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get musicEnabled => _prefs.getBool(_musicEnabledKey) ?? true;

  static Future<void> setMusicEnabled(bool enabled) async {
    await _prefs.setBool(_musicEnabledKey, enabled);
  }

  static bool get effectsEnabled => _prefs.getBool(_effectsEnabledKey) ?? true;

  static Future<void> setEffectsEnabled(bool enabled) async {
    await _prefs.setBool(_effectsEnabledKey, enabled);
  }

  static double get masterVolume => _prefs.getDouble(_masterVolumeKey) ?? 0.4;

  static Future<void> setMasterVolume(double value) async {
    await _prefs.setDouble(_masterVolumeKey, value);
  }

  static Difficulty get defaultDifficulty {
    final value = _prefs.getString(_difficultyKey);
    return Difficulty.values.firstWhere(
      (difficulty) => difficulty.name == value,
      orElse: () => Difficulty.easy,
    );
  }

  static Future<void> setDefaultDifficulty(Difficulty difficulty) async {
    await _prefs.setString(_difficultyKey, difficulty.name);
  }

  static Future<void> reset() async {
    await _prefs.remove(_musicEnabledKey);
    await _prefs.remove(_effectsEnabledKey);
    await _prefs.remove(_masterVolumeKey);
    await _prefs.remove(_difficultyKey);
  }
}
