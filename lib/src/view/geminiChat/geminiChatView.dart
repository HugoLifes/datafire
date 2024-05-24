import 'package:datafire/main.dart';
import 'package:datafire/src/view/geminiChat/chatMessage.dart';
import 'package:datafire/src/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiChatView extends StatefulWidget {
  @override
  _GeminiChatViewState createState() => _GeminiChatViewState();
}

class _GeminiChatViewState extends State<GeminiChatView> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  late GenerativeModel _model;

  @override
  void initState() {
    _model = GenerativeModel(
        model: 'gemini-1.5-pro-latest',
        apiKey: api_Key,
        systemInstruction: Content.system('Format Markdown'),
        generationConfig: GenerationConfig(maxOutputTokens: 8000));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarDatafire(
            title: "Gemini",
            description:
                "Si tienes dudas sobre tus datos, pide ayuda a un bot"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) => _messages[index],
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                    InputDecoration.collapsed(hintText: 'Enviar un mensaje'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ],
        ),
      ),
    );
  }

  _handleSubmitted(String text) async {
    _textController.clear();
    ChatMessage message = ChatMessage(
      isThinking: false,
      text: text,
      isUser: true, // Mensaje del usuario
    );
    setState(() {
      _messages.insert(0, message);
    });
    // Aquí enviarías el mensaje al modelo de lenguaje y esperarías la respuesta
    try {
      final message = Content.text(text);
      final content = [Content.text(text)];
      final chat = _model.startChat(history: [message]);
      var totalTokens = await _model.countTokens([...chat.history, message]);

      print('Tokens count ${totalTokens.totalTokens}');
      var res = chat.sendMessageStream(message);
      List<String>? multiText;
      await for (final response in res) {
        print(response.text!);

        setState(() {
          _messages.insert(0, ChatMessage(text: response.text, isUser: false));
        });
      }
    } catch (e) {
      print(e);
      return ErrorWidget('Error $e');
    }
  }
}
