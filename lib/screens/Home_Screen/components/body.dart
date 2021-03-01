import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/More/More.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Manage Tasks/Manage_Tasks.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Dashboard/dashboard.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Tasks/Tasks.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Inbox/inbox.dart';
import '../../../constants.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int pageIndex = 0;

  final Inbox _inboxPage = Inbox();
  final More _morePage = More();
  final ManageTasks _manageTasksPage = ManageTasks();
  final Dashboard _dashboard = Dashboard();
  final Tasks _tasksPage = Tasks();

  Widget _showPage = new Tasks();

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return _tasksPage;
        break;

      case 1:
        return _inboxPage;
        break;

      case 2:
        return _dashboard;
        break;

      case 3:
        return _manageTasksPage;
        break;

      case 4:
        return _morePage;
        break;

      default:
        return Container(
            child: Center(
                child: Text(
          'No Page Found',
          style: TextStyle(fontSize: 30),
        )));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        color: hexColor,
        backgroundColor: Colors.white,
        height: 60,
        index: pageIndex,
        items: <Widget>[
          Icon(
            Icons.search,
            color: kPrimaryColor,
          ),
          Icon(
            Icons.message_outlined,
            color: kPrimaryColor,
          ),
          Icon(
            Icons.post_add,
            color: kPrimaryColor,
          ),
          Icon(
            Icons.file_copy_outlined,
            color: kPrimaryColor,
          ),
          Icon(
            Icons.more_horiz_outlined,
            color: kPrimaryColor,
          ),
        ],
        animationDuration: Duration(
          milliseconds: 550,
        ),
        onTap: (int tappedindex) {
          setState(() {
            _showPage = _pageChooser(tappedindex);
          });
        },
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: _showPage,
        ),
      ),
    );
  }
}
