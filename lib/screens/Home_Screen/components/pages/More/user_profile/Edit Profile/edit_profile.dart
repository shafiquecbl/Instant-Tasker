import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/size_config.dart';
import 'edit_profile_form.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        shadowColor: kPrimaryColor,
        backgroundColor: hexColor,
        automaticallyImplyLeading: false,
        title: Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              "Edit Profile",
              style: GoogleFonts.teko(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )),
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: kPrimaryColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.grey[100],
          )
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  Text("Profile Info",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 19,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  EditProfileForm()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
