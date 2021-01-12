import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetData{
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final email = FirebaseAuth.instance.currentUser.email;
String uid = FirebaseAuth.instance.currentUser.uid.toString();
String name = FirebaseAuth.instance.currentUser.displayName;

Future getUserProfile() async {
  DocumentSnapshot document = await firestore
      .collection('Users')
      .doc(email)
      .get();
      return document;
  
}

Future getRequests() async {
    QuerySnapshot snapshot =
        await firestore.collection("Buyer Requests").get();
    return snapshot.docs;
  }

  Future getUserRequests() async {
    QuerySnapshot snapshot =
        await firestore.collection("Buyer Requests").where("Email",isEqualTo: email).get();
    return snapshot.docs;
  }

  Future<String> getCNIC() async {
  DocumentSnapshot document = await firestore
      .collection('Users')
      .doc(email)
      .get();
       String getCNIC = document['CNIC'];
      return getCNIC;

}

Future getOffers(docID) async {
  QuerySnapshot snapshot = await firestore
      .collection("Buyer Requests")
      .doc(docID)
      .collection('Offers')
      .get();
  return snapshot.docs;
}

Future getMessages(receiverEmail) async{
  QuerySnapshot snapshot = await firestore
      .collection('Messages')
      .doc(email)
      .collection(receiverEmail).get();
      return snapshot.docs;
      
}

}