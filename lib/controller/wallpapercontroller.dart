import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:flutterproject2/model/ad_helper.dart';
import 'package:flutterproject2/model/wallpaper_model.dart';
import 'package:flutterproject2/view/mainpage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:html/parser.dart' as parser;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:convert' as io;

class Newscontroller extends GetxController {
  late List<Wallpaper1> wallpaperlist;

  late InterstitialAd rewardad;
  late BannerAd bannerad;
  List alldata = [];
  int currentmax = 23;
  bool bol2 = false;
  bool videoisadready = false;
  bool bannerisready = false;
  int selectedindex = 0;
  late Image fullimagesize;
  bool isimageready = false;
  Random random = Random();
  final _key = GlobalKey();

  ScrollController scrollController = Get.find();
  GetStorage box = GetStorage();
  @override
  void onInit() async {
    // TODO: implement onInit
    Adhelper.getInterstitialad();
    bannerad = Adhelper.getbanerad();
    neWwallpaper();

    if (box.read("darktheme") != null) {
      bol2 = box.read("darktheme");
    }
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        newdata();
      }
    });
    super.onInit();
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  // void ads(index) {
  //   if (index % 6 == 0 && !bannermap.containsKey(index)) {
  //     bannermap[index] = Adhelper.getbanerad();
  //   } else if (bannermap.containsKey(index) && index % 6 == 0) {
  //     bannermap[index];
  //   }
  // }

  void navigationbar(index) {
    selectedindex = index;
  }

  int indecator() {
    return currentmax == alldata.length ? 0 : 1;
  }

  void fullimage(index) {
    Image fullimage = Image.network(
      "${controller.alldata[index].fulllink}",
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      fit: BoxFit.cover,
    );
    fullimagesize = fullimage;
    Future.delayed(const Duration(milliseconds: 500), () {
      isimageready = true;

      update();
    });
    isimageready = false;
  }

  void theme(val) {
    bol2 = val;
    box.write("darktheme", bol2);
    bol2 == false
        ? Get.changeTheme(ThemeData.dark())
        : Get.changeTheme(ThemeData.light());

    update();
  }

  void newdata() async {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await neWwallpaper();
      if (currentmax == alldata.length) {
        Get.snackbar("Loading ", "no more wallpaper",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        currentmax = currentmax + wallpaperlist.length;
        currentmax >= alldata.length ? currentmax = alldata.length : currentmax;

        update();
      }
    });
  }

  void openurl(index) async {
    var url1 = alldata[index].fulllink;
    if (await canLaunch(url1.toString())) {
      await launch(url1.toString(), forceWebView: true);
    } else {
      throw 'Could not launch $url1';
    }
  }

  Future neWwallpaper() async {
    await wallpaper();

    alldata.addAll(wallpaperlist);
    // alldata.addAll(techradar);

    // alldata.sort((a, b) => b.time.compareTo(a.time));
    update();
  }

  Future onrefresh() async {
    await wallpaper();

    alldata.replaceRange(0, alldata.length, wallpaperlist);
    currentmax = alldata.length;

    update();
  }

  Future wallpaper() async {
    wallpaperlist = [];
    int pagenumber = random.nextInt(3500);

    try {
      Uri url = Uri.parse(
          "https://mobile.alphacoders.com/by-category/3?page=$pagenumber");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var respnsebody = response.body;
        var document = parser.parse(respnsebody);
        var news = document
            .getElementsByClassName("container-masonry")[0]
            .getElementsByClassName("item")
            .forEach((element) {
          String image =
              element.children[0].children[0].attributes["src"].toString();
          String image2 = image.replaceAll("thumb-", "");
          String imagesize =
              element.children[0].children[0].attributes["style"].toString();
          imagesize = imagesize.replaceAll("height:", "");
          imagesize = imagesize.replaceAll("px;", "");
          int height = int.parse(imagesize);

          wallpaperlist.add(Wallpaper1(
              thumblink:
                  element.children[0].children[0].attributes["src"].toString(),
              fulllink: image2));

          if (height < 300) {
            wallpaperlist.removeLast();
            print(height);
          }
        });
        if (wallpaperlist.length <= 15) {
          await neWwallpaper();
          
        
        }
      }
      print(wallpaperlist.length);
    } catch (exception) {
      print(exception);
    } finally {}
  }

  Future setscreen(String url, String location) async {
    var filepath = await cachwallpaper(url);
    await bothscreenmethod(filepath.path, location);
    Get.snackbar("set ${location}screen", "done",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(milliseconds: 800));
  }

  Future bothscreenmethod(String path, String location) async {
    try {
      if (location == "home") {
        int locationpath = WallpaperManager.HOME_SCREEN;
        await WallpaperManager.setWallpaperFromFile(path, locationpath);
      }
      if (location == "lock") {
        int locationpath = WallpaperManager.LOCK_SCREEN;
        await WallpaperManager.setWallpaperFromFile(path, locationpath);
      }
      if (location == "both") {
        int locationpath = WallpaperManager.BOTH_SCREEN;
        await WallpaperManager.setWallpaperFromFile(path, locationpath);
      }
    } catch (e) {
      Get.snackbar("set ${location}screen", "Faild",
          snackPosition: SnackPosition.BOTTOM);
    } finally {}
  }

  Future cachwallpaper(String url) async {
    try {
      return await DefaultCacheManager().getSingleFile(url);
    } catch (e) {
      print("faild");
    } finally {}
  }

  Future downloadwallpaper(String url) async {
    try {
      await GallerySaver.saveImage(url, albumName: "Wallpapers");
      Get.snackbar("Download", "Done",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(milliseconds: 800));
    } catch (e) {
      Get.snackbar("Download", "Faild", snackPosition: SnackPosition.BOTTOM);
    } finally {}
  }
}
