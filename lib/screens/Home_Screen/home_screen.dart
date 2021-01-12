import 'package:flutter/material.dart';
import 'components/body.dart';

class MainScreen extends StatelessWidget {
  static String routeName = "/home_scrreen";
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Body(),
      ),
    );
  }
}
