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
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver(analytics: analytics);
  await PlaystoreUpdate.checkForUpdate();
  // Adhelper.getbanerad();

  await GetStorage.init();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    GetStorage box = GetStorage();
    bool? storedDark = box.read("darktheme");

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: storedDark == null
          ? ThemeMode.system
          : (storedDark == true ? ThemeMode.dark : ThemeMode.light),
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
