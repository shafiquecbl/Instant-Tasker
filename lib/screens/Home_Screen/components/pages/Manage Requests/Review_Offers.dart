import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Inbox/chat_Screen.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/models/getData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Tasks/widgets/common_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shop_app/widgets/customAppBar.dart';
import 'package:shop_app/widgets/time_ago.dart';

class ReviewOffers extends StatefulWidget {
  final String docID;
  ReviewOffers(this.docID);
  @override
  _ReviewOffersState createState() => _ReviewOffersState();
}

class _ReviewOffersState extends State<ReviewOffers> {
  User user = FirebaseAuth.instance.currentUser;
  int indexLength;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: customAppBar("Review Offers"),
      body: FutureBuilder(
        initialData: [],
        future: GetData().getOffers(widget.docID),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return SpinKitDoubleBounce(color: kPrimaryColor);
          indexLength = snapshot.data.length;
          return indexLength == 0
              ? Container(
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
                )
              : ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: indexLength,
                  itemBuilder: (context, i) {
                    return Container(
                      color: kOfferBackColor,
                      margin: EdgeInsets.all(10),
                      child: Wrap(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                                backgroundColor: kPrimaryColor.withOpacity(0.8),
                                child: snapshot.data[i]['PhotoURL'] != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          snapshot.data[i]['PhotoURL'],
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
                              snapshot.data[i]['Email'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                            subtitle: Text(
                              TimeAgo.timeAgoSinceDate(
                                  snapshot.data[i]['Time']),
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
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
                                      snapshot.data[i]['Seller Reviews'] == 0
                                          ? EmptyRatingBar(
                                              rating: 5,
                                            )
                                          : RatingBar(
                                              rating: snapshot.data[i]
                                                  ['Seller Rating'],
                                            ),
                                      SizedBox(
                                          height:
                                              getProportionateScreenHeight(10)),
                                      Text(
                                          '(${snapshot.data[i]['Seller Reviews']} Reviews)'),
                                      SizedBox(
                                          height:
                                              getProportionateScreenHeight(10)),
                                      Text(
                                          "Completetion Rate: ${snapshot.data[i]['Completetion Rate']}%"),
                                          SizedBox(
                                          height:
                                              getProportionateScreenHeight(10)),
                                          Text(
                                          'Duration : ${snapshot.data[i]['Duration']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                    ],
                                  )),
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        color: Colors.grey[200],
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        snapshot.data[i]['Description'],
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Offer Price',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Rs ${snapshot.data[i]['Budget']}',
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Payable Amount',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Rs ${snapshot.data[i]['Budget']}',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Container(
                                        padding: EdgeInsets.only(right: 250),
                                        child: Text(
                                          "Verifications",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 10, right: 10, top: 10),
                                      child: Center(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(children: [
                                                Icon(
                                                  Icons.email,
                                                  color: snapshot.data[i][
                                                              'Email Status'] ==
                                                          'Verified'
                                                      ? kPrimaryColor
                                                          .withOpacity(0.9)
                                                      : Colors.grey[400],
                                                ),
                                                Text(
                                                  "Email",
                                                  style: TextStyle(
                                                    color: snapshot.data[i][
                                                                'Email Status'] ==
                                                            'Verified'
                                                        ? kPrimaryColor
                                                            .withOpacity(0.9)
                                                        : Colors.grey[400],
                                                  ),
                                                )
                                              ]),
                                              Column(children: [
                                                Icon(
                                                  Icons.phone,
                                                  color: snapshot.data[i][
                                                              'Phone No Status'] ==
                                                          'Verified'
                                                      ? kPrimaryColor
                                                          .withOpacity(0.9)
                                                      : Colors.grey[400],
                                                ),
                                                Text(
                                                  "Phone",
                                                  style: TextStyle(
                                                    color: snapshot.data[i][
                                                                'Phone No Status'] ==
                                                            'Verified'
                                                        ? kPrimaryColor
                                                            .withOpacity(0.9)
                                                        : Colors.grey[400],
                                                  ),
                                                )
                                              ]),
                                              Column(children: [
                                                Icon(
                                                  Icons.payment,
                                                  color: snapshot.data[i][
                                                              'Payment Status'] ==
                                                          'Verified'
                                                      ? kPrimaryColor
                                                          .withOpacity(0.9)
                                                      : Colors.grey[400],
                                                ),
                                                Text(
                                                  "Payment",
                                                  style: TextStyle(
                                                    color: snapshot.data[i][
                                                                'Payment Status'] ==
                                                            'Verified'
                                                        ? kPrimaryColor
                                                            .withOpacity(0.9)
                                                        : Colors.grey[400],
                                                  ),
                                                )
                                              ]),
                                              Column(children: [
                                                Icon(
                                                  Icons.verified_user,
                                                  color: snapshot.data[i]
                                                              ['CNIC Status'] ==
                                                          'verified'
                                                      ? kPrimaryColor
                                                          .withOpacity(0.9)
                                                      : Colors.grey[400],
                                                ),
                                                Text(
                                                  "CNIC",
                                                  style: TextStyle(
                                                    color: snapshot.data[i][
                                                                'CNIC Status'] ==
                                                            'verified'
                                                        ? kPrimaryColor
                                                            .withOpacity(0.9)
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
                                          Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => ChatScreen(
                                                    receiverName: snapshot.data[i] ['Name'],
                                                    receiverEmail: snapshot.data[i] ['Email'],
                                                    receiverPhotoURL: snapshot.data[i] ['PhotoURL'],
                                                    isOnline: true,
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
                                        color: Colors.green,
                                        onPressed: () {},
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
                  });
        },
      ),
    );
  }
}
