import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/getData.dart';
import 'package:shop_app/models/verify_email.dart';
import 'package:shop_app/screens/otp/otp_screen.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/More/Verification/verify_cnic.dart';
import 'package:shop_app/widgets/customAppBar.dart';

class Verifications extends StatefulWidget {
  @override
  _VerificationsState createState() => _VerificationsState();
}

class _VerificationsState extends State<Verifications> {
  String phoneNo;
  String cnic;
  String email = FirebaseAuth.instance.currentUser.email;
  String verificationCode;
  String smsCode;
  FirebaseAuth _auth = FirebaseAuth.instance;

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
          phoneNo = snapshot.data['Phone Number'];
          cnic = snapshot.data['CNIC Status'];

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
                      subtitle: Text(phoneNo),
                      trailing: RaisedButton(
                          child: Text(auth.currentUser.phoneNumber == null
                              ? 'Verify'
                              : 'Verified'),
                          textColor: kWhiteColor,
                          color: kPrimaryColor.withOpacity(0.9),
                          onPressed: auth.currentUser.phoneNumber == null
                              ? () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          OtpScreen(phoneNo: phoneNo)))
                              : null),
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
                          child: Text(cnic == 'Submitted'
                              ? 'Submitted'
                              : cnic == 'verified'
                                  ? 'Verified'
                                  : 'Verify'),
                          textColor: kWhiteColor,
                          color: kPrimaryColor.withOpacity(0.9),
                          onPressed: cnic == "Submitted"
                              ? null
                              : cnic == "verified"
                                  ? null
                                  : () => Navigator.pushNamed(
                                      context, VerifyCNIC.routeName)),
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
}
