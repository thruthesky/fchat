import 'package:flutter/material.dart';

class ChatInputBox extends StatefulWidget {
  ChatInputBox({
    @required this.controller,
    @required this.onPressed,
  });

  final TextEditingController controller;
  final Function onPressed;

  @override
  _ChatInputBoxState createState() => _ChatInputBoxState();
}

class _ChatInputBoxState extends State<ChatInputBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 8.0)),
          // Edit text
          Flexible(
            child: TextField(
              style: TextStyle(fontSize: 16.0),
              controller: widget.controller,
              decoration: InputDecoration.collapsed(
                hintText: 'Type your message...',
              ),
              // focusNode: focusNode,
            ),
          ),

          // Button send message
          IconButton(
              padding: EdgeInsets.all(12.0),
              icon: Icon(Icons.send),
              onPressed: widget
                  .onPressed // () => onSendMessage(textEditingController.text, 0),
              ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
        border: new Border(top: new BorderSide(width: 0.5)),
        color: Colors.white,
      ),
    );
  }
}
