import 'package:flutter/material.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/models/updateData.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/models/getData.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shop_app/constants.dart';


class EditProfileForm extends StatefulWidget {
  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  bool isLoading = true;

  String name;
  String phoneNo;
  String gender;
  String address;
  String about;
  String education;
  String specialities;
  String languages;
  String work;

  String storeName;
  String storePhoneNo;
  String storeGender;
  String storeAddress;
  String storeAbout;
  String storeEducation;
  String storeSpecialities;
  String storeLanguages;
  String storeWork;

  static const menuItems = <String>[
    'Male',
    'Female',
    'Other',
  ];
  final List<DropdownMenuItem<String>> popUpMenuItem = menuItems
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
    return FutureBuilder(
        future: GetData().getUserProfile(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
          return SpinKitDoubleBounce(color: kPrimaryColor,);
          storeName = snapshot.data['Name'];
          storePhoneNo = snapshot.data['Phone Number'];
          storeGender = snapshot.data['Gender'];
          storeAddress = snapshot.data['Address'];
          storeAbout = snapshot.data['About'];
          storeEducation = snapshot.data['Education'];
          storeSpecialities = snapshot.data['Specialities'];
          storeLanguages = snapshot.data['Languages'];
          storeWork = snapshot.data['Work'];
          return Form(
            key: _formKey,
            child: Column(
              children: [
                getNameFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                getGenderFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                getPhoneNoFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                getAddressFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                getAboutFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                getEducationFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                getSpecialitiesFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                getLanguagesFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                getWorkFormField(),
                FormError(errors: errors),
                SizedBox(height: getProportionateScreenHeight(40)),
                DefaultButton(
                  text: "Update Profile",
                  press: () async {
                    if (_formKey.currentState.validate()) {
                      UpdateData().updateUserProfile(context, name, gender, phoneNo, address,
                          about, education, specialities, languages, work);
                    }
                  },
                ),
                SizedBox(height: getProportionateScreenHeight(10)),
              ],
            ),
            
          );
        });
  }

  ///////////////////////////////////////////////////////////////////////////////
  TextFormField getNameFormField() {
    return TextFormField(
        initialValue: storeName,
        onSaved: (newValue) => name = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kNamelNullError);
            name = value;
          }else if(value == null) {
            storeName = value;
          }
          else{}
        },
        validator: (value) {
          if (value.isEmpty) {
            addError(error: kNamelNullError);
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Name",
          hintText: "Enter your name",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
        ),
      );
  }

  ///////////////////////////////////////////////////////////////////////////////

  TextFormField getPhoneNoFormField() {
    return TextFormField(
      initialValue: storePhoneNo,
      onSaved: (newValue) => phoneNo = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
          phoneNo = value;
        }else {
          storePhoneNo = value;
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone No",
        hintText: "Enter Phone No",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////

  DropdownButtonFormField getGenderFormField() {
    return DropdownButtonFormField(
      onSaved: (newValue) {
        gender = newValue;
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        gender = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Gender",
        hintText: "Select your gender",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/gender.svg"),
      ),
      items: popUpMenuItem,
    );
  }

  ///////////////////////////////////////////////////////////////////////////////

  Container getAddressFormField() {
    return Container(
      height: 150,
      child: TextFormField(
        expands: true,
        minLines: null,
        maxLines: null,
        initialValue: storeAddress,
        onSaved: (newValue) => address = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kAddressNullError);
            address = value;
          }else {
            storeAddress = value;
          }
        },
        validator: (value) {
          if (value.isEmpty) {
            addError(error: kAddressNullError);
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Address",
          hintText: "Enter your address",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon:
              CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////

  Container getAboutFormField() {
    return Container(
      height: 200,
      child: TextFormField(
        expands: true,
        minLines: null,
        maxLines: null,
        initialValue: storeAbout,
        onSaved: (newValue) => about = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kAboutNullError);
            about = value;
          }else {
            storeAbout = value;
          }
        },
        validator: (value) {
          if (value.isEmpty) {
            addError(error: kAboutNullError);
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "About",
          hintText: "Describe Yourself",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////

  TextFormField getEducationFormField() {
    return TextFormField(
      initialValue: storeEducation,
      onSaved: (newValue) => education = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEducationNullError);
          education = value;
        }else {
          storeEducation = value;
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEducationNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Education",
        hintText: "Enter your education",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////

  Container getSpecialitiesFormField() {
    return Container(
      height: 120,
      child: TextFormField(
        expands: true,
        minLines: null,
        maxLines: null,
        initialValue: storeSpecialities,
        onSaved: (newValue) => specialities = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kSkillsNullError);
          }
          if (value.isNotEmpty) {
            specialities = value;
          } else {
            storeSpecialities = value;
          }
        },
        validator: (value) {
          if (value.isEmpty) {
            addError(error: kSkillsNullError);
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Specialities",
          hintText: "Enter your specialities",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////

  TextFormField getLanguagesFormField() {
    return TextFormField(
      initialValue: storeLanguages,
      onSaved: (newValue) => languages = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kLanguagesNullError);
          languages = value;
        }else {
          storeLanguages = value;
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kLanguagesNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Languages",
        hintText: "Enter Your Languages",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////

  TextFormField getWorkFormField() {
    return TextFormField(
      initialValue: storeWork,
      onSaved: (newValue) => work = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kWorkNullError);
          work = value;
        } else {
          storeWork = value;
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kWorkNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Work",
        hintText: "What you do?",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
