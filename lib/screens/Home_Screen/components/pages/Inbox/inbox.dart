import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/updateData.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Inbox/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/widgets/customAppBar.dart';
import 'package:shop_app/widgets/time_ago.dart';

class Inbox extends StatefulWidget {
  @override
  _InboxState createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  User user = FirebaseAuth.instance.currentUser;
  final email = FirebaseAuth.instance.currentUser.email;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: customAppBar("Inbox"),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(email)
            .collection('Contacts')
            .orderBy("Time", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) return SpinKitCircle(color: kPrimaryColor);
          if (snapshot.data.docs.length == 0)
            return Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                child: Text(
                  'No Messages',
                  style: TextStyle(
                      color: kPrimaryColor, fontWeight: FontWeight.bold),
                ),
              ),
            );
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                FirebaseFirestore.instance
                    .collection('Users')
                    .doc(email)
                    .collection('Contacts')
                    .snapshots();
              });
            },
            child: ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return userList(snapshot.data.docs[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget userList(DocumentSnapshot snapshot) {
    return GestureDetector(
      onTap: () => Navigator.of(context, rootNavigator: true)
          .push(
            MaterialPageRoute(
                builder: (_) => ChatScreen(
                      receiverEmail: snapshot['Email'],
                      receiverName: snapshot['Name'],
                      receiverPhotoURL: snapshot['PhotoURL'],
                    )),
          )
          .then((value) => UpdateData().updateMessageStatus(snapshot['Email'])),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                border: Border.all(
                  width: 2,
                  color: Theme.of(context).primaryColor,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: snapshot['PhotoURL'] == null ? 30 : 30,
                backgroundColor: kPrimaryColor.withOpacity(0.8),
                child: user.photoURL != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(70),
                        child: Image.network(
                          snapshot['PhotoURL'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50)),
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              padding: EdgeInsets.only(
                left: 20,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        snapshot['Name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      snapshot['Status'] == "unread"
                          ? Icon(Icons.mark_email_unread, color: blueColor)
                          : Container()
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 145,
                        // margin: EdgeInsets.only(bottom:15),
                        alignment: Alignment.topLeft,
                        child: Text(
                          snapshot['Last Message'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Text(
                        TimeAgo.timeAgoSinceDate(snapshot['Time']),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w300,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
