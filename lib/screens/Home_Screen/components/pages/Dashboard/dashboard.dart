import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        shadowColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Text(
            'Dashboard',
            style: TextStyle(
              color: kPrimaryColor
            ),
          ),
        ),
        backgroundColor: hexColor
      ),
      body: Container()
    );
  }
}