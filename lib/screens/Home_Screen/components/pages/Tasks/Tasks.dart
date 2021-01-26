import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/More/Verification/verify_cnic.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Tasks/Send%20Offer/send_offer.dart';
import 'package:shop_app/models/getData.dart';
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

// popup menu data//
  static const menuItems = <String>[
    'All',
    'Online',
    'Physical',
    'Offered',
  ];

  final List<PopupMenuItem<String>> _popUpMenuItems = menuItems
      .map(
        (String value) => PopupMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  // ignore: unused_field
  String _btn1SelectedVal;

////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        shadowColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Text(
            'Buyer Requests',
            style: TextStyle(
              color: kPrimaryColor,
            ),
          ),
        ),
        backgroundColor: hexColor,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.filter_list,
              color: kPrimaryColor,
            ),
            onSelected: (String newValue) {
              _btn1SelectedVal = newValue;
            },
            itemBuilder: (BuildContext context) => _popUpMenuItems,
          ),
        ],
      ),
      body: FutureBuilder(
        initialData: [list,cnicCheck],
        future: Future.wait([
          getData.getRequests(),
          getData.getCNIC(),
          ]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting)
          return SpinKitDoubleBounce(color: kPrimaryColor);
          indexLength = snapshot.data[0].length;
          cnicCheck = snapshot.data[1];
          if (indexLength == 0)
            return SizedBox(
              child: Center(
                child: Text(
                  "No Buyer Requests",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: kPrimaryColor),
                ),
              ),
            );
            return SizedBox(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: indexLength,
                physics: PageScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                controller: PageController(viewportFraction: 1.0),
                itemBuilder: (context, i) {
                  return SingleChildScrollView(
                    child: Container(
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
                                  backgroundColor: kPrimaryColor.withOpacity(0.8),
                                  backgroundImage:
                                      AssetImage('assets/images/nullUser.png'),
                                  child: snapshot.data[0][i]['PhotoURL'] != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: Image.network(
                                            snapshot.data[0][i]['PhotoURL'],
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
                                snapshot.data[0][i]['Email'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                              subtitle: Text(
                                TimeAgo.timeAgoSinceDate(snapshot.data[0][i]['Time']),
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: Colors.grey[200],
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    snapshot.data[0][i]['Description'],
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
                                      border:
                                          Border.all(color: Colors.grey[300])),
                                  child: ListTile(
                                    leading: Icon(Icons.category_outlined),
                                    title: Text(
                                      'Category : ${snapshot.data[0][i]['Category']}',
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
                                      border:
                                          Border.all(color: Colors.grey[300])),
                                  child: ListTile(
                                    leading: Icon(Icons.location_pin),
                                    title: Text(
                                      snapshot.data[0][i]['Location'],
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
                                      border:
                                          Border.all(color: Colors.grey[300])),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.attach_money,
                                      color: kGreenColor,
                                    ),
                                    title: Text(
                                      'Budget : Rs.${snapshot.data[0][i]['Budget']}',
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
                                      border:
                                          Border.all(color: Colors.grey[300])),
                                  child: ListTile(
                                    leading: Icon(Icons.timer),
                                    title: Text(
                                      'Duration : ${snapshot.data[0][i]['Duration']}',
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text('Send Offer'),
                                      textColor: Colors.white,
                                      color: Colors.green,
                                      onPressed: () {
                                        if (cnicCheck == "verified") {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => SendOffer(snapshot.data[0][i].id),
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
                    ),
                  );
                },
              ),
            );
        },
      ),
    );
  }
}
