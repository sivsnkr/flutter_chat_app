import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  // String _enteredMessage = "";
  final _controller = new TextEditingController();

  void _sendMessage() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw "bad";
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      await FirebaseFirestore.instance.collection("chat").add({
        'text': _controller.text,
        'createdAt': Timestamp.now(),
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'Name': userData['Full Name'],
        'user_image': userData['profile_picture'],
      });

      FocusScope.of(context).unfocus();
      _controller.clear();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("something went wrong!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(labelText: "Send a message..."),
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  // _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _controller.text.trim().isEmpty ? null : _sendMessage,
            icon: Icon(
              Icons.send,
            ),
          ),
        ],
      ),
    );
  }
}
