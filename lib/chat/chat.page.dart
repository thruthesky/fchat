import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fchat/chat/chat.input_box.dart';
import 'package:fchat/flutterbase_v2/flutterbase.controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // String groupChatId = 'mainChatRoom';

  CollectionReference colRoom = Firestore.instance.collection('chatRoom');

  ///
  var listMessage;
  final FlutterbaseController _controller = Get.find();
  String uid;

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  /// TODO: What is the focus node?
  // final FocusNode focusNode = new FocusNode();

  Map<String, dynamic> args = Get.arguments;

  @override
  void initState() {
    super.initState();
    uid = _controller.user.uid;
    setState(() {});
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
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Column(
              children: <Widget>[
                // List of messages
                buildListMessage(),
                ChatInputBox(
                  controller: textEditingController,
                  onPressed: onSendMessage,
                )
              ],
            ),
          ),

          // Loading
          // buildLoading()
        ],
      ),
    );
  }

  void onSendMessage() {
    String content = textEditingController.text;
    if (content.trim() != '') {
      textEditingController.clear();

      // var documentReference = Firestore.instance
      //     .collection('chatRoom')
      //     .document(DateTime.now().millisecondsSinceEpoch.toString());

      // Firestore.instance.runTransaction(
      //   (transaction) async {
      //     await transaction.set(
      //       documentReference,
      //       {
      //         'uid': uid,
      //         'displayName': _controller.user.displayName,
      //         'photoUrl': _controller.user.photoUrl,
      //         'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      //         'content': content,
      //         // 'type': type
      //       },
      //     );
      //   },
      // );

      var data = {
        'uid': uid,
        'displayName': _controller.user.displayName,
        'photoUrl': _controller.user.photoUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'content': content,
      };
      colRoom.add(data);
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Get.snackbar('Nothing to send', '');
    }
  }

  Widget buildListMessage() {
    return Flexible(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('chatRoom')
            .orderBy('timestamp', descending: true)
            .limit(30)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center();
          } else {
            listMessage = snapshot.data.documents;
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  buildItem(index, snapshot.data.documents[index].data),
              itemCount: snapshot.data.documents.length,
              reverse: true,
              controller: listScrollController,
            );
          }
        },
      ),
    );
  }

  Widget buildItem(int index, data) {
    if (data['uid'] == uid) {
      // Right (my message)
      return Row(
        children: <Widget>[
          Container(
            child: Text(
              data['content'],
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Material(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                      ),
                      width: 35.0,
                      height: 35.0,
                      padding: EdgeInsets.all(10.0),
                    ),
                    imageUrl: data['photoUrl'],
                    width: 35.0,
                    height: 35.0,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(18.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                          data['displayName'] ?? '',
                          style: TextStyle(color: Colors.black87),
                        ),
                        padding: EdgeInsets.fromLTRB(5.0, 5.0, 15.0, 5.0),
                        width: 200.0,
                      ),
                      Container(
                        child: Text(
                          data['content'],
                          style: TextStyle(color: Colors.grey),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
                        width: 200.0,
                        decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                ),
              ],
            ),
            Container(
              child: Text(
                DateFormat('dd MMM kk:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        int.parse(data['timestamp']))),
                style: TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic),
              ),
              margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }
}
