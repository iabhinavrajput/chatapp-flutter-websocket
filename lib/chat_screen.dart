import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String receiverId;

  ChatScreen({required this.userId, required this.receiverId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late WebSocketChannel channel;
  List<Map<String, String>> messages = [];

  @override
  void initState() {
    super.initState();
    // channel = IOWebSocketChannel.connect('ws://lcalmachine ip:8080'); // here will come the IP of your server or your lcalmachine ip with port 8080


    // Register user on connection
    channel.sink.add(jsonEncode({
      "type": "register",
      "userId": widget.userId,
    }));

    // Listen for incoming messages
    channel.stream.listen((message) {
      final data = json.decode(message);
      setState(() {
        messages.add({
          "sender": data['sender'],
          "text": data['text'],
        });
      });
    });
  }

  void sendMessage() {
    if (_controller.text.isNotEmpty) {
      final msg = jsonEncode({
        "type": "message",
        "sender": widget.userId,
        "receiver": widget.receiverId,
        "text": _controller.text,
      });

      channel.sink.add(msg);
      setState(() {
        messages.add({"sender": widget.userId, "text": _controller.text});
      });
      _controller.clear();
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.receiverId}"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isMe = messages[index]['sender'] == widget.userId;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      messages[index]['text']!,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: sendMessage,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}