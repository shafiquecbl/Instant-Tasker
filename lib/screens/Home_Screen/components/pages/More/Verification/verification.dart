import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/getData.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/More/Verification/verify_cnic.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/widgets/customAppBar.dart';

class Verifications extends StatefulWidget {
  @override
  _VerificationsState createState() => _VerificationsState();
}

class _VerificationsState extends State<Verifications> {
  String storePhoneNo;
  String email = FirebaseAuth.instance.currentUser.email;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: customAppBar("Verification"),
      body: FutureBuilder(
        future: GetData().getUserProfile(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return SpinKitCircle(
              color: kPrimaryColor,
            );
          storePhoneNo = snapshot.data['Phone Number'];

          return SafeArea(
            child: ListView(children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    SizedBox(height: getProportionateScreenHeight(10)),
                    Text(
                      "Verifications help you to increase your chances of getting selected. People will trust you if you have verified badges on your profile.",
                      style: TextStyle(
                          color: Colors.blueGrey, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    Text(
                      'Verifications are issued when specific requirements are met. A green tick shows thay the verifications is currently active.',
                      style: TextStyle(
                          color: Colors.blueGrey, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: getProportionateScreenHeight(15)),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'ID Verifications',
                  style: TextStyle(
                      color: greenColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Column(
                children: [
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: Icon(Icons.email_outlined, color: kPrimaryColor),
                      title: Text("Email"),
                      subtitle: Text(email),
                      trailing: RaisedButton(
                          child: Text('Verified'),
                          textColor: kWhiteColor,
                          onPressed: null),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: Icon(Icons.phone, color: kPrimaryColor),
                      title: Text("Phone"),
                      subtitle: Text(storePhoneNo),
                      trailing: RaisedButton(
                          child: Text('Verify'),
                          textColor: kWhiteColor,
                          color: kPrimaryColor.withOpacity(0.9),
                          onPressed: () {
                            addMediaModal(context);
                          }),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: Icon(Icons.perm_identity_outlined,
                          color: kPrimaryColor),
                      title: Text("CNIC"),
                      subtitle: Text(
                        'Give members a reason to choose you - knowing that your identity is verified with NADRA CNIC',
                        style: TextStyle(fontSize: 11.5),
                      ),
                      trailing: RaisedButton(
                          child: Text('Verify'),
                          textColor: kWhiteColor,
                          color: kPrimaryColor.withOpacity(0.9),
                          onPressed: () {
                            Navigator.pushNamed(context, VerifyCNIC.routeName);
                          }),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading:
                          Icon(Icons.payment_outlined, color: kPrimaryColor),
                      title: Text("Payment Method"),
                      subtitle: Text(
                        'Make payments with ease by having your payment method verified',
                        style: TextStyle(fontSize: 11.5),
                      ),
                      trailing: RaisedButton(
                          child: Text('Add'),
                          textColor: kWhiteColor,
                          color: kPrimaryColor.withOpacity(0.9),
                          onPressed: () {}),
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

  // Bottom Sheet Starts
  addMediaModal(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        elevation: 0,
        backgroundColor: UniversalVariables.blackColor,
        builder: (context) {
          return SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.05),
                    Text(
                      "OTP Verification",
                      style: otp,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("We sent code to "),
                        Text(
                          storePhoneNo,
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ],
                    ),
                    Form(
                      child: Column(
                        children: [
                          SizedBox(height: SizeConfig.screenHeight * 0.10),
                          Center(
                            child: SizedBox(
                              width: getProportionateScreenWidth(200),
                              child: TextFormField(
                                maxLength: 6,
                                autofocus: true,
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: otpInputDecoration,
                                onChanged: (value) {
                                  // smsCode = value;
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: SizeConfig.screenHeight * 0.10),
                          DefaultButton(
                            text: "Verify Code",
                            press: () {},
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.05),
                    GestureDetector(
                      onTap: () {
                        // OTP code resend
                      },
                      child: Text(
                        "Resend OTP Code",
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.12),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
