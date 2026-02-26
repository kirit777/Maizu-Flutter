import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'core/theme.dart';
import 'providers/game_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/home_screen.dart';
import 'services/ad_service.dart';
import 'services/sudoku_generator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  AdService.loadInterstitial();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
