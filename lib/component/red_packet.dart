import 'package:flutter/material.dart';

class RedPacketWidget extends StatelessWidget {
  final String content;

  const RedPacketWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        content,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
