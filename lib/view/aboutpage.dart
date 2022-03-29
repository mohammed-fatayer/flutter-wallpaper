import 'package:flutter/material.dart';
import 'package:flutterproject2/controller/wallpapercontroller.dart';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
class AboutPage extends StatelessWidget {
   AboutPage({Key? key}) : super(key: key);
   var x=34;
       
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> thekey = GlobalKey<FormState>();
    
    return Scaffold(
       appBar: AppBar(
        title: const Text("about app"),
        centerTitle: true,
      ),
      body: GetBuilder<Newscontroller>(builder:(controller)=>
           Column(
             children: [
               Container(
                   decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 78, 160, 228),
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                margin: const EdgeInsets.fromLTRB(20,30,40,40),
                 padding: const EdgeInsets.all(15),
                
                child:  const Text("gamer news is an aggregator app that provides you with the latest articles  about your favorite game-related topics.",
                  style: TextStyle( fontWeight: FontWeight.bold),),
                   ),
                  const Divider(color: Colors.black,),
                Container(
                           decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 78, 160, 228),
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                margin: const EdgeInsets.fromLTRB(20,30,40,40),
                 padding: const EdgeInsets.all(15),
                
                child:   Column(
                  children:  [
                    const Text("Links To Web Sites",
                    style: TextStyle( fontWeight: FontWeight.bold,fontSize: 20),
                    
                       ),
                       
                    const Divider(),
                    const Text("Our Service contains links to third-party websites or services that are not owned or controlled by gamer news, outside the app gamer news does not have a dedicated website or any other services.",
                    style: TextStyle( fontWeight: FontWeight.bold,fontSize: 15),
                       ),
                       const Divider(),
                    const Text("currently used news source information",
                    style: TextStyle( fontWeight: FontWeight.bold,fontSize: 15),
                       ),
                        const Divider(color:Colors.black,),
                       const Text("gamesspot"),
                       const Text("email: news@gamespot.com"),
                       InkWell(
                              child:  const Text('click for more information',style: TextStyle( fontWeight: FontWeight.bold,fontSize: 20)),
                              onTap: () => launch('https://www.gamespot.com/about/')
                                 ),
                       
                       const Divider(color:Colors.black,),
                      const Text("techradar"),
                      const Text("email: news@techradar.com"),
                       InkWell(
                              child:  const Text('click for more information',style: TextStyle( fontWeight: FontWeight.bold,fontSize: 20)),
                              onTap: () => launch('https://www.techradar.com/news/about-us')
                                 ),
                  ],
                )),
             ],
           )  ),
          );
    
  }
}
