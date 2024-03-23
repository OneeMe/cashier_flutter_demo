import 'package:cashier_flutter_demo/model/global_state.dart';
import 'package:cashier_flutter_demo/model/messages.dart';
import 'package:cashier_flutter_demo/network/pay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BottomSheetCashier extends StatefulWidget {
  final String amount;

  const BottomSheetCashier({super.key, required this.amount});

  @override
  State<BottomSheetCashier> createState() => _BottomSheetCashierState();
}

class _BottomSheetCashierState extends State<BottomSheetCashier> {
  String amount = '';

  @override
  void initState() {
    amount = widget.amount;
    super.initState();
  }

  void _onConfirm() async {
    EasyLoading.show(status: '支付中...');
    PaymentResponse response = await pay(widget.amount);
    EasyLoading.dismiss();
    if (!mounted) {
      return;
    }
    if (response.success) {
      Fluttertoast.showToast(msg: '支付成功');
      Provider.of<SharedState>(context, listen: false).addMessage(
        RedPackageMessage(
          sender: 'Me',
          time: DateTime.now(),
          redPacketContent: '¥$amount',
        ),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      Fluttertoast.showToast(msg: '支付失败: ${response.errorMessage}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('微信红包', style: TextStyle(color: Colors.grey)),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(15),
            child: Text('￥${widget.amount}',
                style: const TextStyle(fontSize: 30, color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: _onConfirm,
            child: const Text('立即支付', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }
}
