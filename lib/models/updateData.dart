import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shop_app/screens/Home_Screen/home_screen.dart';
import 'package:shop_app/widgets/snack_bar.dart';
import 'package:intl/intl.dart';

class UpdateData {
  User user = FirebaseAuth.instance.currentUser;
  final email = FirebaseAuth.instance.currentUser.email;
  String dateTime = DateFormat("dd-MM-yyyy h:mma").format(DateTime.now());

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
            'Completed Task as Buyer': intValue,
            'Cancelled Task': intValue,
            'Total Task': intValue,
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
        .then((value) => Navigator.pushNamed(context, MainScreen.routeName))
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
          (value) => {
            Navigator.pop(context),
            Snack_Bar.show(context, "Profile Successfully Updated!")
          },
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
        .update({'Status': "Waiting for rating"});

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

  Future completeOrder(receiverDocID, docID, receiverEmail, cTask, cRate,
      revSeller, double ratSeller, double rating, totalTasks, review) async {
    int comTask = (cTask + 1);
    int totTask = (totalTasks + 1);
    double comRate = (comTask / totTask) * 100;
    int reviewsSeller = (revSeller + 1);
    double rating1 = ((rating + ratSeller) / comTask);

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection("Assigned Tasks")
        .doc(docID)
        .update(
            {'Status': "Completed", 'TOstatus': "Completed", 'Time': dateTime});

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .collection('Orders')
        .doc(receiverDocID)
        .update(
            {'Status': "Completed", 'TOstatus': "Completed", 'Time': dateTime});

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .update({
      'Total Task': totTask,
      'Completed Task': comTask,
      'Completion Rate': comRate,
      'Reviews as Seller': reviewsSeller,
      'Rating as Seller': rating1,
    });

    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .collection('Reviews')
        .doc()
        .set({
      'Review': review,
      'Name': user.displayName,
    });
  }

  Future submitReview(
      {@required receiverEmail,
      @required cTask,
      @required revBuyer,
      @required double ratBuyer,
      @required double rating,
      @required review}) async {
    int comTask = (cTask + 1);
    int reviewsSeller = (revBuyer + 1);
    double rating1 = ((rating + revBuyer) / comTask);

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .update({
      'Completed Task as Buyer': comTask,
      'Reviews as Buyer': reviewsSeller,
      'Rating as Buyer': rating1,
    });

    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .collection('Reviews')
        .doc()
        .set({
      'Review': review,
      'Name': user.displayName,
      'Email': user.email,
      'PhotoURL': user.photoURL,
      'Time': dateTime
    }).then((value) => Snack_Bar(message: "Review Submitted!"));
  }

  Future cancelOrder(context,
      {@required orderID,
      @required taskID,
      @required receiverEmail,
      @required completedTask,
      @required cancelledTask,
      @required totalTasks,
      @required reason}) async {
    int canTask = (cancelledTask + 1);
    int totTask = (totalTasks + 1);
    double comRate = (completedTask / totTask) * 100;

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection("Assigned Tasks")
        .doc(taskID)
        .update({
      'Status': "Cancelled",
      'TOstatus': "Cancelled",
      'Reason': reason,
      'Time': dateTime
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .collection('Orders')
        .doc(orderID)
        .update({
      'Status': "Cancelled",
      'TOstatus': "Cancelled",
      'Reason': reason,
      'Time': dateTime
    });

    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .update({
      'Total Task': totTask,
      'Cancelled Task': canTask,
      'Completion Rate': comRate,
    }).then((value) => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => MainScreen())),
              Snack_Bar(message: "Order Cancelled!")
            });
  }

  Future updateMessageStatus(receiverEmail) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection('Contacts')
        .doc(receiverEmail)
        .update({'Status': "read"});
  }
}
