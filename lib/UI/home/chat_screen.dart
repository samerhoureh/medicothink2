import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'chat_drawer.dart';

const Color kTeal = Color(0xFF20A9C3);

class _Message {
  final String text;
  final bool isMe;
  _Message({required this.text, required this.isMe});
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _textCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  final List<_Message> _messages = [
    _Message(text: 'Hi', isMe: true),
    _Message(text: 'Hello! How can I assist you with your medical questions today?', isMe: false),
  ];

  bool _isTyping = false;

  void _scrollToBottom() => WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent);
    }
  });

  Future<String> _getAIResponse(String message) async {
    final url = Uri.parse('YOUR_API_ENDPOINT');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_API_KEY',
        },
        body: jsonEncode({
          'messages': [
            {'role': 'user', 'content': message}
          ],
          'model': 'gpt-3.5-turbo',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return 'Sorry, I encountered an error. Please try again.';
      }
    } catch (e) {
      return 'Sorry, I encountered an error. Please try again.';
    }
  }

  void _sendMessage() async {
    final txt = _textCtrl.text.trim();
    if (txt.isEmpty) return;

    setState(() {
      _messages.add(_Message(text: txt, isMe: true));
      _isTyping = true;
    });
    _textCtrl.clear();
    _scrollToBottom();

    // Get AI response
    final aiResponse = await _getAIResponse(txt);
    
    setState(() {
      _isTyping = false;
      _messages.add(_Message(text: aiResponse, isMe: false));
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawer: const ChatDrawer(),
        onDrawerChanged: (isOpen) {
          if (!isOpen) FocusScope.of(context).unfocus();
        },
        appBar: AppBar(
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          leadingWidth: 90,
          toolbarHeight: 80,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Builder(
            builder: (context) => Padding(
              padding: const EdgeInsets.only(
                left: 30,
                top: 20,
                bottom: 20,
                right: 20,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.menu, color: kTeal),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: const Text('End conversation'),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollCtrl,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: _messages.length + (_isTyping ? 1 : 0) + 1,
                itemBuilder: (_, i) {
                  if (i == 0) return const _DateLabel(label: 'Today');

                  int index = i - 1;

                  if (index < _messages.length) {
                    final msg = _messages[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _ChatBubble(isMe: msg.isMe, text: msg.text),
                        if (msg.isMe) const _SeenLabel(),
                      ],
                    );
                  }

                  index -= _messages.length;

                  if (_isTyping && index == 0) {
                    return const _TypingLabel(name: 'AI Assistant');
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
            _MessageInput(controller: _textCtrl, onSend: _sendMessage),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final bool isMe;
  final String text;
  const _ChatBubble({required this.isMe, required this.text});

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? kTeal : const Color.fromARGB(255, 227, 242, 241);
    final align = isMe ? Alignment.centerRight : Alignment.centerLeft;
    final txtColor = isMe ? Colors.white : Colors.black87;

    return Align(
      alignment: align,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isMe ? 12 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 12),
          ),
        ),
        child: Text(text, style: TextStyle(color: txtColor)),
      ),
    );
  }
}

class _DateLabel extends StatelessWidget {
  final String label;
  const _DateLabel({required this.label});
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(label, style: const TextStyle(color: Color.fromARGB(255, 158, 158, 158))),
    ),
  );
}

class _SeenLabel extends StatelessWidget {
  const _SeenLabel();
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.only(right: 8.0, top: 2, bottom: 8),
    child: Align(
      alignment: Alignment.centerRight,
      child: Text('Seen', style: TextStyle(color: Colors.grey, fontSize: 12)),
    ),
  );
}

class _TypingLabel extends StatelessWidget {
  final String name;
  const _TypingLabel({required this.name});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '$name is typing...',
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
    ),
  );
}

class _MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  const _MessageInput({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Type something...',
                hintStyle: TextStyle(color: Color.fromARGB(255, 209, 209, 209)),
                prefixIcon: const Icon(
                  Icons.circle,
                  color: Color.fromARGB(255, 209, 209, 209),
                ),
                filled: true,
                fillColor: const Color(0xFFF0F0F0),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 50,
            height: 50,
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (_, value, __) {
                final hasText = value.text.trim().isNotEmpty;
                return SizedBox(
                  width: 50,
                  height: 50,
                  child: FloatingActionButton(
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    backgroundColor: Colors.black,
                    onPressed: hasText ? onSend : null,        
                    child: Icon(
                      hasText ? Icons.send : Icons.add,         
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}