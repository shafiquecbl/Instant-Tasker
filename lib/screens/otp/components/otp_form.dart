import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/widgets/alert_dialog.dart';
import 'package:shop_app/widgets/snack_bar.dart';

import '../../../constants.dart';

class OtpForm extends StatefulWidget {
  final String phoneNo;
  OtpForm({@required this.phoneNo});

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  String verificationCode;
  String smsCode;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final List<String> errors = [];

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
  void initState() {
    super.initState();
    setState(() {
      SchedulerBinding.instance
          .addPostFrameCallback((_) => {showLoadingDialog(context), verify()});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.10),
          Center(
            child: SizedBox(
              width: getProportionateScreenWidth(200),
              child: TextFormField(
                maxLength: 6,
                style: TextStyle(fontSize: 24, color: Colors.white),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: otpInputDecoration,
                onChanged: (value) async {
                  smsCode = value;
                },
              ),
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.05),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 125),
            child: FormError(errors: errors),
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.05),
          DefaultButton(
            text: "Verify Code",
            press: () async {
              try {
                removeError(error: "Invalid OTP");
                AuthCredential authCreds = PhoneAuthProvider.credential(
                    verificationId: verificationCode, smsCode: smsCode);
                await FirebaseAuth.instance.currentUser
                    .linkWithCredential(authCreds)
                    .whenComplete(() => Navigator.maybePop(context));
              } catch (e) {
                addError(error: "Invalid OTP");
              }
            },
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.10),
          GestureDetector(
            onTap: () {
              showLoadingDialog(context);
              verify();
            },
            child: Text(
              "Resend OTP Code",
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          )
        ],
      ),
    );
  }

  verify() async {
    await _auth.verifyPhoneNumber(
        phoneNumber: widget.phoneNo,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.currentUser
              .linkWithCredential(credential);
          print("Phone Number verified");
        },
        verificationFailed: (FirebaseAuthException error) {
          Navigator.pop(context);
          Snack_Bar.show(context, error.message);
        },
        codeSent: (String verificationId, int resendToken) async {
          Navigator.maybePop(context);
          setState(() {
            verificationCode = verificationId;
          });
        },
        timeout: const Duration(seconds: 120),
        codeAutoRetrievalTimeout: (String verificationId) {
          print(verificationId);
          setState(() {
            verificationCode = verificationId;
          });
        });
  }
}
