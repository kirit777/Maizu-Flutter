import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static InterstitialAd? _interstitialAd;

  static String get bannerAdUnitId {
    if (kDebugMode) return BannerAd.testAdUnitId;
    if (Platform.isAndroid) return 'ca-app-pub-xxxxxxxxxxxxxxxx/banner_android';
    return 'ca-app-pub-xxxxxxxxxxxxxxxx/banner_ios';
  }

  static String get interstitialAdUnitId {
    if (kDebugMode) return InterstitialAd.testAdUnitId;
    if (Platform.isAndroid) return 'ca-app-pub-xxxxxxxxxxxxxxxx/interstitial_android';
    return 'ca-app-pub-xxxxxxxxxxxxxxxx/interstitial_ios';
  }

  static void loadInterstitial() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (_) {
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
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitial();
        onComplete();
      },
    );

    ad.show();
  }
}
