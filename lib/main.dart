import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'core/theme.dart';
import 'providers/game_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/home_screen.dart';
import 'services/ad_service.dart';
import 'services/audio_service.dart';
import 'services/preference_service.dart';
import 'services/sudoku_generator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (AdService.isSupportedPlatform) {
    await MobileAds.instance.initialize();
  }
  await PreferenceService.init();
  await AudioService.instance.init(
    musicEnabled: PreferenceService.musicEnabled,
    effectsEnabled: PreferenceService.effectsEnabled,
    volume: PreferenceService.masterVolume,
  );
  if (AdService.isSupportedPlatform) {
    AdService.loadInterstitial();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AudioService.instance.playBackgroundMusic();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AudioService.instance.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      AudioService.instance.pauseBackgroundMusic();
    }
    if (state == AppLifecycleState.resumed) {
      AudioService.instance.playBackgroundMusic();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => GameProvider(SudokuGenerator())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Maizu Sudoku',
        theme: AppTheme.theme,
        home: const HomeScreen(),
      ),
    );
  }
}
