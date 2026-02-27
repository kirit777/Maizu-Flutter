import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../core/theme.dart';
import '../providers/game_provider.dart';
import '../services/ad_service.dart';
import '../services/audio_service.dart';
import '../widgets/action_buttons.dart';
import '../widgets/number_pad.dart';
import '../widgets/stats_bar.dart';
import '../widgets/sudoku_grid.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;
  bool _resultRouted = false;

  @override
  void initState() {
    super.initState();
    if (AdService.isSupportedPlatform) {
      _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdService.bannerAdUnitId,
        listener: BannerAdListener(
          onAdLoaded: (_) => setState(() => _isBannerLoaded = true),
          onAdFailedToLoad: (ad, _) {
            ad.dispose();
            _bannerAd = null;
          },
        ),
        request: const AdRequest(),
      )..load();
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) {
        if (game.board == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if ((game.gameWon || game.gameLost) && !_resultRouted) {
          _resultRouted = true;
          if (game.gameWon) {
            unawaited(AudioService.instance.playWin());
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AdService.showInterstitial(() {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => ResultScreen(won: game.gameWon),
                  transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
                ),
              );
            });
          });
        }

        return Scaffold(
          backgroundColor: const Color(0xFFBFC3C8),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 390, maxHeight: 780),
              child: MaizuCard(
                child: Column(
                  children: [
                    const SizedBox(height: 14),
                    StatsBar(
                      difficulty: game.difficulty.label,
                      mistakes: game.mistakes,
                      time: game.formattedTime,
                    ),
                    const SizedBox(height: 10),
                    SudokuGrid(
                      board: game.board!,
                      selectedRow: game.selectedRow,
                      selectedCol: game.selectedCol,
                      onCellTap: game.selectCell,
                    ),
                    const SizedBox(height: 12),
                    ActionButtons(
                      onUndo: () {
                        unawaited(AudioService.instance.playTap());
                        game.undo();
                      },
                      onErase: () {
                        unawaited(AudioService.instance.playTap());
                        game.eraseCell();
                        unawaited(AudioService.instance.playCorrect());
                      },
                      onHint: () {
                        unawaited(AudioService.instance.playTap());
                        game.hint();
                        unawaited(AudioService.instance.playHint());
                      },
                      onNotes: () {
                        unawaited(AudioService.instance.playTap());
                        game.toggleNotesMode();
                      },
                      notesEnabled: game.notesMode,
                    ),
                    const SizedBox(height: 10),
                    NumberPad(
                      onNumber: (number) {
                        final previousMistakes = game.mistakes;
                        final wasWon = game.gameWon;
                        unawaited(AudioService.instance.playTap());
                        game.setNumber(number);
                        if (game.mistakes > previousMistakes) {
                          unawaited(AudioService.instance.playWrong());
                        } else if (!wasWon && game.gameWon) {
                          unawaited(AudioService.instance.playWin());
                        } else {
                          unawaited(AudioService.instance.playCorrect());
                        }
                      },
                    ),
                    const Spacer(),
                    if (_bannerAd != null && _isBannerLoaded)
                      SizedBox(
                        width: _bannerAd!.size.width.toDouble(),
                        height: _bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd!),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
