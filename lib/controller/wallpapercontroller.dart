import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutterproject2/model/ad_helper.dart';
import 'package:flutterproject2/model/wallpaper_model.dart';
import 'package:flutterproject2/view/mainpage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'dart:convert' as io;
import 'package:dio/dio.dart';

class Newscontroller extends GetxController {
  late List<Wallpaper1> wallpaperlist;

  late InterstitialAd rewardad;
  late BannerAd bannerad;
  List alldata = [];
  late int currentmax = alldata.length;
  bool bol2 = false;
  bool videoisadready = false;
  bool bannerisready = true;
  int selectedindex = 0;
  late Image fullimagesize;
  bool isimageready = false;
  Random random = Random();
  bool isLoadMoreRunning = false;
  int aviable = 1;
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
    scrollController.addListener(() async {
      if (scrollController.position.pixels >
          scrollController.position.maxScrollExtent * 0.30) {
        WidgetsBinding.instance?.addPostFrameCallback((_) async {
          await newdata();
        });
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
            heightFactor: 15,
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

  Future newdata() async {
    if (aviable == 1) {
      aviable = 0;
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        await neWwallpaper();

        if (currentmax == alldata.length) {
          Get.snackbar("Loading ", "no more wallpaper",
              snackPosition: SnackPosition.BOTTOM);
        } else {
          currentmax = currentmax + wallpaperlist.length;
          currentmax >= alldata.length
              ? currentmax = alldata.length
              : currentmax;

          update();
          aviable = 1;
        }
      });
    }
  }

  Future neWwallpaper() async {
    await _wallpaper();

    alldata.addAll(wallpaperlist);
    isLoadMoreRunning = false;
    update();
  }

  Future onrefresh() async {
    await _wallpaper();

    alldata.replaceRange(0, alldata.length, wallpaperlist);
    currentmax = alldata.length;

    update();
  }

  Future _wallpaper() async {
    wallpaperlist = [];
    late int _maximages;
    CollectionReference _note =
        FirebaseFirestore.instance.collection('maximages');
    await _note
        .doc("FexINAwsq1wXNprktbCI")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      _maximages = documentSnapshot["maximages"];
    });

    final storageRef = FirebaseStorage.instance.ref();
    isLoadMoreRunning = true;

// Create a reference with an initial file path and name
    for (var i = 0; i < 24; i++) {
      try {
        int num = random.nextInt(_maximages);
        final pathReference = storageRef.child("thumbnails/$num.jpg");
        final url = await pathReference.getDownloadURL();

        String fullurl = url.toString();
        fullurl = fullurl.replaceAll("thumbnails", "wallpapers");

        wallpaperlist.add(Wallpaper1(
            thumblink: url, fulllink: fullurl, name: pathReference.name));
      } catch (e) {
        print("not found ============================================");
      } finally {}
    }
  }

  Future showvideo() async {
    rewardad.show();
    rewardad.fullScreenContentCallback =
        FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) async {
      rewardad.dispose();
      videoisadready = false;
      Adhelper.getInterstitialad();
      Future.delayed(const Duration(seconds: 1));
    });
  }

  Future setscreen(String url, String location) async {
    var filepath = await cachwallpaper(url);
    await bothscreenmethod(filepath.path, location);
    Get.snackbar("set ${location}", "Done",
        maxWidth: double.infinity,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(milliseconds: 600));
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
      Get.snackbar("set ${location}", "Faild",
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

  Future downloadwallpaper(String url, String name) async {
    try {
      final temp = await getTemporaryDirectory();
      final path = "${temp.path}/$name";
      await Dio().download(url, path);
      await GallerySaver.saveImage(path, albumName: "Wallpapers");
      Get.snackbar("Download", "Done",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(milliseconds: 800));
    } catch (e) {
      Get.snackbar("Download", "Faild", snackPosition: SnackPosition.BOTTOM);
    } finally {}
  }
}
