import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/getData.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Manage%20Tasks/Cancelled%20Task/cancelled_task_details.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Manage%20Tasks/Completed%20Task/Completed_Task_Details.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Manage%20Tasks/open_offer_details.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/More/Post%20a%20Task/post_task.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/widgets/time_ago.dart';
import 'package:shop_app/models/deleteData.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Manage Tasks/Active Task Details/active_task_details.dart';

class ManageTasks extends StatefulWidget {
  @override
  _ManageTasksState createState() => _ManageTasksState();
}

class _ManageTasksState extends State<ManageTasks> {
  int postedTaskLength;
  int activeTaskLength;
  int completedTaskLength;
  int cancelledTaskLength;
  int init = 0;
  GetData getData = GetData();
  String email = FirebaseAuth.instance.currentUser.email;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: AppBar(
            elevation: 2,
            shadowColor: kPrimaryColor,
            automaticallyImplyLeading: false,
            centerTitle: false,
            title: Text(
              'Manage Tasks',
              style: GoogleFonts.teko(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            backgroundColor: hexColor,
            bottom: TabBar(
                isScrollable: true,
                labelColor: kPrimaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: kPrimaryColor,
                tabs: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Buyer Requests")
                        .where("Email", isEqualTo: email)
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Tab(text: "Posted (0)");
                      }
                      postedTaskLength = snapshot.data.docs.length;
                      return Tab(text: "Posted ($postedTaskLength)");
                    },
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Users")
                        .doc(email)
                        .collection("Assigned Tasks")
                        .where('TOstatus', isEqualTo: "Active")
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Tab(text: "Active (0)");
                      }
                      activeTaskLength = snapshot.data.docs.length;
                      return Tab(text: "Active ($activeTaskLength)");
                    },
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Users")
                        .doc(email)
                        .collection("Assigned Tasks")
                        .where('TOstatus', isEqualTo: "Completed")
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Tab(text: "Completed (0)");
                      }
                      completedTaskLength = snapshot.data.docs.length;
                      return Tab(text: "Completed ($completedTaskLength)");
                    },
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Users")
                        .doc(email)
                        .collection("Assigned Tasks")
                        .where('TOstatus', isEqualTo: "Cancelled")
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Tab(text: "Cancelled (0)");
                      }
                      cancelledTaskLength = snapshot.data.docs.length;
                      return Tab(text: "Cancelled ($cancelledTaskLength)");
                    },
                  ),
                ]),
          ),
          body: TabBarView(
            children: [
              postedTask(),
              activeTask(),
              completedTasks(),
              cancelledTasks(),
            ],
          )),
    );
  }

  postedTask() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Buyer Requests")
          .where("Email", isEqualTo: FirebaseAuth.instance.currentUser.email)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: SpinKitCircle(color: kPrimaryColor));
        postedTaskLength = snapshot.data.docs.length;
        if (postedTaskLength == 0)
          return SizedBox(
            child: Center(
                child: RaisedButton(
              color: kPrimaryColor,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text(
                "Post Task",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: kWhiteColor),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PostTask(),
                  ),
                );
              },
            )),
          );
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              FirebaseFirestore.instance
                  .collection("Buyer Requests")
                  .where("Email",
                      isEqualTo: FirebaseAuth.instance.currentUser.email)
                  .snapshots();
            });
          },
          child: ListView.builder(
            itemCount: postedTaskLength,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(10),
                decoration: boxDecoration,
                child: Wrap(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 17, top: 5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                TimeAgo.timeAgoSinceDate(
                                    snapshot.data.docs[index]['Time']),
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  height: 25,
                                  child: IconButton(
                                    color: Colors.grey,
                                    padding: EdgeInsets.all(0),
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      deleteRequest(context,
                                          snapshot.data.docs[index].id);
                                    },
                                  ),
                                ))
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.grey[200],
                            ),
                            padding: EdgeInsets.all(10),
                            child: Text(
                              snapshot.data.docs[index]['Description'],
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.attach_money,
                              color: greenColor,
                            ),
                            title: Text(
                              "Budget: ${snapshot.data.docs[index]['Budget']}",
                              style: TextStyle(
                                fontSize: 14,
                                color: greenColor,
                              ),
                            ),
                          ),
                          dividerPad,
                          ListTile(
                            leading: Icon(Icons.timer),
                            title: Text(
                              "Duration: ${snapshot.data.docs[index]['Duration']}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("Buyer Requests")
                                .doc(snapshot.data.docs[index].id)
                                .collection('Offers')
                                .snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot snap) {
                              return RaisedButton(
                                child: Text(snap.data == null
                                    ? 'View Offers  (0)'
                                    : 'View Offers  (${snap.data.docs.length})'),
                                textColor: Colors.white,
                                color: kPrimaryColor,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => OpenOfferDetails(
                                        index,
                                        snapshot.data.docs[index].id,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  activeTask() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser.email)
          .collection("Assigned Tasks")
          .where('TOstatus', isEqualTo: "Active")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: SpinKitCircle(color: kPrimaryColor));
        activeTaskLength = snapshot.data.docs.length;
        if (activeTaskLength == 0)
          return Center(
            child: Text(
              "No Active Tasks Yet",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor),
            ),
          );
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              FirebaseFirestore.instance
                  .collection("Users")
                  .doc(FirebaseAuth.instance.currentUser.email)
                  .collection("Assigned Tasks")
                  .where('TOstatus', isEqualTo: "Active")
                  .snapshots();
            });
          },
          child: ListView.builder(
            itemCount: activeTaskLength,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(10),
                decoration: boxDecoration,
                child: Wrap(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 17, top: 5, right: 17),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                TimeAgo.timeAgoSinceDate(
                                    snapshot.data.docs[index]['Time']),
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                snapshot.data.docs[index]['Status'],
                                style: TextStyle(color: kPrimaryColor),
                              ),
                            ),
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.grey[200],
                            ),
                            padding: EdgeInsets.all(10),
                            child: Text(
                              snapshot.data.docs[index]['Description'],
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.attach_money,
                              color: greenColor,
                            ),
                            title: Text(
                              "Budget: ${snapshot.data.docs[index]['Budget']}",
                              style: TextStyle(
                                fontSize: 14,
                                color: greenColor,
                              ),
                            ),
                          ),
                          dividerPad,
                          ListTile(
                            leading: Icon(Icons.timer),
                            title: Text(
                              "Duration: ${snapshot.data.docs[index]['Duration']}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          RaisedButton(
                            child: Text('View Details'),
                            textColor: Colors.white,
                            color: kPrimaryColor,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ActiveTaskDetails(
                                    snapshot.data.docs[index].id,
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  completedTasks() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser.email)
          .collection("Assigned Tasks")
          .where('TOstatus', isEqualTo: "Completed")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: SpinKitCircle(color: kPrimaryColor));
        completedTaskLength = snapshot.data.docs.length;
        if (completedTaskLength == 0)
          return Center(
            child: Text(
              "No Completed Tasks Yet",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor),
            ),
          );
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              FirebaseFirestore.instance
                  .collection("Users")
                  .doc(FirebaseAuth.instance.currentUser.email)
                  .collection("Assigned Tasks")
                  .where('TOstatus', isEqualTo: "Completed")
                  .snapshots();
            });
          },
          child: ListView.builder(
            itemCount: completedTaskLength,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(10),
                decoration: boxDecoration,
                child: Wrap(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 17, top: 5, right: 17),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                TimeAgo.timeAgoSinceDate(
                                    snapshot.data.docs[index]['Time']),
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                snapshot.data.docs[index]['Status'],
                                style: TextStyle(color: kPrimaryColor),
                              ),
                            ),
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.grey[200],
                            ),
                            padding: EdgeInsets.all(10),
                            child: Text(
                              snapshot.data.docs[index]['Description'],
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.attach_money,
                              color: greenColor,
                            ),
                            title: Text(
                              "Budget: ${snapshot.data.docs[index]['Budget']}",
                              style: TextStyle(
                                fontSize: 14,
                                color: greenColor,
                              ),
                            ),
                          ),
                          dividerPad,
                          ListTile(
                            leading: Icon(Icons.timer),
                            title: Text(
                              "Duration: ${snapshot.data.docs[index]['Duration']}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          RaisedButton(
                            child: Text('View Details'),
                            textColor: Colors.white,
                            color: kPrimaryColor,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CompletedTaskDetails(
                                    snapshot.data.docs[index].id,
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  cancelledTasks() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser.email)
          .collection("Assigned Tasks")
          .where('TOstatus', isEqualTo: "Cancelled")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: SpinKitCircle(color: kPrimaryColor));
        cancelledTaskLength = snapshot.data.docs.length;
        if (cancelledTaskLength == 0)
          return Center(
            child: Text(
              "No Cancelled Tasks",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor),
            ),
          );
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              FirebaseFirestore.instance
                  .collection("Users")
                  .doc(FirebaseAuth.instance.currentUser.email)
                  .collection("Assigned Tasks")
                  .where('TOstatus', isEqualTo: "Cancelled")
                  .snapshots();
            });
          },
          child: ListView.builder(
            itemCount: cancelledTaskLength,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(10),
                decoration: boxDecoration,
                child: Wrap(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 17, top: 5, right: 17),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                TimeAgo.timeAgoSinceDate(
                                    snapshot.data.docs[index]['Time']),
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                snapshot.data.docs[index]['Status'],
                                style: TextStyle(color: kPrimaryColor),
                              ),
                            ),
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.grey[200],
                            ),
                            padding: EdgeInsets.all(10),
                            child: Text(
                              snapshot.data.docs[index]['Description'],
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.attach_money,
                              color: greenColor,
                            ),
                            title: Text(
                              "Budget: ${snapshot.data.docs[index]['Budget']}",
                              style: TextStyle(
                                fontSize: 14,
                                color: greenColor,
                              ),
                            ),
                          ),
                          dividerPad,
                          ListTile(
                            leading: Icon(Icons.timer),
                            title: Text(
                              "Duration: ${snapshot.data.docs[index]['Duration']}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          RaisedButton(
                            child: Text('View Details'),
                            textColor: Colors.white,
                            color: kPrimaryColor,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CancelledTaskDetails(
                                    snapshot.data.docs[index].id,
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  deleteRequest(BuildContext context, String taskID) {
    // set up the button
    Widget acceptButton = CupertinoDialogAction(
      child: Text("Yes"),
      onPressed: () {
        deleteUserRequest(taskID).then((value) => Navigator.pop(context));
      },
    );
    Widget cancelButton = CupertinoDialogAction(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text(
        "Confirmation!",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text("Do you want to delete task?"),
      actions: [
        cancelButton,
        acceptButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }
}
