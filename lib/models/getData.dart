import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future getUserProfile() async {
  DocumentSnapshot document = await FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser.email)
      .get();
      return document;
  
}

Future getRequests() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("Buyer Requests").get();
    return snapshot.docs;
  }

  Future getUserRequests() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("Buyer Requests").where("Email",isEqualTo: FirebaseAuth.instance.currentUser.email).get();
    return snapshot.docs;
  }

  Future<String> getCNIC() async {
  DocumentSnapshot document = await FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser.email)
      .get();
       String getCNIC = document['CNIC'];
      return getCNIC;

}

Future getOffers(docID) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection("Buyer Requests")
      .doc(docID)
      .collection('Offers')
      .get();
  return snapshot.docs;
}

Future getMessages(receiverEmail) async{
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Messages')
      .doc(FirebaseAuth.instance.currentUser.email)
      .collection(receiverEmail).get();
      return snapshot.docs;
      
}

