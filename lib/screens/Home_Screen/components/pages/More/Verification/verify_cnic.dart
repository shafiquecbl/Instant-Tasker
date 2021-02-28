import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/setData.dart';
import 'package:shop_app/models/verify_email.dart';
import 'package:shop_app/size_config.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/widgets/alert_dialog.dart';
import 'package:shop_app/widgets/customAppBar.dart';

class VerifyCNIC extends StatefulWidget {
  static String routeName = "/verifycnic";
  @override
  _VerifyCNICState createState() => _VerifyCNICState();
}

class _VerifyCNICState extends State<VerifyCNIC> {
  final List<String> errors = [];
  File _cnicFrontPhoto;
  File _cnicBackPhoto;
  File _userPic;
  var fsURL;
  var bsURL;
  var uURL;

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Verify CNIC"),
      body: ListView(children: [
        SizedBox(height: getProportionateScreenHeight(15)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            'Verify your CNIC',
            style: TextStyle(
                color: greenColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            'Before you can Make an Offer, we will need to verify your CNIC, please upload below.',
            style:
                TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w600),
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
                        color: greenColor,
                        fontWeight: FontWeight.bold),
                  ),
                  cnicFSide(),
                  RaisedButton(
                    color: greenColor,
                    child: Text('Select'),
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
                        color: greenColor,
                        fontWeight: FontWeight.bold),
                  ),
                  cnicBSide(),
                  RaisedButton(
                    color: greenColor,
                    child: Text('Select'),
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
                        color: greenColor,
                        fontWeight: FontWeight.bold),
                  ),
                  userPhoto(),
                  Text(
                    'This photo will not be used as your profile photo',
                    style: TextStyle(
                        fontSize: 14,
                        color: greenColor,
                        fontWeight: FontWeight.bold),
                  ),
                  RaisedButton(
                    color: greenColor,
                    child: Text('Select'),
                    onPressed: () {
                      _userPhoto();
                    },
                  ),
                  SizedBox(height: getProportionateScreenHeight(40)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: FormError(errors: errors),
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  RaisedButton(
                    padding:
                        EdgeInsets.symmetric(horizontal: 170, vertical: 10),
                    color: kPrimaryColor,
                    child: Text('Submit'),
                    onPressed: () {
                      if (_cnicFrontPhoto == null ||
                          _cnicBackPhoto == null ||
                          _userPic == null) {
                        addError(error: "Please select all photos");
                      } else {
                        removeError(error: "Please select all photos");
                        showLoadingDialog(context);
                        upload();
                      }
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
  }

  cnicFSide() {
    return Padding(
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
                        child: Image.file(
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
    );
  }

  cnicBSide() {
    return Padding(
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
                        child: Image.file(
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
    );
  }

  userPhoto() {
    return Padding(
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
                        child: Image.file(
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
    );
  }

  _cnicFrontSide() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _cnicFrontPhoto = image;
    });
  }

  _cnicBackSide() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _cnicBackPhoto = image;
    });
  }

  _userPhoto() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _userPic = image;
    });
  }

  upload() async {
    final cnicFS =
        FirebaseStorage.instance.ref().child('CNIC/$email/CNICfrontSide.jpg');
    cnicFS.putFile(_cnicFrontPhoto);

    // ignore: unnecessary_cast
    fsURL = await cnicFS.getDownloadURL() as String;

    final cnicBS =
        FirebaseStorage.instance.ref().child('CNIC/$email/CNICbackSide.jpg');
    cnicBS.putFile(_cnicBackPhoto);

    // ignore: unnecessary_cast
    bsURL = await cnicBS.getDownloadURL() as String;

    final userP =
        FirebaseStorage.instance.ref().child('CNIC/$email/UserPhoto.jpg');
    userP.putFile(_userPic);

    // ignore: unnecessary_cast
    uURL = await userP.getDownloadURL() as String;
    SetData()
        .uploadCNICs(context, cnicFS: fsURL, cnicBS: bsURL, userPhoto: uURL);
  }
}
