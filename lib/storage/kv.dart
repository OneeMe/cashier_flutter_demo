import 'package:cashier_flutter_demo/model/messages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MessageCacheManager {
  static const _cacheKey = 'messageCache';

  Future<void> saveMessagesToCache(List<Message> messages) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedMessages =
        messages.map((message) => json.encode(message.toJson())).toList();
    await prefs.setStringList(_cacheKey, encodedMessages);
  }

  Future<List<Message>> loadMessagesFromCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedMessages = prefs.getStringList(_cacheKey);
    if (encodedMessages != null) {
      return encodedMessages
          .map((message) => Message.fromJson(json.decode(message)) as Message)
          .toList();
    } else {
      return [];
    }
  }
}
