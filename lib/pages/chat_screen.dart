// ignore_for_file: prefer_const_constructors

import 'package:cashier_flutter_demo/component/red_packet.dart';
import 'package:cashier_flutter_demo/model/global_state.dart';
import 'package:cashier_flutter_demo/pages/red_packet.dart';
import 'package:cashier_flutter_demo/util/date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

final List<IconModel> iconsData = [
  IconModel(Icons.access_alarm, '照片'),
  IconModel(Icons.access_time, '拍照'),
  IconModel(Icons.accessibility, '视频通话'),
  IconModel(Icons.account_balance, '位置'),
  IconModel(Icons.account_balance_wallet, '红包'),
  IconModel(Icons.account_box, '转账'),
  IconModel(Icons.account_circle, '语音输入'),
  IconModel(Icons.add, '收藏'),
];

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class IconModel {
  final IconData iconData;
  final String label;

  IconModel(this.iconData, this.label);
}

class _ChatScreenState extends State<ChatScreen> {
  bool isShowAddons = false;

  // first enter the chat screen, load messages from cache
  @override
  void initState() {
    super.initState();
    final sharedState = Provider.of<SharedState>(context, listen: false);
    EasyLoading.show(status: 'loading...');
    sharedState.initMessages().then((_) {
      EasyLoading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sharedState = Provider.of<SharedState>(context);
    final messages = sharedState.messages;

    return Scaffold(
      appBar: AppBar(
        // 在这里添加 AppBar 的内容，例如返回按钮、标题等
        title: Text('聊天'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return ListTile(
                trailing: CircleAvatar(
                  child: Text(message.sender[
                      0]), // Just an example using sender's first letter
                ),
                title: RedPacketWidget(content: message.redPacketContent),
                subtitle: Text(formatTime(message.time)),
              );
            },
          )),
          Divider(height: 1.0),
          Container(
            // 在这里构建消息输入区域
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
          if (isShowAddons)
            SizedBox(
                height: 200,
                child: GridView.count(
                  crossAxisCount: 4,
                  children: List.generate(iconsData.length, (index) {
                    // 假设iconsData是一个包含图标数据的列表
                    IconData iconData =
                        iconsData[index].iconData; // 这里应该根据实际情况选择图标
                    String label = iconsData[index].label; // 这里应该根据实际情况选择标签
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(iconData),
                            onPressed: () {
                              if (label == '红包') {
                                // present red package page
                                Navigator.push(
                                    context,
                                    CupertinoModalPopupRoute(
                                        builder: (context) => RedPacket()));
                              }
                            },
                          ),
                          Text(label),
                        ],
                      ),
                    );
                  }),
                )),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.primary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                decoration: InputDecoration.collapsed(hintText: '发送消息'),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => {},
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: _pressAddons,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pressAddons() {
    if (!isShowAddons) {
      // hide keyboard
      FocusScope.of(context).unfocus();
    }
    setState(() {
      isShowAddons = !isShowAddons;
    });
  }
}
