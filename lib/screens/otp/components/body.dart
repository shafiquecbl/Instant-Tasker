import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/size_config.dart';
import 'otp_form.dart';

class Body extends StatefulWidget {
  final String phoneNo;
  Body({@required this.phoneNo});
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.05),
              Text(
                "OTP Verification",
                style: headingStyle,
              ),
              Text("We sent your code to ${widget.phoneNo}"),
              OtpForm(phoneNo: widget.phoneNo),
            ],
          ),
        ),
      ),
    );
  }
}
