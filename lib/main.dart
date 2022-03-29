import 'package:flutter/material.dart';
import 'package:flutterproject2/controller/wallpapercontroller.dart';
import 'package:flutterproject2/utils/mybindings.dart';
import 'package:flutterproject2/view/mainpage.dart';
import 'package:flutterproject2/view/aboutpage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutterproject2/model/ad_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  Adhelper.getbanerad();
  await GetStorage.init();
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
      initialBinding: MyBinding(),
      home: MainPage(),
      theme: bool1 == false ? ThemeData.dark() : ThemeData.light(),
      getPages: [
        GetPage(
          name: "/about",
          page: () => AboutPage(),
        )
      ],
    );
  }
}
