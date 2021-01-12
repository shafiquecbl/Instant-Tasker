import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/getData.dart';
import 'package:shop_app/size_config.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class VerifyCNIC extends StatefulWidget {
  static String routeName = "/verifycnic";
  @override
  _VerifyCNICState createState() => _VerifyCNICState();
}

class _VerifyCNICState extends State<VerifyCNIC> {
  String storePhoneNo;
  File _cnicFrontPhoto;
  File _cnicBackPhoto;
  File _userPic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        shadowColor: kPrimaryColor,
        title: Text(
          "Verify CNIC",
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: hexColor,
      ),
      body: FutureBuilder(
        future: getUserProfile(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return SpinKitDoubleBounce(
              color: kPrimaryColor,
            );
          storePhoneNo = snapshot.data['Name'];

          return SafeArea(
            child: ListView(children: [
              SizedBox(height: getProportionateScreenHeight(15)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Verify your CNIC',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Before you can Make an Offer, we will need to verify your CNIC, please upload below.',
                  style: TextStyle(
                      color: Colors.blueGrey, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        SizedBox(height: getProportionateScreenHeight(10)),
                        Text(
                          'CNIC front side Photo',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: kPrimaryColor,
                            child: Padding(
                              padding: EdgeInsets.all(1.5),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 400,
                                    height: 200,
                                    child: _cnicFrontPhoto != null
                                        ? ClipRRect(
                                            child:
                                                // Image.network(uRLString,
                                                // width: 130,
                                                //   height: 130,
                                                //   fit: BoxFit.cover,),
                                                Image.file(
                                              _cnicFrontPhoto,
                                              width: 400,
                                              height: 200,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                            ),
                                            width: 400,
                                            height: 200,
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        RaisedButton(
                          color: Colors.green,
                          child: Text('Upload'),
                          onPressed: () {
                            _cnicFrontSide();
                          },
                        ),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        Container(
                          height: 5,
                          color: hexColor,
                        ),
                        Text(
                          'CNIC back side Photo',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: kPrimaryColor,
                            child: Padding(
                              padding: EdgeInsets.all(1.5),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 400,
                                    height: 200,
                                    child: _cnicBackPhoto != null
                                        ? ClipRRect(
                                            child:
                                                // Image.network(uRLString,
                                                // width: 130,
                                                //   height: 130,
                                                //   fit: BoxFit.cover,),
                                                Image.file(
                                              _cnicBackPhoto,
                                              width: 400,
                                              height: 200,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                            ),
                                            width: 400,
                                            height: 200,
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        RaisedButton(
                          color: Colors.green,
                          child: Text('Upload'),
                          onPressed: () {
                            _cnicBackSide();
                          },
                        ),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        Container(
                          height: 5,
                          color: hexColor,
                        ),
                        Text(
                          'Upload your photo(For security verifications only)',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: kPrimaryColor,
                            child: Padding(
                              padding: EdgeInsets.all(1.5),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 400,
                                    height: 200,
                                    child: _userPic != null
                                        ? ClipRRect(
                                            child:
                                                // Image.network(uRLString,
                                                // width: 130,
                                                //   height: 130,
                                                //   fit: BoxFit.cover,),
                                                Image.file(
                                              _userPic,
                                              width: 400,
                                              height: 200,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                            ),
                                            width: 400,
                                            height: 200,
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'This photo will not be used as your profile photo',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                        RaisedButton(
                          color: Colors.green,
                          child: Text('Upload'),
                          onPressed: () {
                            _userPhoto();
                          },
                        ),
                        SizedBox(height: getProportionateScreenHeight(50)),
                        RaisedButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 170, vertical: 10),
                          color: kPrimaryColor,
                          child: Text('Submit'),
                          onPressed: () {
                            
                          },
                        ),
                        SizedBox(height: getProportionateScreenHeight(20)),
                      ],
                    ),
                  ),
                ],
              )
            ]),
          );
        },
      ),
    );
  }

  _cnicFrontSide() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _cnicFrontPhoto = image;
      // uploadProfilePic();
    });
  }
  _cnicBackSide() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _cnicBackPhoto = image;
      // uploadProfilePic();
    });
  }
  _userPhoto() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _userPic = image;
      // uploadProfilePic();
    });
  }
}
