import 'package:flutter/material.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/More/Manage%20Orders/Submit%20Order/submit_order_form.dart';
import 'package:shop_app/size_config.dart';

class SubmitOrder extends StatefulWidget {
  final String docID;
  SubmitOrder(this.docID);
  @override
  _SubmitOrderState createState() => _SubmitOrderState();
}

class _SubmitOrderState extends State<SubmitOrder> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Submit Order"),
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
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  SubmitOrderForm(widget.docID),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
