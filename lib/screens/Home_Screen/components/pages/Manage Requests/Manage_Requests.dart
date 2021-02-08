import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/getData.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Manage%20Requests/open_offer_details.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/More/Post%20a%20Task/post_task.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/widgets/time_ago.dart';
import 'package:shop_app/models/deleteData.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Manage Requests/Active Task Details/active_task_details.dart';

class ManageTasks extends StatefulWidget {
  @override
  _ManageTasksState createState() => _ManageTasksState();
}

class _ManageTasksState extends State<ManageTasks> {
  int postedTaskLength;
  int activeTaskLength;
  GetData getData = GetData();
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
              'My Tasks',
              style: TextStyle(color: kPrimaryColor),
            ),
            backgroundColor: hexColor,
            bottom: TabBar(
                isScrollable: true,
                labelColor: kPrimaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: kPrimaryColor,
                tabs: [
                  FutureBuilder(
                    initialData: [],
                    future: getData.getPostedTask(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      postedTaskLength = snapshot.data.length;
                      return Tab(text: "Posted ($postedTaskLength)");
                    },
                  ),
                  FutureBuilder(
                    initialData: [],
                    future: getData.getActiveTask(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      activeTaskLength = snapshot.data.length;
                      return Tab(text: "Active ($activeTaskLength)");
                    },
                  ),
                  Tab(text: "Completed"),
                  Tab(text: "Canceled"),
                ]),
          ),
          body: TabBarView(
            children: [
              postedTask(),
              activeTask(),
              Center(child: Text("Completed")),
              Center(child: Text("Canceled")),
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
          return Center(child: CircularProgressIndicator());
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
                          FutureBuilder(
                            initialData: [],
                            future:
                                getData.getOffers(snapshot.data.docs[index].id),
                            builder:
                                (BuildContext context, AsyncSnapshot snap) {
                              return RaisedButton(
                                child:
                                    Text('View Offers  (${snap.data.length})'),
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
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
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
              getData.getActiveTask();
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
                                    index,
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

  completedTasks() {}
  cancelledTasks() {}

  deleteRequest(BuildContext context, String taskID) {
    // set up the button
    Widget acceptButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        deleteUserRequest(taskID).then((value) => Navigator.pop(context));
      },
    );
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      elevation: 5.0,
      backgroundColor: hexColor,
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
