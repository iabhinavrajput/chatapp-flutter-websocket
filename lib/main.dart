import 'package:flutter/material.dart';
import 'chat_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: UserSelectionScreen(),
  ));
}

class UserSelectionScreen extends StatelessWidget {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController receiverIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter User Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: userIdController,
              decoration: InputDecoration(labelText: "Your User ID"),
            ),
            TextField(
              controller: receiverIdController,
              decoration: InputDecoration(labelText: "Receiver's User ID"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Start Chat"),
              onPressed: () {
                if (userIdController.text.isNotEmpty && receiverIdController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        userId: userIdController.text,
                        receiverId: receiverIdController.text,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
