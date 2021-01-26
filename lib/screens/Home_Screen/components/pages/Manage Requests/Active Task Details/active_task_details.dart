import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/getData.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/widgets/time_ago.dart';
import 'package:shop_app/widgets/customAppBar.dart';

class ActiveTaskDetails extends StatefulWidget {
  final int index;
  final String docID;
  ActiveTaskDetails(this.index, this.docID);
  @override
  _ActiveTaskDetailsState createState() => _ActiveTaskDetailsState();
}

class _ActiveTaskDetailsState extends State<ActiveTaskDetails> {
  User user = FirebaseAuth.instance.currentUser;
  GetData getData =  GetData();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: customAppBar('Active Task Details'),
      body: SingleChildScrollView(
        child: FutureBuilder(
          initialData: [],
          future: Future.wait([
            getData.getActiveTask(),
          ]),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return SpinKitDoubleBounce(color: kPrimaryColor);
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
                              child: Text('Comming Soon'),
                              textColor: Colors.white,
                              color: Colors.green,
                              onPressed: () {},
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
          },
        ),
      ),
    );
  }
}
