import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fchat/flutterbase_v2/flutterbase.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage(this.data);

  final Map<String, dynamic> data;
  final FlutterbaseController _controller = Get.find();
  @override
  Widget build(BuildContext context) {
    if (data['uid'] == _controller.user.uid) {
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
      Timestamp d = data['timestamp'];
      // print(d.seconds);

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
                          style: TextStyle(color: Colors.grey[700]),
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
                    DateTime.fromMillisecondsSinceEpoch(d.seconds * 1000)),
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
