import 'package:get/get.dart';
import 'package:flutterproject2/controller/wallpapercontroller.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

class Adhelper {
  static BannerAd getbanerad() {
    return BannerAd(
        size: Get.width <= 468 ? AdSize.banner : AdSize.fullBanner,
        adUnitId: "ca-app-pub-2675606651389917/1119643385",
        // ca-app-pub-3940256099942544/6300978111    test
        // ca-app-pub-2675606651389917/1119643385    real
        listener: BannerAdListener(onAdLoaded: (ad) {
          final c = Get.isRegistered<Newscontroller>()
              ? Get.find<Newscontroller>()
              : null;
          if (c != null) c.bannerisready = true;
        }, onAdFailedToLoad: (ad, error) {
          // print("faild to load banner ad${error.message}");
          final c = Get.isRegistered<Newscontroller>()
              ? Get.find<Newscontroller>()
              : null;
          if (c != null) c.bannerisready = false;
          ad.dispose();
        }),
        request: const AdRequest())
      ..load();
  }

  static void getInterstitialad() {
    if (Platform.isAndroid) {
      InterstitialAd.load(
        adUnitId: "ca-app-pub-2675606651389917/3569998160",
        //ca-app-pub-3940256099942544/1033173712     test
        //ca-app-pub-2675606651389917/3569998160     real
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          final c = Get.isRegistered<Newscontroller>()
              ? Get.find<Newscontroller>()
              : null;
          if (c != null) {
            c.rewardad = ad;
            c.videoisadready = true;
          }
        }, onAdFailedToLoad: (LoadAdError error) {
          // print("faild to load Interstitial ad${error.message}");

          throw UnsupportedError("faild");
        }),
      );
    } else {
      throw UnsupportedError("not andriod");
    }
  }

  static Future<void> getappopenad() async {
    AppOpenAd? openad;
    if (Platform.isAndroid) {
      await AppOpenAd.load(
        adUnitId: 'ca-app-pub-2675606651389917/3656458183',

        //  ca-app-pub-3940256099942544/3419835294  test
        //  ca-app-pub-2675606651389917/3656458183  real

        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(onAdLoaded: ((ad) {
          openad = ad;
          openad!.show();
        }), onAdFailedToLoad: (LoadAdError error) {
          // print(error);
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
