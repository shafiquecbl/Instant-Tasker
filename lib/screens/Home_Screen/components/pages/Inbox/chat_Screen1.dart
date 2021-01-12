import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/getData.dart';
import 'package:shop_app/models/messages.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Inbox/modal_tile.dart';

class ChatScreen1 extends StatefulWidget {
  final String receiverName;
  final String receiverEmail;
  final bool isOnline;

  ChatScreen1({this.receiverName, this.isOnline, this.receiverEmail});

  @override
  _ChatScreen1State createState() => _ChatScreen1State();
}

class _ChatScreen1State extends State<ChatScreen1> {
final email = FirebaseAuth.instance.currentUser.email;
  List<dynamic> list = [];
  @override
  Widget build(BuildContext context) {
    String message;
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        elevation: 2,
        shadowColor: kPrimaryColor,
        backgroundColor: hexColor,
        centerTitle: true,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                  text: widget.receiverName,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: kPrimaryColor)),
              TextSpan(text: '\n'),
              widget.isOnline
                  ? TextSpan(
                      text: 'Online',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: kPrimaryColor),
                    )
                  : TextSpan(
                      text: 'Offline',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: kPrimaryColor),
                    )
            ],
          ),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: kPrimaryColor,
            ),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: FutureBuilder(
        future: Future.wait([
          getUserProfile(),
          getMessages(widget.receiverEmail),
        ]),
        initialData: [list,list],
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  reverse: false,
                  padding: EdgeInsets.all(20),
                  itemCount: snapshot.data[1].length,
                  itemBuilder: (BuildContext context, int index) {
                  String message = snapshot.data[1][index]['Message'];
                      return Column(
                        children: <Widget>[
                          Container(
                            alignment: snapshot.data[1][index]['Email'] == email ? Alignment.topRight : Alignment.topLeft,
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.80,
                              ),
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: snapshot.data[1][index]['Email'] == email ? Theme.of(context).primaryColor : Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: Text(
                                "$message",
                                style: TextStyle(
                                  color:  snapshot.data[1][index]['Email'] == email ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                height: 70,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.attachment),
                      iconSize: 25,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        addMediaModal(context);
                      },
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            message = value;
                          } else {
                            message = value;
                          }
                        },
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            message = value;
                          } else {
                            message = value;
                          }
                        },
                        style: TextStyle(
                          color: UniversalVariables.greyColor,
                        ),
                        decoration: InputDecoration(
                          hintText: "Type a message",
                          hintStyle: TextStyle(
                            color: UniversalVariables.greyColor,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(50.0),
                              ),
                              borderSide: BorderSide.none),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      iconSize: 25,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        addMessage(widget.receiverEmail, snapshot.data[0]['Name'],
                            snapshot.data[0]['PhotoURL'], message);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  addMediaModal(context) {
    showModalBottomSheet(
        context: context,
        elevation: 0,
        backgroundColor: UniversalVariables.blackColor,
        builder: (context) {
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      child: Icon(
                        Icons.close,
                      ),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Content and tools",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView(
                  children: <Widget>[
                    ModalTile(
                      title: "Media",
                      subtitle: "Share Photos and Video",
                      icon: Icons.image,
                    ),
                    ModalTile(
                        title: "File",
                        subtitle: "Share files",
                        icon: Icons.tab),
                    ModalTile(
                        title: "Location",
                        subtitle: "Share a location",
                        icon: Icons.add_location),
                  ],
                ),
              ),
            ],
          );
        });
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const ModalTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVariables.receiverColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: UniversalVariables.greyColor,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: UniversalVariables.greyColor,
            fontSize: 14,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
