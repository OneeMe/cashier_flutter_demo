class Message {
  final String sender;
  final String content;
  final DateTime time;
  final bool isRedPacket; // To determine if the message is a red packet or not
  final String? redPacketContent; // Additional content for red packets
  final String? redPacketAmount; // Additional content for red packets

  Message({
    required this.sender,
    required this.content,
    required this.time,
    this.isRedPacket = false,
    this.redPacketContent,
    this.redPacketAmount,
  });

  Object? toJson() {
    return {
      'sender': sender,
      'content': content,
      'time': time.toIso8601String(),
      'isRedPacket': isRedPacket,
      'redPacketContent': redPacketContent,
      'redPacketAmount': redPacketAmount
    };
  }

  static fromJson(decode) {
    return Message(
      sender: decode['sender'],
      content: decode['content'],
      time: DateTime.parse(decode['time']),
      isRedPacket: decode['isRedPacket'],
      redPacketContent: decode['redPacketContent'],
      redPacketAmount: decode['redPacketAmount'],
    );
  }
}
