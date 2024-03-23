import 'package:cashier_flutter_demo/model/messages.dart';
import 'package:cashier_flutter_demo/storage/kv.dart';
import 'package:flutter/material.dart';

class SharedState with ChangeNotifier {
  List<RedPackageMessage> messages = [];

  Future<void> initMessages() async {
    List<RedPackageMessage> cachedMessages =
        await MessageCacheManager().loadMessagesFromCache();
    messages = cachedMessages;
    notifyListeners();
  }

  void addMessage(RedPackageMessage message) {
    messages.add(message);
    MessageCacheManager().saveMessagesToCache(messages);
    notifyListeners();
  }
}
