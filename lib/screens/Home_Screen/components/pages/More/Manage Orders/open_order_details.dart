import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/getData.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Inbox/chat_Screen.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/More/Manage%20Orders/Submit%20Order/submit_order.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/widgets/time_ago.dart';

class OpenOrderDetails extends StatefulWidget {
  final String docID;
  OpenOrderDetails(this.docID);
  @override
  _OpenOrderDetailsState createState() => _OpenOrderDetailsState();
}

class _OpenOrderDetailsState extends State<OpenOrderDetails> {
  User user = FirebaseAuth.instance.currentUser;
  GetData getData = GetData();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        shadowColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Text(
            'Order Details',
            style: TextStyle(
              color: kPrimaryColor,
            ),
          ),
        ),
        backgroundColor: hexColor,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          initialData: [],
          future: getData.getOrders(widget.docID),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return SpinKitDoubleBounce(color: kPrimaryColor);
            return offerDetails(snapshot.data);
          },
        ),
      ),
    );
  }

  offerDetails(DocumentSnapshot snapshot) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                    backgroundColor: kPrimaryColor.withOpacity(0.8),
                    child: snapshot['Client PhotoURL'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              snapshot['Client PhotoURL'],
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
                  snapshot['Client Name'],
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
                      height: 15,
                    ),
                    RaisedButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 100),
                      child: Row(children: [
                        Icon(Icons.chat),
                        SizedBox(width: 10),
                        Text('Chat with Tasker'),
                      ]),
                      textColor: Colors.white,
                      color: Colors.black.withOpacity(0.7),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                receiverName: snapshot['Client Name'],
                                receiverEmail: snapshot['Client Email'],
                                receiverPhotoURL: snapshot['Client PhotoURL'],
                                isOnline: true,
                              ),
                            ));
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    RaisedButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      child: Text('Submit Order'),
                      textColor: Colors.white,
                      color: greenColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SubmitOrder(snapshot.id,
                                snapshot['Client Email'], snapshot['Time']),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
