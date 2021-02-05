import 'package:flutter/material.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/setData.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/widgets/outline_input_border.dart';
import 'package:shop_app/widgets/snack_bar.dart';

class PostTaskForm extends StatefulWidget {
  @override
  _PostTaskFormState createState() => _PostTaskFormState();
}

class _PostTaskFormState extends State<PostTaskForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  bool isVisible = false;

  String description;
  String category;
  String duration;
  String budget;
  String location;

  int radioValue = 1;
  void handleRadioValueChanged(int value) {
    setState(() {
      radioValue = value;
      if (radioValue == 0)
        isVisible = true;
      else
        isVisible = false;
    });
  }

  static const categories = <String>[
    'Pickup Delivery',
    'Electrician',
    'Ac Service',
    'Plumber',
    'Cleaning',
    'Grapgic Designer',
    'Software Developer',
    'Painter',
    'Handyman',
    'Carpenter',
    'Car Washer',
    'Gerdener',
    'Photo Graphers',
    'Moving',
    'Tailor',
    'Beautician',
    'Drivers and Cab',
    'Lock Master',
    'Labor',
    'Domestic help',
    'Event Planner',
    'Cooking Services',
    'Consultant',
    'Digital Marketing',
    'Mechanic',
    'Welder',
    'Tutors/Teachers',
    'Fitness Trainer',
    'Repairing',
    'UI/UX Designer',
    'Video and  Audio Editors',
    'Interior Designer',
    'Architect',
    'Pest Control',
    'Lawyers/Legal Advisors',
    'Other',
  ];

  final List<DropdownMenuItem<String>> popUpcategories = categories
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

  static const durations = <String>[
    '1 Day',
    '2 Days',
    '3 Days',
    '4 Days',
    '5 Days',
    '6 Days',
    '7 Days',
    '8 Days',
    '9 Days',
    '10 Days',
    '11 Days',
    '12 Days',
    '13 Days',
    '14 Days',
    '15 Days',
    '16 Days',
    '17 Days',
    '18 Days',
    '19 Days',
    '20 Days',
    '21 Days',
    '22 Days',
    '23 Days',
    '24 Days',
    '25 Days',
    '26 Days',
    '27 Days',
    '28 Days',
    '29 Days',
    '30 Days',
  ];
  final List<DropdownMenuItem<String>> popUpdurations = durations
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          getDescriptionFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          getCategoriesFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          getDurationFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          getBudgetFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.pin_drop_outlined),
                Radio(
                  value: 0,
                  groupValue: radioValue,
                  onChanged: handleRadioValueChanged,
                ),
                Text(
                  'Physical',
                  style: new TextStyle(fontSize: 16.0),
                ),
                SizedBox(
                  width: 50,
                ),
                Icon(Icons.online_prediction_outlined),
                Radio(
                  value: 1,
                  groupValue: radioValue,
                  onChanged: handleRadioValueChanged,
                ),
                Text(
                  'Online',
                  style: new TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          if (isVisible == true) getLocationFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Post Task",
            press: () async {
              if (_formKey.currentState.validate()) {
                try {
                  if (location == null) location = "Online";
                  SetData().postTask(context, description, category, duration,
                      budget, location);
                } catch (e) {
                  Snack_Bar.show(context, e.message);
                }
              }
            },
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
        ],
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////

  DropdownButtonFormField getCategoriesFormField() {
    return DropdownButtonFormField(
      onSaved: (newValue) {
        category = newValue;
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kCategoryNullError);
        }
        category = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kCategoryNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Category",
        hintText: "Select category",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.category_outlined),
        border: rectangularBorder,
      ),
      items: popUpcategories,
    );
  }

  ///////////////////////////////////////////////////////////////////////////////

  DropdownButtonFormField getDurationFormField() {
    return DropdownButtonFormField(
      onSaved: (newValue) {
        duration = newValue;
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kdurationNullError);
        }
        duration = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kdurationNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Duration",
        hintText: "Select duration",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.view_day_sharp),
        border: rectangularBorder,
      ),
      items: popUpdurations,
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
          hintText: "Enter task description",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.description_outlined),
          border: rectangularBorder,
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////

  TextFormField getBudgetFormField() {
    return TextFormField(
      onSaved: (newValue) => budget = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kbudgetNullError);
          budget = value;
        } else {}
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kbudgetNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Budget (Rs.)",
        hintText: "Enter your budget (Rs.)",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.attach_money),
        border: rectangularBorder,
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////

  TextFormField getLocationFormField() {
    return TextFormField(
      // readOnly: ,
      onSaved: (newValue) => location = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kbudgetNullError);
          location = value;
        } else {}
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kbudgetNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Location",
        hintText: "Enter your Location",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
        border: rectangularBorder,
      ),
    );
  }
}
