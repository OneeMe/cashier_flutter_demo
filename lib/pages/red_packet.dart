// ignore_for_file: prefer_const_constructors

import 'package:cashier_flutter_demo/model/global_state.dart';
import 'package:cashier_flutter_demo/model/messages.dart';
import 'package:cashier_flutter_demo/network/pay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class RedPacket extends StatefulWidget {
  @override
  _RedPacketState createState() => _RedPacketState();
}

class _RedPacketState extends State<RedPacket> {
  String _amount = '0';

  void _onKeyTapped(String value) {
    setState(() {
      if (value == 'clear') {
        _amount = '0';
      } else if (value == 'dot' && !_amount.contains('.')) {
        _amount += '.';
      } else if (value == 'delete') {
        _amount =
            _amount.length > 1 ? _amount.substring(0, _amount.length - 1) : '0';
      } else {
        _amount = _amount == '0' ? value : _amount + value;
      }
    });
  }

  Widget _numberButton(String number, {String? label}) {
    return Expanded(
      child: InkWell(
        onTap: () => _onKeyTapped(number),
        child: SizedBox(
          height: 80,
          child: Center(
            child: label != null ? Text(label) : Text(number),
          ),
        ),
      ),
    );
  }

  void _onConfirm() async {
    EasyLoading.show(status: '支付中...');
    PaymentResponse response = await pay(_amount);
    EasyLoading.dismiss();
    if (!mounted) {
      return;
    }
    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('支付成功'),
        ),
      );
      Provider.of<SharedState>(context, listen: false).addMessage(
        Message(
          sender: 'Me',
          content: '发了一个红包',
          isRedPacket: true,
          time: DateTime.now(),
          redPacketContent: '¥$_amount',
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('支付失败: ${response.errorMessage}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('支付页面'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Display the amount
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              alignment: Alignment.centerRight,
              child: Text(
                '¥$_amount',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
          ),
          // Numeric keypad
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children:
                      ['1', '2', '3'].map((e) => _numberButton(e)).toList(),
                ),
                Row(
                  children:
                      ['4', '5', '6'].map((e) => _numberButton(e)).toList(),
                ),
                Row(
                  children:
                      ['7', '8', '9'].map((e) => _numberButton(e)).toList(),
                ),
                Row(
                  children: [
                    _numberButton('.', label: '.'),
                    _numberButton('0'),
                    _numberButton('delete', label: '删除'),
                  ],
                ),
              ],
            ),
          ),
          // Bottom bar with a button
          Container(
            color: Colors.red,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _onConfirm,
                    child: Container(
                      height: 60,
                      child: Center(
                        child: Text(
                          '确认',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
