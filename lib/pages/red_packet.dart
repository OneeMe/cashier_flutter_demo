// ignore_for_file: prefer_const_constructors

import 'package:cashier_flutter_demo/logic/amount_validate.dart';
import 'package:cashier_flutter_demo/model/global_state.dart';
import 'package:cashier_flutter_demo/model/messages.dart';
import 'package:cashier_flutter_demo/network/pay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class RedPacket extends StatefulWidget {
  const RedPacket({super.key});

  @override
  _RedPacketState createState() {
    return _RedPacketState();
  }
}

class _RedPacketState extends State<RedPacket> {
  String _amount = '0';
  String _tipMessage = '';

  void _onKeyTapped(String value) {
    setState(() {
      _tipMessage = '';
      if (value == '.' && !_amount.contains('.')) {
        _amount += '.';
      } else if (value == 'delete') {
        _amount =
            _amount.length > 1 ? _amount.substring(0, _amount.length - 1) : '0';
      } else {
        if (int.tryParse(value) == null) {
          return;
        }
        if (_amount.contains('.') && _amount.split('.').last.length == 2) {
          return;
        }
        _amount = _amount == '0' ? value : _amount + value;
      }
    });
  }

  Widget _numberButton(String content, {String? label}) {
    return Expanded(
      child: InkWell(
        onTap: () => _onKeyTapped(content),
        child: SizedBox(
          height: 80,
          child: Center(
            child: label != null ? Text(label) : Text(content),
          ),
        ),
      ),
    );
  }

  void _onConfirm() async {
    String validateResult = validateAmount(_amount);
    setState(() {
      _tipMessage = validateResult;
    });
    if (validateResult.isNotEmpty) {
      return;
    }
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
        RedPackageMessage(
          sender: 'Me',
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
          // Display the tip message
          if (_tipMessage.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              alignment: Alignment.center,
              child: Text(
                _tipMessage,
                style: TextStyle(color: Colors.red),
              ),
            ),
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
          Text('99:余额不足，100:成功，101:超时，其他:失败'),
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
                    child: SizedBox(
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
