import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../providers/settings_provider.dart';

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
                  title: const Text('Sound', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20)),
                  value: settings.soundOn,
                  onChanged: settings.toggleSound,
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
                          onSelected: (_) => settings.setDifficulty(d),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: settings.resetProgress, child: const Text('Reset progress')),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=com.example.maizu_sudoku')),
                  child: const Text('Rate app'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Share.share('Play Maizu Sudoku now!'),
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
