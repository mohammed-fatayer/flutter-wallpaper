import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject2/model/ad_helper.dart';
import 'package:flutterproject2/model/wallpaper_model.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../controller/wallpapercontroller.dart';
import 'package:gallery_saver/gallery_saver.dart';

ScrollController scrollController = Get.find();
Newscontroller controller = Get.find();

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  int selectedindex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Wallpapers"),
          centerTitle: true,
        ),
        bottomNavigationBar: BottomAppBar(
          child: controller.bannerisready
              ? SizedBox(height: 60,width: Get.width, child: AdWidget(ad: controller.bannerad))
              : const SizedBox(),
        ),
        drawer: Drawer(
          child: GetBuilder<Newscontroller>(
            builder: (controller) => Column(
              children: [
                const UserAccountsDrawerHeader(
                    accountName: Text(""),
                    accountEmail: Text(""),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: AssetImage("images/la.png"),
                    )),
                SwitchListTile(
                    value: controller.bol2,
                    controlAffinity: ListTileControlAffinity.trailing,
                    title: const Text("Theme"),
                    subtitle: Text(controller.bol2 == false ? "dark" : "light"),
                    secondary: const Icon(Icons.flag),
                    onChanged: (val) {
                      controller.theme(val);
                    }),
                // ListTile(
                //     title: const Text("home page"),
                //     leading: const Icon(Icons.home),
                //     onTap: () {}),
                // ListTile(
                //     title: const Text("about app"),
                //     leading: const Icon(Icons.help_center),
                //     onTap: () {
                //       Get.toNamed("/about");
                //     }),
                // ListTile(
                //     title: const Text("setting"),
                //     leading: const Icon(Icons.settings),
                //     onTap: () {}),
                // ListTile(
                //     title: const Text("logout"),
                //     leading: const Icon(Icons.logout),
                //     onTap: () {}),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (scrollController.hasClients) {
              final position = scrollController.position.minScrollExtent;
              scrollController.animateTo(position,
                  duration: const Duration(seconds: 3), curve: Curves.easeOut);
            }
          },
          child: const Icon(Icons.arrow_upward),
        ),
        body: GetBuilder<Newscontroller>(
            builder: ((controller) => controller.alldata.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      return await controller.onrefresh();
                    },
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 210,
                        mainAxisExtent: 210,
                        childAspectRatio: 1 / 2,
                        crossAxisSpacing: 20,
                      ),
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.currentmax + controller.indecator(),
                      itemBuilder: (BuildContext context, int index) {
                        // controller.ads(index);
                        if (index + 1 == controller.currentmax) {
                          return const SizedBox(
                            height: 205,
                            width: 150,
                            child: Center(
                                child: CircularProgressIndicator.adaptive(
                                    backgroundColor: Colors.white)),
                          );
                        } else {
                          return InkWell(
                            onTap: () {
                              int max = Random().nextInt(2);
                              if (controller.videoisadready && max == 1) {
                                controller.showvideo();
                                controller.fullimage(index);
                                Get.to(() => Fullimagescreen(
                                      index: index,
                                    ));
                              } else {
                                controller.fullimage(index);
                                Get.to(() => Fullimagescreen(
                                      index: index,
                                    ));
                              }
                            },
                            child: Column(
                              children: [
                                SizedBox(
                                    height: 205,
                                    width: 150,
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: Hero(
                                        tag: index,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "${controller.alldata[index].thumblink}",
                                            placeholder: (context, url) =>
                                                const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            fit: BoxFit.cover,
                                            alignment: Alignment.topCenter,
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ))));
  }
}

class Fullimagescreen extends StatelessWidget {
  final int index;

  const Fullimagescreen({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Wallpapers"),
          centerTitle: true,
        ),
        body: GetBuilder<Newscontroller>(
            builder: (controller) => Stack(
                  children: [
                   
                    
                       SizedBox(
                         height: Get.height,
                         child: ListView(
                           shrinkWrap: true,
                          
                          children: [
                            Hero(
                              tag: index,
                              child: controller.isimageready
                                  ? controller.fullimagesize
                                  : CachedNetworkImage(
                                      imageUrl:
                                          "${controller.alldata[index].thumblink}",
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
                                    ),
                            )
                          ],
                                             ),
                       ),
                 
                    Positioned(
                      bottom: 30,
                      left: 5,
                      child: FloatingActionButton.extended(
                        heroTag: "btn1",
                          onPressed: () {
                            int max = Random().nextInt(2);
                            if (controller.videoisadready && max == 1) {
                              controller.showvideo();
                            } else {
                              controller.downloadwallpaper(
                                  controller.alldata[index].fulllink,
                                  controller.alldata[index].name);
                            }
                          },
                          icon: const Icon(Icons.download),
                          label: const Text("download")),
                    ),
                    Positioned(
                      bottom: 30,
                      right: 5,
                      child: FloatingActionButton.extended(
                            heroTag: "btn2",
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) => SizedBox(
                                          height: 150,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    int max =
                                                        Random().nextInt(2);
                                                    if (controller
                                                            .videoisadready &&
                                                        max == 1) {
                                                      controller.showvideo();
                                                    } else {
                                                      controller.setscreen(
                                                          controller
                                                              .alldata[index]
                                                              .fulllink,
                                                          "home");
                                                    }
                                                  },
                                                  child: const Text(
                                                      "HomeScreen")),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    int max =
                                                        Random().nextInt(2);
                                                    if (controller
                                                            .videoisadready &&
                                                        max == 1) {
                                                      controller.showvideo();
                                                    } else {
                                                      controller.setscreen(
                                                          controller
                                                              .alldata[index]
                                                              .fulllink,
                                                          "lock");
                                                    }
                                                  },
                                                  child: const Text(
                                                      "LockScreen")),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    int max =
                                                        Random().nextInt(2);
                                                    if (controller
                                                            .videoisadready &&
                                                        max == 1) {
                                                      controller.showvideo();
                                                    } else {
                                                      controller.setscreen(
                                                          controller
                                                              .alldata[index]
                                                              .fulllink,
                                                          "both");
                                                    }
                                                  },
                                                  child: const Text(
                                                      "BothScreens"))
                                            ],
                                          ),
                                        ));
                              },
                              icon: const Icon(Icons.screen_share),
                              label: const Text("set wallpaper")),
                    )
                  ],
                )));
  }
}
