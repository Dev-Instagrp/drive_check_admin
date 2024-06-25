import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WidgetUtils{

  static List<Widget> footerItems = [
    InkWell(
      borderRadius: BorderRadius.circular(30),
      radius: 10,
      onTap: (){
      },
      child: Image.asset("assets/images/whatsapp.png", fit: BoxFit.scaleDown, height: 35, width: 35,),
    ),
    InkWell(
      borderRadius: BorderRadius.circular(30),
      radius: 10,
      onTap: (){
        openURL("it.team.instaict@gmail.com");
      },
      child: Image.asset("assets/images/gmail.png", fit: BoxFit.scaleDown, height: 35, width: 35,),
    ),
    InkWell(
      borderRadius: BorderRadius.circular(30),
      radius: 10,
      onTap: (){
        openURL("https://www.instagram.com/devs._.insta/");
      },
      child: Image.asset("assets/images/instagram.png", fit: BoxFit.scaleDown, height: 35, width: 35,),
    ),
  ];

  static void openURL(String url) => launchUrl(
    Uri.parse(url),
  );

}