import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:shop_app/screens/Home_Screen/home_screen.dart';
import 'package:shop_app/widgets/snack_bar.dart';

class UpdateData {
  User user = FirebaseAuth.instance.currentUser;
  final email = FirebaseAuth.instance.currentUser.email;

  Future<User> saveUserProfile(context, name, gender, phNo, address) async {
    double doubleValue = 0;
    int intValue = 0;
    final CollectionReference users =
        FirebaseFirestore.instance.collection('Users');
    users
        .doc(email)
        .update(
          {
            'Name': name,
            'Phone Number': phNo,
            'Gender': gender,
            'Address': address,
            'PhotoURL': "",
            'Phone Number status': "Not Verified",
            'Rating as Seller': doubleValue,
            'Rating as Buyer': doubleValue,
            'Reviews as Buyer': intValue,
            'Reviews as Seller': intValue,
            'Completion Rate': intValue,
            'Completed Task': intValue,
            'About': "",
            'Education': "",
            'Specialities': "",
            'Languages': "",
            'Work': "",
            'CNIC Status': "Not Verified",
            'Payment Status': "Not Verified",
            'CNIC': "Not Available",
            "Payment Method": "Not Available",
          },
        )
        .then((value) =>
            Navigator.pushReplacementNamed(context, MainScreen.routeName))
        .catchError((e) {
          Snack_Bar.show(context, e.message);
        });
    return null;
  }

  //////////////////////////////////////////////////////////////////////////////////////////

  Future<User> updateUserProfile(context, name, gender, phNo, address, about,
      education, specialities, languages, work) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('Users');
    users
        .doc(email)
        .update(
          {
            'Name': name,
            'Phone Number': phNo,
            'Gender': gender,
            'Address': address,
            'About': about,
            'Education': education,
            'Specialities': specialities,
            'Languages': languages,
            'Work': work,
          },
        )
        .then(
          (value) => Snack_Bar.show(context, "Profile Successfully Updated!"),
        )
        .catchError((e) {
          Snack_Bar.show(context, e.message);
        });
    return null;
  }

  //////////////////////////////////////////////////////////////////////////////////////////

  Future<User> updateProfilePicture(context, uRL) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('Users');
    users
        .doc(email)
        .update(
          {
            'PhotoURL': uRL,
          },
        )
        .then(
          (value) => print('Profile Picture Successfully Updated'),
        )
        .catchError((e) {
          print(e.message);
        });
    return null;
  }

  Future updateOrderStatus(receiverDocID, docID, receiverEmail) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .collection('Assigned Tasks')
        .doc(receiverDocID)
        .update({'Status': "Submitted"});

    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection("Orders")
        .doc(docID)
        .update({'Status': "Waiting for rating"});
  }

  Future orderRevesion(receiverDocID, docID, receiverEmail) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection("Assigned Tasks")
        .doc(docID)
        .update({'Status': "Revision"});

    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .collection('Orders')
        .doc(receiverDocID)
        .update({'Status': "Revision"});
  }
}
