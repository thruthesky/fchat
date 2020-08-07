import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fchat/flutterbase_v2/flutterbase.controller.dart';
import 'package:fchat/services/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserListPage> {
  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  final FlutterbaseController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff5a623)),
                ),
              );
            } else {
              print('# of user::: ');
              print(snapshot.data.documents.length);
              return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) =>
                    buildItem(context, snapshot.data.documents[index]),
                itemCount: snapshot.data.documents.length,
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    print(document['id']);
    print(document['photoUrl']);
    print(document['nickname']);

    if (document['id'] == _controller.user.uid) {
      return SizedBox.shrink();
    } else {
      return FlatButton(
        child: GFListTile(
          avatar: GFAvatar(backgroundImage: NetworkImage(document['photoUrl'])),
          titleText: document['nickname'],
          // subtitleText: 'Lorem ipsum dolor sit amet, consectetur adipiscing',
          // icon: Icon(Icons.favorite)
        ),
        onPressed: () {
          Get.toNamed(Routes.chat, arguments: {
            'peerId': document['id'],
            'peerAvatar': document['photoUrl']
          });
        },
      );
    }
  }
}
