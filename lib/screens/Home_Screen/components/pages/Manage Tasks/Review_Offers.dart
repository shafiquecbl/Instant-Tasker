import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/deleteData.dart';
import 'package:shop_app/models/setData.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Inbox/chat_Screen.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/models/getData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Tasks/widgets/common_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shop_app/widgets/alert_dialog.dart';
import 'package:shop_app/widgets/customAppBar.dart';
import 'package:shop_app/widgets/time_ago.dart';

class ReviewOffers extends StatefulWidget {
  final String docID;
  ReviewOffers({this.docID});
  @override
  _ReviewOffersState createState() => _ReviewOffersState();
}

class _ReviewOffersState extends State<ReviewOffers> {
  User user = FirebaseAuth.instance.currentUser;
  GetData getData = GetData();
  int indexLength;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: customAppBar("Review Offers"),
      body: FutureBuilder(
        future: Future.wait([
          getData.getOffers(widget.docID),
          getData.getTask(widget.docID),
        ]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) return SpinKitCircle(color: kPrimaryColor);
          if (snapshot.connectionState == ConnectionState.waiting)
            return SpinKitCircle(color: kPrimaryColor);
          indexLength = snapshot.data[0].length;
          if (indexLength == 0)
            return Container(
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 100),
              child: Container(
                height: 50,
                color: kPrimaryColor,
                child: Center(
                    child: Text(
                  'No Offers Yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: kWhiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ),
            );
          return ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: indexLength,
              itemBuilder: (context, i) {
                return list(snapshot.data[0][i], i);
              });
        },
      ),
    );
  }

  list(DocumentSnapshot snapshot, i) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(snapshot['Email'])
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (snap.data == null)
          return SpinKitCircle(
            color: kPrimaryColor,
          );
        return Container(
          color: kOfferBackColor,
          margin: EdgeInsets.all(10),
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: kPrimaryColor.withOpacity(0.8),
                    child: snap.data['PhotoURL'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/images/load.gif',
                              image: snap.data['PhotoURL'],
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      child: Center(
                          child: Column(
                        children: [
                          snap.data['Reviews as Seller'] == 0
                              ? EmptyRatingBar(
                                  rating: 5,
                                )
                              : RatingBar(
                                  rating: snap.data['Rating as Seller'],
                                ),
                          SizedBox(height: getProportionateScreenHeight(10)),
                          Text('(${snap.data['Reviews as Seller']} Reviews)'),
                          SizedBox(height: getProportionateScreenHeight(10)),
                          Text(
                              "Completetion Rate: ${snap.data['Completion Rate']}%"),
                          SizedBox(height: getProportionateScreenHeight(10)),
                          Text(
                            'Duration : ${snapshot['Duration']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: kPrimaryColor,
                            ),
                          ),
                        ],
                      )),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.grey[200],
                          ),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            snapshot['Description'],
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Offer Price',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Rs ${snapshot['Budget']}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                        Divider(
                          height: 1,
                          color: Colors.black,
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Payable Amount',
                                  style: TextStyle(
                                      color: greenColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Rs ${snapshot['Budget']}',
                                  style: TextStyle(
                                      color: greenColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: Center(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(children: [
                                    Icon(
                                      Icons.email,
                                      color: snap.data['Email status'] ==
                                              'Verified'
                                          ? kPrimaryColor.withOpacity(0.9)
                                          : Colors.grey[400],
                                    ),
                                    Text(
                                      "Email",
                                      style: TextStyle(
                                        color: snap.data['Email status'] ==
                                                'Verified'
                                            ? kPrimaryColor.withOpacity(0.9)
                                            : Colors.grey[400],
                                      ),
                                    )
                                  ]),
                                  Column(children: [
                                    Icon(
                                      Icons.phone,
                                      color: snap.data['Phone Number status'] ==
                                              'Verified'
                                          ? kPrimaryColor.withOpacity(0.9)
                                          : Colors.grey[400],
                                    ),
                                    Text(
                                      "Phone",
                                      style: TextStyle(
                                        color:
                                            snap.data['Phone Number status'] ==
                                                    'Verified'
                                                ? kPrimaryColor.withOpacity(0.9)
                                                : Colors.grey[400],
                                      ),
                                    )
                                  ]),
                                  Column(children: [
                                    Icon(
                                      Icons.payment,
                                      color: snap.data['Payment Status'] ==
                                              'Verified'
                                          ? kPrimaryColor.withOpacity(0.9)
                                          : Colors.grey[400],
                                    ),
                                    Text(
                                      "Payment",
                                      style: TextStyle(
                                        color: snap.data['Payment Status'] ==
                                                'Verified'
                                            ? kPrimaryColor.withOpacity(0.9)
                                            : Colors.grey[400],
                                      ),
                                    )
                                  ]),
                                  Column(children: [
                                    Icon(
                                      Icons.verified_user,
                                      color:
                                          snap.data['CNIC Status'] == 'verified'
                                              ? kPrimaryColor.withOpacity(0.9)
                                              : Colors.grey[400],
                                    ),
                                    Text(
                                      "CNIC",
                                      style: TextStyle(
                                        color: snap.data['CNIC Status'] ==
                                                'verified'
                                            ? kPrimaryColor.withOpacity(0.9)
                                            : Colors.grey[400],
                                      ),
                                    )
                                  ]),
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Container(
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 100),
                            child: Row(children: [
                              Icon(Icons.chat),
                              SizedBox(width: 10),
                              Text('Chat with Tasker'),
                            ]),
                            textColor: Colors.white,
                            color: Colors.black.withOpacity(0.7),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true)
                                  .push(MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                  receiverName: snapshot['Name'],
                                  receiverEmail: snapshot['Email'],
                                  receiverPhotoURL: snap.data['PhotoURL'],
                                ),
                              ));
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            child: Text('Accept Offer'),
                            textColor: Colors.white,
                            color: greenColor,
                            onPressed: () {
                              acceptOffer(context, snapshot, i);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  acceptOffer(BuildContext context, DocumentSnapshot snapshot, int i) {
    // set up the button
    Widget acceptButton = CupertinoDialogAction(
      child: Text("Yes"),
      onPressed: () {
        Navigator.pop(context);
        showLoadingDialog(context);
        SetData()
            .assignTask(
                context,
                snapshot['Description'],
                snapshot['Category'],
                snapshot['Duration'],
                snapshot['Budget'],
                snapshot['Location'],
                snapshot['Email'],
                snapshot['PhotoURL'],
                snapshot['Name'])
            .then((value) => deleteUserRequest(widget.docID))
            .then((value) {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
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
        "Confirmation",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text("Do you want to accept offer?"),
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
}
