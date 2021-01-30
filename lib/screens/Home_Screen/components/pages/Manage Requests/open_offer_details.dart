import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/getData.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Inbox/chat_Screen.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Manage Requests/Review_Offers.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Tasks/widgets/common_widgets.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/widgets/time_ago.dart';

class OpenOfferDetails extends StatefulWidget {
  final int index;
  final String docID;
  OpenOfferDetails(this.index, this.docID);
  @override
  _OpenOfferDetailsState createState() => _OpenOfferDetailsState();
}

class _OpenOfferDetailsState extends State<OpenOfferDetails> {
  User user = FirebaseAuth.instance.currentUser;
  GetData getData =  GetData();
  int indexLength;
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
            'Task Details',
            style: TextStyle(
              color: kPrimaryColor,
            ),
          ),
        ),
        backgroundColor: hexColor,
        actions: [
          FlatButton(
            onPressed: () {},
            child: Text("Edit",
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
          FlatButton(
            onPressed: () {},
            child: Text("Delete",
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          initialData: [],
          future: Future.wait([
            getData.getPostedTask(),
            getData.getOffers(widget.docID),
          ]),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return SpinKitDoubleBounce(color: kPrimaryColor);
            indexLength = snapshot.data[1].length;
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Wrap(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                            backgroundColor: kPrimaryColor.withOpacity(0.8),
                            child: user.photoURL != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      user.photoURL,
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
                          user.displayName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                        subtitle: Text(
                          TimeAgo.timeAgoSinceDate(
                              snapshot.data[0][widget.index]['Time']),
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
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
                                snapshot.data[0][widget.index]['Description'],
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(color: Colors.grey[300])),
                              child: ListTile(
                                leading: Icon(Icons.category_outlined),
                                title: Text(
                                  'Category : ${snapshot.data[0][widget.index]['Category']}',
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(color: Colors.grey[300])),
                              child: ListTile(
                                leading: Icon(Icons.location_pin),
                                title: Text(
                                  snapshot.data[0][widget.index]['Location'],
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(color: Colors.grey[300])),
                              child: ListTile(
                                leading: Icon(
                                  Icons.attach_money,
                                  color: kGreenColor,
                                ),
                                title: Text(
                                  'Budget : Rs.${snapshot.data[0][widget.index]['Budget']}',
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(color: Colors.grey[300])),
                              child: ListTile(
                                leading: Icon(Icons.timer),
                                title: Text(
                                  'Duration : ${snapshot.data[0][widget.index]['Duration']}',
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
                            RaisedButton(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text('Review Offers'),
                              textColor: Colors.white,
                              color: Colors.green,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ReviewOffers(widget.docID),
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
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20),
                  height: 50,
                  color: Colors.blueGrey[200].withOpacity(0.3),
                  child: Text(
                    'OFFERS',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                indexLength == 0
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 50, horizontal: 100),
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
                                      backgroundColor:
                                          kPrimaryColor.withOpacity(0.8),
                                      child: snapshot.data[1][i]['PhotoURL'] !=
                                              null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.network(
                                                snapshot.data[1][i]['PhotoURL'],
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.asset(
                                                'assets/images/nullUser.png',
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),
                                            )),
                                  title: Text(
                                    snapshot.data[1][i]['Email'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                  subtitle: Text(
                                    TimeAgo.timeAgoSinceDate(
                                        snapshot.data[1][i]['Time']),
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
                                            snapshot.data[1][i]
                                                        ['Seller Reviews'] ==
                                                    0
                                                ? EmptyRatingBar(
                                                    rating: 5,
                                                  )
                                                : RatingBar(
                                                    rating: snapshot.data[1][i]
                                                        ['Seller Rating'],
                                                  ),
                                            SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        10)),
                                            Text(
                                                '(${snapshot.data[1][i]['Seller Reviews']} Reviews)'),
                                            SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        10)),
                                            Text(
                                                "Completetion Rate: ${snapshot.data[1][i]['Completetion Rate']}%"),
                                          ],
                                        )),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(left: 20),
                                        height: 50,
                                        color: kOfferColor,
                                        child: Center(
                                          child: Text(
                                            'Offer : Rs.${snapshot.data[1][i]['Budget']}',
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
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
                                                    color: snapshot.data[1][i][
                                                                'Email Status'] ==
                                                            'Verified'
                                                        ? kPrimaryColor
                                                            .withOpacity(0.9)
                                                        : Colors.grey[400],
                                                  ),
                                                  Text(
                                                    "Email",
                                                    style: TextStyle(
                                                      color: snapshot.data[1][i]
                                                                  [
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
                                                    color: snapshot.data[1][i][
                                                                'Phone No Status'] ==
                                                            'Verified'
                                                        ? kPrimaryColor
                                                            .withOpacity(0.9)
                                                        : Colors.grey[400],
                                                  ),
                                                  Text(
                                                    "Phone",
                                                    style: TextStyle(
                                                      color: snapshot.data[1][i]
                                                                  [
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
                                                    color: snapshot.data[1][i][
                                                                'Payment Status'] ==
                                                            'Verified'
                                                        ? kPrimaryColor
                                                            .withOpacity(0.9)
                                                        : Colors.grey[400],
                                                  ),
                                                  Text(
                                                    "Payment",
                                                    style: TextStyle(
                                                      color: snapshot.data[1][i]
                                                                  [
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
                                                    color: snapshot.data[1][i][
                                                                'CNIC Status'] ==
                                                            'Verified'
                                                        ? kPrimaryColor
                                                            .withOpacity(0.9)
                                                        : Colors.grey[400],
                                                  ),
                                                  Text(
                                                    "CNIC",
                                                    style: TextStyle(
                                                      color: snapshot.data[1][i]
                                                                  [
                                                                  'CNIC Status'] ==
                                                              'Verified'
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
                                        margin: EdgeInsets.only(left: 160),
                                        child: RaisedButton(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          child: Row(children: [
                                            Icon(Icons.chat),
                                            SizedBox(width: 10),
                                            Text('Chat with Tasker'),
                                          ]),
                                          textColor: Colors.white,
                                          color: Colors.green,
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => ChatScreen(
                                                    receiverName: snapshot.data[1][i] ['Name'],
                                                    receiverEmail: snapshot.data[1][i] ['Email'],
                                                    receiverPhotoURL: snapshot.data[1][i] ['PhotoURL'],
                                                    isOnline: true,
                                                  ),
                                                ));
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
              ],
            );
          },
        ),
      ),
    );
  }
}
