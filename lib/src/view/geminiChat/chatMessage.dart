import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatefulWidget {
  final String? text;
  Stream<String>? stream;
  bool? isUser;
  bool? isThinking = true;
  List<String>? fullText = [];

  ChatMessage({
    super.key,
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
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Row(
        mainAxisAlignment:
            widget.isUser! ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin:
                EdgeInsets.only(right: widget.isUser! ? 10.0 : 0.0, top: 5.0),
            child: CircleAvatar(
              child: widget.isUser!
                  ? const Text('Tú')
                  : const Text('F'), // Avatar del usuario o Gemini
            ),
          ),
          widget.isUser!
              ? Container()
              : const SizedBox(
                  width: 10,
                ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness.isLight
                    ? Theme.of(context).primaryColorLight
                    : Theme.of(context).primaryColorDark,
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
