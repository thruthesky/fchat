import 'package:fchat/flutterbase_v2/flutterbase.auth.service.dart';
import 'package:fchat/flutterbase_v2/flutterbase.controller.dart';
import 'package:fchat/flutterbase_v2/widgets/login/login.form.dart';
import 'package:fchat/services/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                LoginForm(),
                RaisedButton(
                  onPressed: () {
                    Get.toNamed(Routes.chat);
                  },
                  child: Text('Chatting'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
