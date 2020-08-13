import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fchat/chat/chat.input_box.dart';
import 'package:fchat/chat/chat.message.dart';
import 'package:fchat/flutterbase_v2/flutterbase.controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  CollectionReference colRoom = Firestore.instance.collection('chatRoom');

  final FlutterbaseController _controller = Get.find();
  String uid;

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  Map<String, dynamic> args = Get.arguments;

  var messages = [];

  @override
  void initState() {
    super.initState();
    uid = _controller.user.uid;
    setState(() {});

    initFirebase();
  }

  initFirebase() async {
    QuerySnapshot qs = await colRoom
        .orderBy('timestamp', descending: true)
        .limit(30)
        .getDocuments();

    final docs = qs.documents;

    if (docs.length > 0) {
      docs.forEach(
        (doc) {
          var data = doc.data;
          data['id'] = doc.documentID;
          messages.add(data);
        },
      );
      setState(() {});
    }

    colRoom.orderBy('timestamp', descending: true).limit(1).snapshots().listen(
          (data) => data.documents.forEach(
            (doc) {
              var data = doc.data;
              data['id'] = doc.documentID;

              /// Don't add the last message twice.
              /// This is for
              ///   - when the chat messages are loaded for the first time
              ///   - and when user types a new message.
              if (data['id'] != messages[0]['id']) {
                messages.insert(0, data);
              }
              // messages.add(doc.data);
              setState(() {});
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Chat Room',
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) => ChatMessage(messages[index]),
                itemCount: messages.length,
                reverse: true,
                controller: listScrollController,
              ),
            ),
            ChatInputBox(
              controller: textEditingController,
              onPressed: onSendMessage,
            )
          ],
        ),
      ),
    );
  }

  void onSendMessage() {
    String content = textEditingController.text;
    if (content.trim() != '') {
      textEditingController.clear();
      var data = {
        'uid': uid,
        'displayName': _controller.user.displayName,
        'photoUrl': _controller.user.photoUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'content': content,
      };
      // print('add: $data');
      colRoom.add(data);
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Get.snackbar('Nothing to send', '');
    }
  }
}
