import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Tasks/widgets/common_widgets.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/widgets/time_ago.dart';

class OpenProfile extends StatefulWidget {
  final String email;
  OpenProfile({@required this.email});
  @override
  _OpenProfileState createState() => _OpenProfileState();
}

class _OpenProfileState extends State<OpenProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kWhiteColor,
        actions: [
          RaisedButton(
              color: hexColor,
              onPressed: () {
                reviews();
              },
              child: Text(
                "Reviews",
                style: TextStyle(
                    color: kPrimaryColor, fontWeight: FontWeight.bold),
              ))
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .where('Email', isEqualTo: widget.email)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null)
              return SpinKitCircle(
                color: kPrimaryColor,
              );
            return ListView(children: [column(snapshot.data.docs[0])]);
          },
        ),
      ),
    );
  }

  column(DocumentSnapshot snapshot) {
    return Column(
      children: [
        SizedBox(height: getProportionateScreenHeight(5)),
        Stack(
          children: [
            CircleAvatar(
              radius: snapshot['PhotoURL'] == null ? 50 : 68,
              backgroundColor: kPrimaryColor.withOpacity(0.8),
              child: snapshot['PhotoURL'] != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/load.gif',
                        image: snapshot['PhotoURL'],
                        width: 130,
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("assets/images/nullUser.png")),
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(70)),
                      width: 132,
                      height: 132,
                    ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          snapshot['Name'],
          style: TextStyle(
              fontSize: 18.0,
              color: Colors.blueGrey,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: DefaultTabController(
              length: 2, // length of tabs
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: TabBar(
                        labelColor: kWhiteColor,
                        unselectedLabelColor: kPrimaryColor,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            color: kPrimaryColor),
                        tabs: [
                          Tab(text: 'As Seller'),
                          Tab(text: 'As Buyer'),
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        height: 140, //height of TabBarView
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: Colors.grey, width: 0.5))),
                        child: TabBarView(children: <Widget>[
                          Container(
                            child: Center(
                                child: Column(
                              children: [
                                SizedBox(
                                    height: getProportionateScreenHeight(10)),
                                snapshot['Rating as Seller'] == 0
                                    ? EmptyRatingBar(
                                        rating: 5,
                                      )
                                    : RatingBar(
                                        rating: snapshot['Rating as Seller'],
                                      ),
                                SizedBox(
                                    height: getProportionateScreenHeight(10)),
                                Text(
                                    '${snapshot['Reviews as Seller']} Reviews'),
                                SizedBox(
                                    height: getProportionateScreenHeight(10)),
                                Text(
                                    '${snapshot['Completion Rate']}% Completetion Rate'),
                                Text(
                                    '${snapshot['Completed Task']} Completed Tasks'),
                              ],
                            )),
                          ),
                          Container(
                            child: Center(
                                child: Column(
                              children: [
                                SizedBox(
                                    height: getProportionateScreenHeight(10)),
                                snapshot['Rating as Buyer'] == 0
                                    ? EmptyRatingBar(
                                        rating: 5,
                                      )
                                    : RatingBar(
                                        rating: snapshot['Rating as Buyer'],
                                      ),
                                SizedBox(
                                    height: getProportionateScreenHeight(10)),
                                Text('${snapshot['Reviews as Buyer']} Reviews'),
                                SizedBox(
                                    height: getProportionateScreenHeight(10)),
                                Text(
                                    '${snapshot['Completed Task as Buyer']} Completed Tasks'),
                              ],
                            )),
                          ),
                        ]))
                  ])),
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20),
          height: 50,
          color: Colors.blueGrey[200].withOpacity(0.3),
          child: Text(
            'About',
            style: TextStyle(color: Colors.black.withOpacity(0.7)),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
          child: Text(
            snapshot['About'],
            style: TextStyle(color: Colors.black.withOpacity(0.7)),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20),
          height: 50,
          color: Colors.blueGrey[200].withOpacity(0.3),
          child: Text(
            'Gender',
            style: TextStyle(color: Colors.black.withOpacity(0.7)),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
          child: Text(
            snapshot['Gender'],
            style: TextStyle(color: Colors.black.withOpacity(0.7)),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20),
          height: 50,
          color: Colors.blueGrey[200].withOpacity(0.3),
          child: Text(
            'Contacts',
            style: TextStyle(color: Colors.black.withOpacity(0.7)),
          ),
        ),
        Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
            child: Column(children: [
              ListTile(
                leading: Icon(Icons.email_outlined, color: kPrimaryColor),
                title: Text("Email"),
                subtitle: Text(widget.email),
              ),
              ListTile(
                leading: Icon(Icons.phone, color: kPrimaryColor),
                title: Text("Phone"),
                subtitle: Text(snapshot['Phone Number']),
              ),
            ])),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20),
          height: 50,
          color: Colors.blueGrey[200].withOpacity(0.3),
          child: Text(
            'Address',
            style: TextStyle(color: Colors.black.withOpacity(0.7)),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
          child: Text(
            snapshot['Address'],
            style: TextStyle(color: Colors.black.withOpacity(0.7)),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20),
          height: 50,
          color: Colors.blueGrey[200].withOpacity(0.3),
          child: Text(
            'Education',
            style: TextStyle(color: Colors.black.withOpacity(0.7)),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
          child: Text(
            snapshot['Education'],
            style: TextStyle(color: Colors.black.withOpacity(0.7)),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20),
          height: 50,
          color: Colors.blueGrey[200].withOpacity(0.3),
          child: Text(
            'Specialities',
            style: TextStyle(color: Colors.black.withOpacity(0.7)),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
          child: Text(
            snapshot['Specialities'],
            style: TextStyle(color: Colors.black.withOpacity(0.7)),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20),
          height: 50,
          color: Colors.blueGrey[200].withOpacity(0.3),
          child: Text(
            'Languages',
            style: TextStyle(color: Colors.black.withOpacity(0.7)),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
          child: Text(
            snapshot['Languages'],
            style: TextStyle(color: Colors.black.withOpacity(0.7)),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20),
          height: 50,
          color: Colors.blueGrey[200].withOpacity(0.3),
          child: Text(
            'Work',
            style: TextStyle(color: Colors.black.withOpacity(0.7)),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
          child: Text(
            snapshot['Work'],
            style: TextStyle(color: Colors.black.withOpacity(0.7)),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20),
          height: 50,
          color: Colors.blueGrey[200].withOpacity(0.3),
          child: Text(
            'Reviews',
            style: TextStyle(color: Colors.black.withOpacity(0.7)),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: DefaultTabController(
              length: 2, // length of tabs
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: TabBar(
                        labelColor: kWhiteColor,
                        unselectedLabelColor: kPrimaryColor,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            color: kPrimaryColor),
                        tabs: [
                          Tab(text: 'As Seller'),
                          Tab(text: 'As Buyer'),
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        height: 140, //height of TabBarView
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: Colors.grey, width: 0.5))),
                        child: TabBarView(children: <Widget>[
                          Container(
                            child: Center(
                                child: Column(
                              children: [
                                SizedBox(
                                    height: getProportionateScreenHeight(10)),
                                Text(
                                    '${snapshot['Rating as Seller']} stars from ${snapshot['Reviews as Seller']} Reviews'),
                                SizedBox(
                                    height: getProportionateScreenHeight(10)),
                                snapshot['Rating as Seller'] == 0
                                    ? EmptyRatingBar(
                                        rating: 5,
                                      )
                                    : RatingBar(
                                        rating: snapshot['Rating as Seller'],
                                      ),
                                SizedBox(
                                    height: getProportionateScreenHeight(10)),
                                Text(
                                    'This user has ${snapshot['Reviews as Seller']} reviews as a Seller'),
                              ],
                            )),
                          ),
                          Container(
                            child: Center(
                                child: Column(
                              children: [
                                SizedBox(
                                    height: getProportionateScreenHeight(10)),
                                Text(
                                    '${snapshot['Rating as Buyer']} stars from ${snapshot['Reviews as Buyer']} Reviews'),
                                SizedBox(
                                    height: getProportionateScreenHeight(10)),
                                snapshot['Rating as Buyer'] == 0
                                    ? EmptyRatingBar(
                                        rating: 5,
                                      )
                                    : RatingBar(
                                        rating: snapshot['Rating as Buyer'],
                                      ),
                                SizedBox(
                                    height: getProportionateScreenHeight(10)),
                                Text(
                                    'This user has ${snapshot['Reviews as Buyer']} reviews as a Buyer'),
                              ],
                            )),
                          ),
                        ]))
                  ])),
        ),
      ],
    );
  }

  reviews() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(widget.email)
                .collection('Reviews')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null)
                return SpinKitCircle(color: kPrimaryColor);
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: <Widget>[
                        FlatButton(
                          child: Icon(
                            Icons.close,
                            color: kPrimaryColor,
                          ),
                          onPressed: () => Navigator.maybePop(context),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Reviews ( ${snapshot.data.docs.length} )",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: CircleAvatar(
                                radius: 27,
                                backgroundColor: kPrimaryColor.withOpacity(0.8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(70),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/images/load.gif',
                                    image: snapshot.data.docs[index]
                                        ['PhotoURL'],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                            title: Text(snapshot.data.docs[index]['Name'],
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(snapshot.data.docs[index]['Review']),
                            trailing: Text(TimeAgo.timeAgoSinceDate(
                                snapshot.data.docs[index]['Time'])),
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }
}
