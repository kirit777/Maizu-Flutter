import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../providers/game_provider.dart';
import '../providers/settings_provider.dart';
import '../services/ad_service.dart';
import 'game_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AdService.bannerAdUnitId,
      listener: const BannerAdListener(),
      request: const AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFFBFC3C8),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 390, maxHeight: 780),
          child: MaizuCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 18),
                const Text('Maizu', textAlign: TextAlign.center, style: TextStyle(fontSize: 56, fontWeight: FontWeight.w500, fontFamily: 'serif')),
                const Text('SUDOKU', textAlign: TextAlign.center, style: TextStyle(fontSize: 64, fontWeight: FontWeight.w900, height: .85, fontFamily: 'serif')),
                const Spacer(),
                _MenuButton(
                  label: 'PLAY',
                  onTap: () => AdService.showInterstitial(() {
                    context.read<GameProvider>().startNewGame(settings.defaultDifficulty);
                    Navigator.of(context).push(_fadeRoute(const GameScreen()));
                  }),
                ),
                const SizedBox(height: 16),
                _MenuButton(
                  label: 'ACHIEVEMENTS',
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Achievements coming soon'))),
                ),
                const SizedBox(height: 16),
                _MenuButton(
                  label: 'SETTINGS',
                  onTap: () => Navigator.of(context).push(_fadeRoute(const SettingsScreen())),
                ),
                const Spacer(),
                if (_bannerAd != null)
                  Center(
                    child: SizedBox(
                      width: _bannerAd!.size.width.toDouble(),
                      height: _bannerAd!.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd!),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Route _fadeRoute(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
    );
  }
}

class _MenuButton extends StatefulWidget {
  const _MenuButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<_MenuButton> {
  double _scale = 1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTapDown: (_) => setState(() => _scale = .97),
        onTapUp: (_) {
          setState(() => _scale = 1);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _scale = 1),
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 120),
          child: Container(
            width: 260,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.darkTeal,
              borderRadius: BorderRadius.circular(26),
            ),
            alignment: Alignment.center,
            child: Text(widget.label, style: const TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
          ),
        ),
      ),
    );
  }
}
