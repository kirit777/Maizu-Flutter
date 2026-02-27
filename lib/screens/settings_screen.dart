import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../providers/settings_provider.dart';
import '../services/audio_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFBFC3C8),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 390, maxHeight: 780),
          child: MaizuCard(
            child: ListView(
              children: [
                const Text('Settings', style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.white), textAlign: TextAlign.center),
                const SizedBox(height: 24),
                SwitchListTile(
                  title: const Text('Background Music', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20)),
                  value: settings.musicOn,
                  onChanged: (value) {
                    unawaited(AudioService.instance.playTap());
                    settings.toggleMusic(value);
                  },
                ),
                SwitchListTile(
                  title: const Text('Sound Effects', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20)),
                  value: settings.soundEffectsOn,
                  onChanged: (value) {
                    unawaited(AudioService.instance.playTap());
                    settings.toggleSoundEffects(value);
                  },
                ),
                const SizedBox(height: 8),
                const Text('Volume', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20)),
                Slider(
                  value: settings.volume * 100,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: '${(settings.volume * 100).round()}%',
                  onChanged: (value) => settings.setVolume(value / 100),
                ),
                const SizedBox(height: 8),
                const Text('Difficulty', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: Difficulty.values
                      .map(
                        (d) => ChoiceChip(
                          label: Text(d.label),
                          selected: settings.defaultDifficulty == d,
                          onSelected: (_) {
                            unawaited(AudioService.instance.playTap());
                            settings.setDifficulty(d);
                          },
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    unawaited(AudioService.instance.playTap());
                    settings.resetProgress();
                  },
                  child: const Text('Reset progress'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    unawaited(AudioService.instance.playTap());
                    launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=com.example.maizu_sudoku'));
                  },
                  child: const Text('Rate app'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    unawaited(AudioService.instance.playTap());
                    SharePlus.instance.share(const ShareParams(text: 'Play Maizu Sudoku now!'));
                  },
                  child: const Text('Share'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
