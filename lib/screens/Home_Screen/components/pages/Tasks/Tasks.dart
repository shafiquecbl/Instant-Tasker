import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/More/Verification/verify_cnic.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Tasks/Send%20Offer/send_offer.dart';
import 'package:shop_app/models/getData.dart';
import 'package:shop_app/widgets/customAppBar.dart';
import 'package:shop_app/widgets/time_ago.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  User user = FirebaseAuth.instance.currentUser;
  GetData getData = new GetData();
  int indexLength;
  String cnicCheck;
  List<dynamic> list = [];

  // ignore: unused_field
  String _btn1SelectedVal;

////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Buyer Requests"),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Buyer Requests")
            .where("Email",
                isNotEqualTo: FirebaseAuth.instance.currentUser.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return SpinKitCircle(color: kPrimaryColor);
          indexLength = snapshot.data.docs.length;
          if (indexLength == 0)
            return SizedBox(
              child: Center(
                child: Text(
                  "No Buyer Requests",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: kPrimaryColor),
                ),
              ),
            );
          return SizedBox(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: indexLength,
              physics:
                  PageScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              controller: PageController(viewportFraction: 1.0),
              itemBuilder: (context, i) {
                return SingleChildScrollView(
                    child: container(snapshot.data.docs[i], i));
              },
            ),
          );
        },
      ),
    );
  }

  container(QueryDocumentSnapshot snapshot, i) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: Colors.grey[300]),
      ),
      child: Wrap(
        direction: Axis.vertical,
        children: <Widget>[
          Container(
            width: 390,
            child: ListTile(
              leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: kPrimaryColor.withOpacity(0.8),
                  child: snapshot['PhotoURL'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/load.gif',
                            image: snapshot['PhotoURL'],
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
                snapshot['Email'],
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
          ),
          Container(
            width: 390,
            child: Padding(
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
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.grey[300])),
                    child: ListTile(
                      leading: Icon(Icons.category_outlined),
                      title: Text(
                        'Category : ${snapshot['Category']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.grey[300])),
                    child: ListTile(
                      leading: Icon(Icons.location_pin),
                      title: Text(
                        snapshot['Location'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.grey[300])),
                    child: ListTile(
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
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.grey[300])),
                    child: ListTile(
                      leading: Icon(Icons.timer),
                      title: Text(
                        'Duration : ${snapshot['Duration']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  FutureBuilder(
                    future: getData.getCNIC(),
                    builder: (BuildContext context, AsyncSnapshot snap) {
                      cnicCheck = snap.data;
                      return RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text('Send Offer'),
                        textColor: Colors.white,
                        color: greenColor,
                        onPressed: () {
                          if (cnicCheck == "verified") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SendOffer(snapshot.id),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VerifyCNIC(),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      "${i + 1}/$indexLength",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
