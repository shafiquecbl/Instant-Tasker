import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/getData.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Manage%20Requests/open_offer_details.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/More/Post%20a%20Task/post_task.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/widgets/time_ago.dart';
import 'package:shop_app/models/deleteData.dart';

class ManageRequests extends StatefulWidget {
  @override
  _ManageRequestsState createState() => _ManageRequestsState();
}

class _ManageRequestsState extends State<ManageRequests> {
  int indexLength;
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
              'My Tasks',
              style: TextStyle(
                color: kPrimaryColor,
              ),
            ),
          ),
          backgroundColor: hexColor,
        ),
        body: Container(
          child: FutureBuilder(
            initialData: [],
            future: getData.getUserRequests(),
            // ignore: missing_return
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return SpinKitDoubleBounce(color: kPrimaryColor);
              indexLength = snapshot.data.length;
              if (indexLength == 0)
                return SizedBox(
                  child: Center(
                      child: RaisedButton(
                    color: kPrimaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      "Post Task",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: kWhiteColor),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PostTask(),
                        ),
                      );
                    },
                  )),
                );
              if (snapshot.hasData)
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                     getData.getUserRequests();
                    });
                  },
                  child: ListView.builder(
                    itemCount: indexLength,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: Colors.grey[300]),
                        ),
                        child: Wrap(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 17, top: 5),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        TimeAgo.timeAgoSinceDate(
                                            snapshot.data[index]['Time']),
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: SizedBox(
                                          height: 25,
                                          child: IconButton(
                                            color: Colors.grey,
                                            padding: EdgeInsets.all(0),
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              deleteUserRequest(snapshot.data[index].id).then((value) => updateScreen());
                                            },
                                          ),
                                        ))
                                  ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
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
                                      snapshot.data[index]['Description'],
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6)),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.attach_money,
                                      color: Colors.green,
                                    ),
                                    title: Text(
                                      "Budget: ${snapshot.data[index]['Budget']}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 70),
                                    child: Divider(
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.timer),
                                    title: Text(
                                      "Duration: ${snapshot.data[index]['Duration']}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  FutureBuilder(
                                    initialData: [],
                                    future: getData.getOffers(snapshot.data[index].id),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snap) {
                                      return RaisedButton(
                                        child: Text(
                                            'View Offers  (${snap.data.length})'),
                                        textColor: Colors.white,
                                        color: kPrimaryColor,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => OpenOfferDetails(
                                                  index,
                                                  snapshot.data[index].id),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
            },
          ),
        ));
  }

  updateScreen(){
    setState(() {
      getData.getUserRequests();
    });
  }
}
