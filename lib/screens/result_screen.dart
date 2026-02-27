import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../providers/settings_provider.dart';
import '../services/ad_service.dart';
import '../services/audio_service.dart';
import '../core/theme.dart';
import 'game_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({required this.won, super.key});
  final bool won;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 450))..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFBFC3C8),
      body: FadeTransition(
        opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390, maxHeight: 780),
            child: MaizuCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),
                  Text(widget.won ? 'Excellent' : 'Try Again', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 56, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 28),
                  const Icon(Icons.icecream, color: Colors.white, size: 210),
                  const SizedBox(height: 14),
                  const Text('All you need is ice cream', textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white, fontSize: 30, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 24),
                  _StatLine(title: 'Difficulty', value: game.difficulty.label.toUpperCase()),
                  _StatLine(title: 'Time', value: game.formattedTime),
                  _StatLine(title: 'Mistakes', value: '${game.mistakes}'),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      unawaited(AudioService.instance.playTap());
                      AdService.showInterstitial(() {
                      game.startNewGame(settings.defaultDifficulty);
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const GameScreen(),
                          transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
                        ),
                      );
                    });
                  },
                    child: Container(
                      height: 54,
                      decoration: BoxDecoration(color: const Color(0xFF12343B), borderRadius: BorderRadius.circular(27)),
                      child: const Center(
                        child: Text('New Game', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatLine extends StatelessWidget {
  const _StatLine({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
