import 'package:flutter/material.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/models/getData.dart';

class SubmitOrderForm extends StatefulWidget {
  final String docID;
  SubmitOrderForm(this.docID);
  @override
  _SubmitOrderFormState createState() => _SubmitOrderFormState();
}

class _SubmitOrderFormState extends State<SubmitOrderForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  String description;

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
    return FutureBuilder(
      initialData: [],
      future: GetData().getUserProfile(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              getDescriptionFormField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              FormError(errors: errors),
              SizedBox(height: getProportionateScreenHeight(30)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: DefaultButton(
                  text: "Submit Order",
                  press: () async {
                    if (_formKey.currentState.validate()) {}
                  },
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(30)),
            ],
          ),
        );
      },
    );
  }

  ///////////////////////////////////////////////////////////////////////////////

  Container getDescriptionFormField() {
    return Container(
      height: 200,
      child: TextFormField(
        expands: true,
        minLines: null,
        maxLines: null,
        onSaved: (newValue) => description = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kDescriptionNullError);
            description = value;
          } else {}
        },
        validator: (value) {
          if (value.isEmpty) {
            addError(error: kDescriptionNullError);
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Decription",
          hintText: "Add a description to\nyour order",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.description_outlined),
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////

}
