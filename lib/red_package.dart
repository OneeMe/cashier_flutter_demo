// a page for send red package
import 'package:flutter/material.dart';

class RedPackage extends StatefulWidget {
  @override
  _RedPackageState createState() => _RedPackageState();
}

class _RedPackageState extends State<RedPackage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('发红包'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '发红包',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
