import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject2/utils/mybindings.dart';
import 'package:flutterproject2/view/mainpage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterproject2/controller/updatecontroller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MobileAds.instance.initialize();
  await Firebase.initializeApp();
  FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver(analytics: _analytics);
  await PlaystoreUpdate.checkForUpdate();
  // Adhelper.getbanerad();

  await GetStorage.init();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GetStorage box = GetStorage();
    bool bool1 = box.read("darktheme") ?? false;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: bool1 == false ? ThemeData.dark() : ThemeData.light(),
      initialBinding: MyBinding(),
      initialRoute: "/mainpage",
      getPages: [
        GetPage(
          name: "/about",
          page: () => const Myapp(),
        ),
        GetPage(
          name: "/mainpage",
          page: () => const MainPage(),
        )
      ],
    );
  }
}
