import 'package:fchat/chat.page.dart';
import 'package:fchat/flutterbase_v2/flutterbase.auth.service.dart';
import 'package:fchat/flutterbase_v2/flutterbase.controller.dart';
import 'package:fchat/flutterbase_v2/flutterbase.notification.service.dart';
import 'package:fchat/home.page.dart';
import 'package:fchat/services/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterbaseController flutterbaseController =
      Get.put(FlutterbaseController());

  @override
  void initState() {
    super.initState();
    FlutterbaseNotificationService().init();
    flutterbaseController.setLoginForFacebook(
      appId: 619946068654098,
      redirectUrl: 'https://www.facebook.com/connect/login_success.html',
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: Routes.home,
      getPages: [
        GetPage(name: Routes.home, page: () => HomePage()),
        GetPage(name: Routes.chat, page: () => ChatPage()),
      ],
    );
  }
}
