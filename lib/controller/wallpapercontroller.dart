import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutterproject2/model/ad_helper.dart';
import 'package:flutterproject2/model/wallpaper_model.dart';
import 'package:flutterproject2/view/mainpage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:html/parser.dart' as parser;
import 'package:url_launcher/url_launcher.dart';

class Newscontroller extends GetxController {
  late List<Wallpaper1> wallpaperlist;

  late InterstitialAd rewardad;
  Map bannermap = {};
  List alldata = [];
  int currentmax = 23;
  bool bol2 = false;
  bool videoisadready = false;
  bool bannerisready = false;
  int selectedindex = 0;
  late Image fullimagesize;
  bool isimageready = false;
  Random random = Random();

  ScrollController scrollController = Get.find();
  GetStorage box = GetStorage();
  @override
  void onInit() {
    // TODO: implement onInit
    Adhelper.getInterstitialad();

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
    await neWwallpaper();
    if (currentmax == alldata.length) {
      Get.snackbar("Loading ", "no more wallpaper",
          snackPosition: SnackPosition.BOTTOM);
    } else {
      currentmax = currentmax + 24;
      currentmax >= alldata.length ? currentmax = alldata.length : currentmax;

      update();
    }
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
    currentmax = 23;

    await wallpaper();

    alldata.replaceRange(0, alldata.length, wallpaperlist);
    // alldata.addAll(techradar);

    // alldata.sort((a, b) => b.time.compareTo(a.time));
    // update();
    // Get.snackbar("Loading ", "Completed", snackPosition: SnackPosition.BOTTOM);
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

          wallpaperlist.add(Wallpaper1(
              thumblink:
                  element.children[0].children[0].attributes["src"].toString(),
              fulllink: image2));
        });
      }
    } catch (exception) {
      print(exception);
    } finally {}
  }

  // Future gettechradar() async {
  //   try {
  //     techradar = [];
  //     Uri url = Uri.parse("https://www.techradar.com/gaming/news");

  //     var response = await http.get(url);

  //     if (response.statusCode == 200) {
  //       var respnsebody = response.body;
  //       var document = parser.parse(respnsebody);
  //       var news = document
  //           .getElementsByClassName("listingResults news")[0]
  //           .getElementsByClassName("listingResult small")
  //           .forEach((element) {
  //         String time = element.children[0].children[0].children[1].children[0]
  //             .children[1].children[1].attributes["datetime"]
  //             .toString();
  //         techradar.add(Techradarnews(
  //             title: element.children[0].children[0].children[1].children[0]
  //                 .children[0].text
  //                 .toString(),
  //             link: element.children[0].attributes["href"].toString(),
  //             time: DateTime.parse(time),
  //             website: 'techradar'));
  //       });
  //     }

  //   } catch (exception) {
  //     print(exception);
  //   } finally {}
  // }

}
