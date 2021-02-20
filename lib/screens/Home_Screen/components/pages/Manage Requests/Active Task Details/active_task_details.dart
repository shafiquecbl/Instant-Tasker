import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/getData.dart';
import 'package:shop_app/models/updateData.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Inbox/chat_Screen.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/widgets/snack_bar.dart';
import 'package:shop_app/widgets/time_ago.dart';
import 'package:shop_app/widgets/customAppBar.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Manage%20Requests/Active%20Task%20Details/mark_order_asComplete.dart';

class ActiveTaskDetails extends StatefulWidget {
  final int index;
  final String docID;
  ActiveTaskDetails(this.index, this.docID);
  @override
  _ActiveTaskDetailsState createState() => _ActiveTaskDetailsState();
}

class _ActiveTaskDetailsState extends State<ActiveTaskDetails> {
  User user = FirebaseAuth.instance.currentUser;
  GetData getData = GetData();
  UpdateData updateData = UpdateData();

  //
  String taskID;
  String orderID;
  String email;
  //
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: customAppBar('Active Task Details'),
      body: SingleChildScrollView(
        child: FutureBuilder(
          initialData: [],
          future: getData.getActiveTask(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return SpinKitDoubleBounce(color: kPrimaryColor);
            return taskDetails(snapshot.data[widget.index]);
          },
        ),
      ),
    );
  }

  taskDetails(DocumentSnapshot snapshot) {
    return Column(
      children: [
        details(snapshot),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20),
          height: 50,
          color: Colors.blueGrey[200].withOpacity(0.3),
          child: Text(
            'Received Work',
            style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
        receivedWork(snapshot),
      ],
    );
  }

  details(DocumentSnapshot snapshot) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Wrap(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
                backgroundColor: kPrimaryColor.withOpacity(0.8),
                child: snapshot['Seller PhotoURL'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          snapshot['Seller PhotoURL'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          'assets/images/nullUser.png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      )),
            title: Text(
              snapshot['Seller Name'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
            subtitle: Text(
              TimeAgo.timeAgoSinceDate(snapshot['Time']),
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                    snapshot['Description'],
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                ListTile(
                  leading: Icon(Icons.category_outlined),
                  title: Text(
                    'Category : ${snapshot['Category']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                ListTile(
                  leading: Icon(Icons.location_pin),
                  title: Text(
                    snapshot['Location'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                ListTile(
                  leading: Icon(
                    Icons.attach_money,
                    color: kGreenColor,
                  ),
                  title: Text(
                    'Budget : Rs.${snapshot['Budget']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: kGreenColor,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                ListTile(
                  leading: Icon(Icons.timer),
                  title: Text(
                    'Duration : ${snapshot['Duration']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                divider,
                SizedBox(
                  height: 20,
                ),
                chatWithTasker(snapshot),
                SizedBox(
                  height: 5,
                ),
                cancelOrder(),
                SizedBox(
                  height: 5,
                ),
                snapshot['Status'] == "Waiting for rating"
                    ? takeRevision(snapshot)
                    : Container(),
                SizedBox(
                  height: 5,
                ),
                snapshot['Status'] == "Waiting for rating"
                    ? markAsComplete(snapshot['Seller Email'])
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  chatWithTasker(DocumentSnapshot snapshot) {
    return RaisedButton(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 100),
      child: Row(children: [
        Icon(Icons.chat),
        SizedBox(width: 10),
        Text('Chat with Tasker'),
      ]),
      textColor: Colors.white,
      color: Colors.black.withOpacity(0.7),
      onPressed: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ChatScreen(
                receiverName: snapshot['Seller Name'],
                receiverEmail: snapshot['Seller Email'],
                receiverPhotoURL: snapshot['Seller PhotoURL'],
                isOnline: true,
              ),
            ));
      },
    );
  }

  cancelOrder() {
    return RaisedButton(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Text('Cancel Order'),
      textColor: Colors.white,
      color: Colors.red,
      onPressed: () {},
    );
  }

  takeRevision(DocumentSnapshot snapshot) {
    return FutureBuilder(
      future: getData.getorderDocID(snapshot['Seller Email'], snapshot['Time']),
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (snap.connectionState == ConnectionState.waiting)
          return RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Text('Take Revesion'),
              textColor: Colors.white,
              color: Colors.orange,
              onPressed: () {});
        taskID = snapshot.id;
        orderID = snap.data[0].id;
        email = snapshot['Seller Email'];
        return RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Text('Take Revesion'),
          textColor: Colors.white,
          color: Colors.orange,
          onPressed: () {
            confirmRevision(context, taskID, orderID, email);
          },
        );
      },
    );
  }

  confirmRevision(BuildContext context, taskID, orderID, email) {
    // set up the button
    Widget acceptButton = CupertinoDialogAction(
      child: Text("Yes"),
      onPressed: () {
        updateData
            .orderRevesion(orderID, taskID, email)
            .then((value) => {
                  Snack_Bar.show(context, "Asked for Revesion successfully"),
                  Navigator.pop(context)
                })
            .then((value) => {
                  setState(() {
                    getData.getActiveTask();
                  })
                });
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
      content: Text("Do you want to take revision?"),
      actions: [
        cancelButton,
        acceptButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  markAsComplete(userEmail) {
    return RaisedButton(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Text('Mark as complete'),
      textColor: Colors.white,
      color: greenColor,
      onPressed: () {
        confirmCompletetion(context);
      },
    );
  }

  confirmCompletetion(BuildContext context) {
    // set up the button
    Widget acceptButton = CupertinoDialogAction(
      child: Text("Yes"),
      onPressed: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CompleteOrder(
                taskID: taskID,
                orderID: orderID,
                userEmail: email,
              ),
            ));
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
      content: Text("Do you want to mark order as complete?"),
      actions: [
        cancelButton,
        acceptButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  receivedWork(DocumentSnapshot snapshot) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser.email)
          .collection("Assigned Tasks")
          .doc(snapshot.id)
          .collection("Received Work")
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (snap.data == null) return Container();
        if (snap.data.docs.length == 0)
          return Container(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Center(
                child: Text(
              'No Work Yet',
              style: TextStyle(
                fontSize: 16,
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            )),
          );
        return ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: snap.data.docs.length,
            itemBuilder: (context, i) {
              return Container(
                  color: kOfferBackColor,
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Work : ${snap.data.docs[i]['Description']}"),
                        Text(
                            "Time : ${TimeAgo.timeAgoSinceDate(snap.data.docs[i]['Time'])}"),
                      ],
                    ),
                  ));
            });
      },
    );
  }
}
