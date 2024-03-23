import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RedPacketWidget extends StatelessWidget {
  final String content;

  const RedPacketWidget({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        content,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
