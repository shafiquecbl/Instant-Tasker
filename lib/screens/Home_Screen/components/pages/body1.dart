import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'Dashboard/dashboard.dart';
import 'Inbox/inbox.dart';
import 'Manage Tasks/Manage_Tasks.dart';
import 'More/More.dart';
import 'Tasks/Tasks.dart';

class Check extends StatefulWidget {
  @override
  _CheckState createState() => _CheckState();
}

class _CheckState extends State<Check> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _screens = [
    Tasks(),
    Inbox(),
    Dashboard(),
    ManageTasks(),
    More(),
  ];

  List<PersistentBottomNavBarItem> _navBarsItems = [
    PersistentBottomNavBarItem(
      icon: Icon(Icons.search),
      title: ("Requests"),
      activeColor: kPrimaryColor,
      inactiveColor: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser.email)
            .collection('Contacts')
            .where('Status', isEqualTo: 'unread')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          int _msgCount = 0;
          if (snapshot.data == null) return Icon(Icons.message_outlined);
          _msgCount = snapshot.data.docs.length;
          if (_msgCount == 0) return Icon(Icons.message_outlined);
          return Stack(
            children: <Widget>[
              new Icon(Icons.message_outlined),
              new Positioned(
                right: 0,
                child: new Container(
                  padding: EdgeInsets.all(1),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: new Text(
                    '$_msgCount',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          );
        },
      ),
      title: ("Inbox"),
      activeColor: kPrimaryColor,
      inactiveColor: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.home),
      title: ("Home"),
      activeColor: kPrimaryColor,
      inactiveColor: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.file_copy_outlined),
      title: ("Tasks"),
      activeColor: kPrimaryColor,
      inactiveColor: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.more_vert_outlined),
      title: ("More"),
      activeColor: kPrimaryColor,
      inactiveColor: CupertinoColors.systemGrey,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _screens,
        items: _navBarsItems,
        confineInSafeArea: true,
        navBarHeight: 65,
        onWillPop: () async => false,
        backgroundColor: hexColor,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        hideNavigationBarWhenKeyboardShows: true,
        popAllScreensOnTapOfSelectedTab: false,
        decoration: NavBarDecoration(
          gradient: bPrimaryGradientColor,
          borderRadius: BorderRadius.circular(15),
          colorBehindNavBar: hexColor,
        ),
        navBarStyle: NavBarStyle.style9,
      ),
    );
  }
}
