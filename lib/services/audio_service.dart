import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  AudioService._();

  static final AudioService instance = AudioService._();

  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _initialized = false;
  bool _musicEnabled = true;
  bool _effectsEnabled = true;
  double _volume = 0.4;

  Future<void> init({required bool musicEnabled, required bool effectsEnabled, required double volume}) async {
    _musicEnabled = musicEnabled;
    _effectsEnabled = effectsEnabled;
    _volume = volume;

    if (_initialized) {
      await _applyVolumes();
      return;
    }

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    await _musicPlayer.setLoopMode(LoopMode.one);
    await _musicPlayer.setAsset('assets/audio/bg_music.mp3');

    await _sfxPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: const [
          AudioSource.asset('assets/audio/tap.wav', tag: 'tap'),
          AudioSource.asset('assets/audio/correct.wav', tag: 'correct'),
          AudioSource.asset('assets/audio/wrong.wav', tag: 'wrong'),
          AudioSource.asset('assets/audio/hint.wav', tag: 'hint'),
          AudioSource.asset('assets/audio/win.wav', tag: 'win'),
        ],
        useLazyPreparation: false,
      ),
      preload: true,
    );

    _initialized = true;
    await _applyVolumes();
  }

  Future<void> _applyVolumes() async {
    await _musicPlayer.setVolume(_musicEnabled ? _volume.clamp(0.3, 0.5).toDouble() : 0);
    await _sfxPlayer.setVolume(_effectsEnabled ? _volume : 0);
  }

  Future<void> playBackgroundMusic() async {
    if (!_initialized || !_musicEnabled) return;
    if (!_musicPlayer.playing) {
      await _musicPlayer.play();
    }
  }

  Future<void> pauseBackgroundMusic() async {
    if (!_initialized) return;
    await _musicPlayer.pause();
  }

  Future<void> setMusicEnabled(bool enabled) async {
    _musicEnabled = enabled;
    await _applyVolumes();
    if (enabled) {
      await playBackgroundMusic();
    } else {
      await pauseBackgroundMusic();
    }
  }

  Future<void> setEffectsEnabled(bool enabled) async {
    _effectsEnabled = enabled;
    await _applyVolumes();
  }

  Future<void> setVolume(double value) async {
    _volume = value;
    await _applyVolumes();
  }

  Future<void> playTap() => _playEffect(index: 0, haptic: true);

  Future<void> playCorrect() => _playEffect(index: 1);

  Future<void> playWrong() => _playEffect(index: 2, haptic: true);

  Future<void> playHint() => _playEffect(index: 3);

  Future<void> playWin() => _playEffect(index: 4, haptic: true);

  Future<void> _playEffect({required int index, bool haptic = false}) async {
    if (!_initialized || !_effectsEnabled) return;
    unawaited(_sfxPlayer.seek(Duration.zero, index: index));
    unawaited(_sfxPlayer.play());
    if (haptic) {
      unawaited(HapticFeedback.lightImpact());
    }
  }

  Future<void> dispose() async {
    await _musicPlayer.dispose();
    await _sfxPlayer.dispose();
  }
}
