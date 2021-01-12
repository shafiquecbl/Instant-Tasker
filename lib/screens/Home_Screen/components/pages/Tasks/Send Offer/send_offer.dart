import 'package:flutter/material.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Tasks/Send%20Offer/send_offer_form.dart';
import 'package:shop_app/size_config.dart';

class SendOffer extends StatefulWidget {
  final String docID;
  SendOffer(this.docID);
  @override
  _SendOfferState createState() => _SendOfferState();
}

class _SendOfferState extends State<SendOffer> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Offer"),
      ),
      body:  SafeArea(
          child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                SendOfferForm(widget.docID),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}