import 'package:cashier_flutter_demo/model/messages.dart';
import 'package:flutter/material.dart';

class SharedState with ChangeNotifier {
  List<Message> messages = [];

  SharedState() {
    // TODO: load from cache
    messages = [
      Message(
        sender: 'Alice',
        content: 'Hello',
        isRedPacket: true,
        time: DateTime.now(),
        redPacketContent: '恭喜发财',
      ),
      Message(
        sender: 'Bob',
        content: 'Hi',
        time: DateTime.now().add(Duration(minutes: 1)),
      ),
    ];
  }

  void addMessage(Message message) {
    messages.add(message);
    // TODO: save to cache
    notifyListeners();
  }
}
