import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:shop_app/screens/complete_profile/complete_profile_screen.dart';
import 'package:shop_app/widgets/snack_bar.dart';
import 'package:intl/intl.dart';

class SetData{
final User user = FirebaseAuth.instance.currentUser;
final email = FirebaseAuth.instance.currentUser.email;
String uid = FirebaseAuth.instance.currentUser.uid.toString();
String name = FirebaseAuth.instance.currentUser.displayName;
static DateTime now = DateTime.now();
String dateTime = DateFormat("dd-MM-yyyy h:mma").format(now);

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
      .then((value) => Navigator.pushReplacementNamed(
          context, CompleteProfileScreen.routeName))
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
      'docID': users.doc().id,
      'Email': email,
      'Time': dateTime,
      'Description': description,
      'Location': location,
      'Budget': budget,
      'Duration': duration,
      'Category': category,
      'PhotoURL': user.photoURL
    },
  ).then((value) {
    String message = "Task Post Sussessfully";
    Snack_Bar.show(context, message);
  }).catchError((e) {
    Snack_Bar.show(context, e.message);
  });
}

////////////////////////////////////////////////////////////////////////////////////

Future sendOffer(
    context,
    docID,
    description,
    duration,
    budget,
    double sellerRating,
    sellerReviews,
    completetionRate,
    emailStatus,
    phoneNoStatus,
    paymentStatus,
    cnicStatus) async {
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
      'Seller Rating': sellerRating,
      'Seller Reviews': sellerReviews,
      'Completetion Rate': completetionRate,
      'Email Status': emailStatus,
      'Phone No Status': phoneNoStatus,
      'Payment Status': paymentStatus,
      'CNIC Status': cnicStatus,
    },
  ).then((value) {
    String message = "Offer sent Sussessfully";
    Snack_Bar.show(context, message);
    Navigator.of(context).pop();
  }).catchError((e) {
    Snack_Bar.show(context, e.message);
  });
}

 sendMessage(receiverEmail,receiverName,receiverPhotoURL,isOnline) {
  final CollectionReference messages = FirebaseFirestore.instance
      .collection('Messages')
      .doc(email)
      .collection('Inbox');
      messages.doc(receiverEmail).set({
        'Name': receiverName,
        'PhotoURL': receiverPhotoURL,
        'Online Status': isOnline,
      });
}
}