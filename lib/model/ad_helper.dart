import 'dart:convert';

import 'package:flutterproject2/view/mainpage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

class Adhelper {
  bool testmood = true;
  bool nativeadloaded = false;

  static BannerAd getbanerad() {
    return BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-3940256099942544/6300978111",
        // ca-app-pub-3940256099942544/6300978111    test
        // ca-app-pub-2675606651389917/8572530529    real
        listener: BannerAdListener(onAdLoaded: (ad) {
          controller.bannerisready = true;
        }, onAdFailedToLoad: (ad, error) {
          print("faild to load banner ad${error.message}");
          controller.bannerisready = false;
          ad.dispose();
        }),
        request: const AdRequest())
      ..load();
  }

  static getInterstitialad() {
    if (Platform.isAndroid) {
      InterstitialAd.load(
        adUnitId: "ca-app-pub-3940256099942544/1033173712",
        //ca-app-pub-3940256099942544/1033173712     test
        //ca-app-pub-2675606651389917/5248702490     real
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          controller.rewardad = ad;

          controller.videoisadready = true;
        }, onAdFailedToLoad: (LoadAdError error) {
          print("faild to load Interstitial ad${error.message}");

          throw UnsupportedError("faild");
        }),
      );
    } else {
      throw UnsupportedError("not andriod");
    }
  }

  // static getrewardad() {
  //   if (Platform.isAndroid) {
  //     RewardedAd.load(
  //       adUnitId: "ca-app-pub-3940256099942544/5224354917",
  //       rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
  //         controller.rewardad = ad;
  //       }, onAdFailedToLoad: (LoadAdError error) {
  //         print("faild to load banner ad${error.message}");

  //         throw UnsupportedError("faild");
  //       }),
  //       request: const AdRequest(),
  //     );
  //   } else {
  //     throw UnsupportedError("not andriod");
  //   }
  // }
}
