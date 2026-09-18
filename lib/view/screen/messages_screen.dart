import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  final String id;
  const MessagesScreen({super.key, required this.id});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Message App")),
      body: Center(child: Text("My Messages ${widget.id}")),
    );
  }
}
