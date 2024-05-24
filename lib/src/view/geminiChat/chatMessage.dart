import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:rxdart/rxdart.dart';

class ChatMessage extends StatefulWidget {
  final String? text;
  Stream<String>? stream;
  bool? isUser;
  bool? isThinking = true;
  List<String>? fullText = [];

  ChatMessage({
    this.text,
    this.isUser,
    this.stream,
    this.isThinking,
    this.fullText,
  });

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Row(
        mainAxisAlignment:
            widget.isUser! ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: widget.isUser! ? 10.0 : 0.0),
            child: CircleAvatar(
              child: widget.isUser!
                  ? Text('Tú')
                  : Text('G'), // Avatar del usuario o Gemini
            ),
          ),
          widget.isUser!
              ? Container()
              : SizedBox(
                  width: 10,
                ),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: widget.isUser! ? Colors.blue[100] : Colors.grey[200],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                widget.text!,
                maxLines: 100,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
