import 'package:flutter/material.dart';
import 'package:shop_app/widgets/customAppBar.dart';


class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Dashboard"),
      body: Container()
    );
  }
}