class RedPackageMessage {
  final String sender;
  final DateTime time;
  final String redPacketContent; // Additional content for red packets

  RedPackageMessage({
    required this.sender,
    required this.time,
    required this.redPacketContent,
  });

  Object? toJson() {
    return {
      'sender': sender,
      'time': time.toIso8601String(),
      'redPacketContent': redPacketContent
    };
  }

  static fromJson(decode) {
    return RedPackageMessage(
      sender: decode['sender'],
      time: DateTime.parse(decode['time']),
      redPacketContent: decode['redPacketContent'],
    );
  }
}
