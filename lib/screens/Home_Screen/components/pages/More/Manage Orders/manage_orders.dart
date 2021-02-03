import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/getData.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/More/Manage%20Orders/open_order_details.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/widgets/time_ago.dart';
import 'dart:async';

class ManageOrders extends StatefulWidget {
  @override
  _ManageOrdersState createState() => _ManageOrdersState();
}

class _ManageOrdersState extends State<ManageOrders> {
  int activeOrdersLength;
  GetData getData = GetData();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          shadowColor: kPrimaryColor,
          automaticallyImplyLeading: false,
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
                FutureBuilder(
                  initialData: [],
                  future: getData.getActiveOrders(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    activeOrdersLength = snapshot.data.length;
                    return Tab(text: "Active ($activeOrdersLength)");
                  },
                ),
                Tab(text: "Completed"),
                Tab(text: "Cancelled"),
              ]),
        ),
        body: FutureBuilder(
          initialData: [],
          future: Future.wait([
            getData.getActiveOrders(),
          ]),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return SpinKitDoubleBounce(color: kPrimaryColor);
            activeOrdersLength = snapshot.data[0].length;
            return TabBarView(
              children: [
                activeOrders(snapshot.data[0]),
                Center(child: Text("Completed")),
                Center(child: Text("Cancelled")),
              ],
            );
          },
        ),
      ),
    );
  }

  updateScreen() {
    setState(() {
      getData.getPostedTask();
    });
  }

  activeOrders(List<QueryDocumentSnapshot> snapshot) {
    if (activeOrdersLength == 0)
      return SizedBox(
        child: Center(
          child: Text(
            "No Orders Yet",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: kPrimaryColor),
          ),
        ),
      );
    if (snapshot.isNotEmpty)
      return RefreshIndicator(
        onRefresh: () async {
          setState(() {
            getData.getActiveOrders();
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
                              TimeAgo.timeAgoSinceDate(snapshot[index]['Time']),
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              snapshot[index]['Status'],
                              style: TextStyle(color: kPrimaryColor),
                            ),
                          ),
                        ]),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.grey[200],
                          ),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            snapshot[index]['Description'],
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.attach_money,
                            color: greenColor,
                          ),
                          title: Text(
                            "Budget: ${snapshot[index]['Budget']}",
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
                            "Duration: ${snapshot[index]['Duration']}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        FutureBuilder(
                          initialData: [],
                          future: getData.getOrders(snapshot[index].id),
                          builder: (BuildContext context, AsyncSnapshot snap) {
                            return RaisedButton(
                              child: Text('View Details'),
                              textColor: Colors.white,
                              color: kPrimaryColor,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => OpenOrderDetails(
                                      snapshot[index].id,
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
  }

  completedTask() {}
}
