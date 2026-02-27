import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  AdService._();

  static InterstitialAd? _interstitialAd;

  static bool get isSupportedPlatform {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
  }

  static String get bannerAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.android) return 'ca-app-pub-3940256099942544/6300978111';
    if (defaultTargetPlatform == TargetPlatform.iOS) return 'ca-app-pub-3940256099942544/2934735716';
    return BannerAd.testAdUnitId;
  }

  static String get interstitialAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.android) return 'ca-app-pub-3940256099942544/1033173712';
    if (defaultTargetPlatform == TargetPlatform.iOS) return 'ca-app-pub-3940256099942544/4411468910';
    return InterstitialAd.testAdUnitId;
  }

  static void loadInterstitial() {
    if (!isSupportedPlatform) return;
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
    if (!isSupportedPlatform) {
      onComplete();
      return;
    }

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
