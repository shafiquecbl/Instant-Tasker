import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:shop_app/screens/complete_profile/complete_profile_screen.dart';
import 'package:shop_app/widgets/snack_bar.dart';
import 'package:intl/intl.dart';

class SetData {
  final User user = FirebaseAuth.instance.currentUser;
  final email = FirebaseAuth.instance.currentUser.email;
  String uid = FirebaseAuth.instance.currentUser.uid.toString();
  String name = FirebaseAuth.instance.currentUser.displayName;
  String dateTime = DateFormat("dd-MM-yyyy h:mma").format(DateTime.now());
  FieldValue fieldValue = FieldValue.serverTimestamp();

  Future saveNewUser(email, context) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('Users');
    users
        .doc(email)
        .set({
          'Email': email,
          'Uid': uid,
          'Email status': "Verified",
        })
        .then((value) =>
            Navigator.pushNamed(context, CompleteProfileScreen.routeName))
        .catchError((e) {
          print(e);
        });
  }

///////////////////////////////////////////////////////////////////////////////////////

  Future postTask(
      context, description, category, duration, budget, location) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('Buyer Requests');
    users.doc().set(
      {
        'Email': email,
        'Name': name,
        'Time': dateTime,
        'Description': description,
        'Location': location,
        'Budget': budget,
        'Duration': duration,
        'Category': category,
        'PhotoURL': user.photoURL
      },
    ).then((value) {
      Navigator.pop(context);
      Snack_Bar.show(context, "Task Posted Sussessfully");
    });
  }

////////////////////////////////////////////////////////////////////////////////////

  Future sendOffer(
    context,
    docID,
    description,
    duration,
    budget,
  ) async {
    final CollectionReference users = FirebaseFirestore.instance
        .collection('Buyer Requests')
        .doc(docID)
        .collection('Offers');
    users.doc().set(
      {
        'Name': name,
        'Email': email,
        'Time': dateTime,
        'Description': description,
        'Budget': budget,
        'Duration': duration,
        'PhotoURL': user.photoURL,
      },
    ).then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
      Snack_Bar.show(context, "Offer sent Sussessfully");
    }).catchError((e) {
      Snack_Bar.show(context, e.message);
    });
  }

  // Future sendOffer(
  //     context,
  //     docID,
  //     description,
  //     duration,
  //     budget,
  //     double sellerRating,
  //     sellerReviews,
  //     completetionRate,
  //     emailStatus,
  //     phoneNoStatus,
  //     paymentStatus,
  //     cnicStatus) async {
  //   final CollectionReference users = FirebaseFirestore.instance
  //       .collection('Buyer Requests')
  //       .doc(docID)
  //       .collection('Offers');
  //   users.doc().set(
  //     {
  //       'Name': name,
  //       'Email': email,
  //       'Time': dateTime,
  //       'Description': description,
  //       'Budget': budget,
  //       'Duration': duration,
  //       'PhotoURL': user.photoURL,
  //       'Seller Rating': sellerRating,
  //       'Seller Reviews': sellerReviews,
  //       'Completetion Rate': completetionRate,
  //       'Email Status': emailStatus,
  //       'Phone No Status': phoneNoStatus,
  //       'Payment Status': paymentStatus,
  //       'CNIC Status': cnicStatus,
  //     },
  //   ).then((value) {
  //     Navigator.pop(context);
  //     Navigator.pop(context);
  //     Snack_Bar.show(context, "Offer sent Sussessfully");
  //   }).catchError((e) {
  //     Snack_Bar.show(context, e.message);
  //   });
  // }

  Future assignTask(context, description, category, duration, budget, location,
      receiverEmail, receiverPhoto, receiverName) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .collection('Orders')
        .add({
      'Client Email': email,
      'Client Name': name,
      'Time': dateTime,
      'Description': description,
      'Location': location,
      'Budget': budget,
      'Duration': duration,
      'Category': category,
      'Client PhotoURL': user.photoURL,
      'Status': "Pending",
      'TOstatus': "Active",
    });

    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection("Assigned Tasks")
        .add({
      'Seller Email': receiverEmail,
      'Seller Name': receiverName,
      'Time': dateTime,
      'Description': description,
      'Location': location,
      'Budget': budget,
      'Duration': duration,
      'Category': category,
      'Seller PhotoURL': receiverPhoto,
      'Status': "Pending",
      'TOstatus': "Active",
    });
  }

  Future sumbitOrder(receiverDocID, docID, description, receiverEmail) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .collection('Assigned Tasks')
        .doc(receiverDocID)
        .collection("Received Work")
        .add({
      'Time': dateTime,
      'Description': description,
      'timestamp': fieldValue,
    });

    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection("Orders")
        .doc(docID)
        .collection("Submitted Work")
        .add({
      'Time': dateTime,
      'Description': description,
      'timestamp': fieldValue,
    });
  }

  Future uploadCNICs(context,
      {@required cnicFS, @required cnicBS, @required userPhoto}) async {
    await FirebaseFirestore.instance.collection('CNIC').doc(email).set({
      'CNIC FS': cnicFS,
      'CNIC BS': cnicBS,
      'User Photo': userPhoto,
    });

    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .update({'CNIC Status': "Submitted"}).then(
            (value) => Navigator.pop(context));
  }
}
