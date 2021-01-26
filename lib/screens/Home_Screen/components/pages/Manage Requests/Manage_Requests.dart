import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/getData.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Manage%20Requests/open_offer_details.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/More/Post%20a%20Task/post_task.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/widgets/time_ago.dart';
import 'package:shop_app/models/deleteData.dart';
import 'dart:async';
import 'package:shop_app/screens/Home_Screen/components/pages/Manage Requests/Active Task Details/active_task_details.dart';

class ManageRequests extends StatefulWidget {
  @override
  _ManageRequestsState createState() => _ManageRequestsState();
}

class _ManageRequestsState extends State<ManageRequests> {
  int postedTaskLength;
  int activeTaskLength;
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
              'My Tasks',
              style: TextStyle(color: kPrimaryColor),
            ),
          ),
          backgroundColor: hexColor,
          bottom: TabBar(
            labelColor: kPrimaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: kPrimaryColor,
            tabs: [
              Tab(text: "Posted"),
              Tab(text: "Active"),
              Tab(text: "Completed")
            ],
          ),
        ),
        body: FutureBuilder(
          initialData: [],
          future: Future.wait([
            getData.getPostedTask(),
            getData.getActiveTask(),
          ]),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return SpinKitDoubleBounce(color: kPrimaryColor);
            postedTaskLength = snapshot.data[0].length;
            activeTaskLength = snapshot.data[1].length;
            return TabBarView(
              children: [
                postedTask(snapshot),
                activeTask(snapshot),
                Center(child: Text("Completed")),
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

  postedTask(AsyncSnapshot<dynamic> snapshot) {
    if (postedTaskLength == 0)
      return SizedBox(
        child: Center(
            child: RaisedButton(
          color: kPrimaryColor,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Text(
            "Post Task",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, color: kWhiteColor),
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
    if (snapshot.hasData)
      return RefreshIndicator(
        onRefresh: () async {
          setState(() {
            getData.getPostedTask();
          });
        },
        child: ListView.builder(
          itemCount: postedTaskLength,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: Colors.grey[300]),
              ),
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
                                  snapshot.data[0][index]['Time']),
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
                                    deleteUserRequest(
                                            snapshot.data[0][index].id)
                                        .then((value) => updateScreen());
                                  },
                                ),
                              ))
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
                            snapshot.data[0][index]['Description'],
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.attach_money,
                            color: Colors.green,
                          ),
                          title: Text(
                            "Budget: ${snapshot.data[0][index]['Budget']}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green,
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
                            "Duration: ${snapshot.data[0][index]['Duration']}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        FutureBuilder(
                          initialData: [],
                          future: getData.getOffers(snapshot.data[0][index].id),
                          builder: (BuildContext context, AsyncSnapshot snap) {
                            return RaisedButton(
                              child: Text('View Offers  (${snap.data.length})'),
                              textColor: Colors.white,
                              color: kPrimaryColor,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => OpenOfferDetails(
                                      index,
                                      snapshot.data[0][index].id,
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

  activeTask(AsyncSnapshot<dynamic> snapshot) {
    if (postedTaskLength == 0)
      return Center(
        child: Text(
          "No Active Tasks yet",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 17, color: kWhiteColor),
        ),
      );
    if (snapshot.hasData)
      return RefreshIndicator(
        onRefresh: () async {
          setState(() {
            getData.getPostedTask();
          });
        },
        child: ListView.builder(
          itemCount: postedTaskLength,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: Colors.grey[300]),
              ),
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
                                  snapshot.data[1][index]['Time']),
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          // Align(
                          //   alignment: Alignment.centerLeft,
                          //   child: Text(
                          //     "Pending",
                          //     style: TextStyle(color: Colors.green),
                          //   ),
                          // ),
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
                            snapshot.data[1][index]['Description'],
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.attach_money,
                            color: Colors.green,
                          ),
                          title: Text(
                            "Budget: ${snapshot.data[1][index]['Budget']}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green,
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
                            "Duration: ${snapshot.data[1][index]['Duration']}",
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
                                  snapshot.data[1][index].id,
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
  }

  completedTask() {}
}
