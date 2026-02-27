import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  AdService._();

  static InterstitialAd? _interstitialAd;

  static String get bannerAdUnitId {
    if (Platform.isAndroid) return 'ca-app-pub-3940256099942544/6300978111';
    if (Platform.isIOS) return 'ca-app-pub-3940256099942544/2934735716';
    return BannerAd.testAdUnitId;
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) return 'ca-app-pub-3940256099942544/1033173712';
    if (Platform.isIOS) return 'ca-app-pub-3940256099942544/4411468910';
    return InterstitialAd.testAdUnitId;
  }

  static void loadInterstitial() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) {
          if (kDebugMode) {
            debugPrint('Interstitial load failed: ${error.message}');
          }
          _interstitialAd = null;
        },
      ),
    );
  }

  static void showInterstitial(VoidCallback onComplete) {
    final ad = _interstitialAd;
    if (ad == null) {
      onComplete();
      loadInterstitial();
      return;
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitial();
        onComplete();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        if (kDebugMode) {
          debugPrint('Interstitial show failed: ${error.message}');
        }
        ad.dispose();
        _interstitialAd = null;
        loadInterstitial();
        onComplete();
      },
    );

    ad.show();
  }
}
