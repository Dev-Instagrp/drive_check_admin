import 'package:drive_check_admin/screens/welcome/welcome.dart';
import 'package:drive_check_admin/firebase_options.dart';
import 'package:drive_check_admin/screens/homescreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        fontFamily: "Poppins",
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF2cba6d))
      ),
      title: 'Drive check admin panel',
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
