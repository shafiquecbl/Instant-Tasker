import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/getData.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/More/Manage%20Orders/open_order_details.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/widgets/time_ago.dart';

class ManageOrders extends StatefulWidget {
  @override
  _ManageOrdersState createState() => _ManageOrdersState();
}

class _ManageOrdersState extends State<ManageOrders> {
  int activeOrdersLength;
  int completedOrdersLength;
  GetData getData = GetData();
  String email = FirebaseAuth.instance.currentUser.email;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          shadowColor: kPrimaryColor,
          centerTitle: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text(
              'Manage Orders',
              style: TextStyle(color: kPrimaryColor),
            ),
          ),
          backgroundColor: hexColor,
          bottom: TabBar(
              labelColor: kPrimaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: kPrimaryColor,
              tabs: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .doc(email)
                      .collection("Orders")
                      .where(
                        'TOstatus',
                        isEqualTo: "Active",
                      )
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Tab(text: "Active (0)");
                    }
                    activeOrdersLength = snapshot.data.docs.length;
                    return Tab(text: "Active ($activeOrdersLength)");
                  },
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .doc(FirebaseAuth.instance.currentUser.email)
                      .collection("Orders")
                      .where(
                        'TOstatus',
                        isEqualTo: "Completed",
                      )
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Tab(text: "Completed (0)");
                    }
                    completedOrdersLength = snapshot.data.docs.length;
                    return Tab(text: "Completed ($completedOrdersLength)");
                  },
                ),
                Tab(text: "Cancelled"),
              ]),
        ),
        body: TabBarView(
          children: [
            activeOrders(),
            completedOrders(),
            Center(child: Text("Cancelled")),
          ],
        ),
      ),
    );
  }

  activeOrders() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .doc(email)
          .collection("Orders")
          .where(
            'TOstatus',
            isEqualTo: "Active",
          )
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        activeOrdersLength = snapshot.data.docs.length;
        if (activeOrdersLength == 0)
          return SizedBox(
            child: Center(
              child: Text(
                "No Orders Yet",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: kPrimaryColor),
              ),
            ),
          );
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              FirebaseFirestore.instance
                  .collection("Users")
                  .doc(email)
                  .collection("Orders")
                  .where(
                    'TOstatus',
                    isEqualTo: "Active",
                  )
                  .snapshots();
            });
          },
          child: ListView.builder(
            itemCount: activeOrdersLength,
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
                          Padding(
                            padding: const EdgeInsets.only(left: 70),
                            child: Divider(
                              height: 1,
                              color: Colors.grey,
                            ),
                          ),
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
                                getData.getOrders(snapshot.data.docs[index].id),
                            builder:
                                (BuildContext context, AsyncSnapshot snap) {
                              return RaisedButton(
                                child: Text('View Details'),
                                textColor: Colors.white,
                                color: kPrimaryColor,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => OpenOrderDetails(
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

  completedOrders() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser.email)
          .collection("Orders")
          .where(
            'TOstatus',
            isEqualTo: "Completed",
          )
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        completedOrdersLength = snapshot.data.docs.length;
        if (completedOrdersLength == 0)
          return SizedBox(
            child: Center(
              child: Text(
                "No Completed Tasks Yet",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: kPrimaryColor),
              ),
            ),
          );
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              FirebaseFirestore.instance
                  .collection("Users")
                  .doc(FirebaseAuth.instance.currentUser.email)
                  .collection("Orders")
                  .where(
                    'TOstatus',
                    isEqualTo: "Completed",
                  )
                  .snapshots();
            });
          },
          child: ListView.builder(
            itemCount: completedOrdersLength,
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
                          Padding(
                            padding: const EdgeInsets.only(left: 70),
                            child: Divider(
                              height: 1,
                              color: Colors.grey,
                            ),
                          ),
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
                                getData.getOrders(snapshot.data.docs[index].id),
                            builder:
                                (BuildContext context, AsyncSnapshot snap) {
                              return RaisedButton(
                                child: Text('View Details'),
                                textColor: Colors.white,
                                color: kPrimaryColor,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => OpenOrderDetails(
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
}
