// a page for send red package
import 'package:flutter/material.dart';

class RedPackage extends StatefulWidget {
  @override
  _RedPackageState createState() => _RedPackageState();
}

class _RedPackageState extends State<RedPackage> {
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
        child: Container(
          height: 80,
          child: Center(
            child: label != null ? Text(label) : Text(number),
          ),
        ),
      ),
    );
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
                style: Theme.of(context).textTheme.headline3,
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
                    onTap: () {}, // Implement payment logic
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
