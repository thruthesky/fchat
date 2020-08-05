import 'package:fchat/flutterbase_v2/flutterbase.auth.service.dart';
import 'package:fchat/flutterbase_v2/flutterbase.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

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
          GetBuilder<FlutterbaseController>(
            id: 'auth',
            builder: (_) => _.loggedIn
                ? FlatButton(
                    child: Text('Logged in as ${_.user.displayName} [Logout]'),
                    onPressed: () => FlutterbaseAuthService().logout(),
                  )
                : Text('Not logged in'),
          ),
          Row(
            children: <Widget>[
              RaisedButton(
                onPressed: () async {
                  var _auth = FlutterbaseAuthService();
                  _auth.loginWithGoogleAccount();
                  setState(() {});
                },
                child: Text('Google Login'),
              )
            ],
          )
        ],
      ),
    );
  }
}
