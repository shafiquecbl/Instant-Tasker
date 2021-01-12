import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

final auth = FirebaseAuth.instance;
User user = auth.currentUser;
final email = user.email;
String uid = user.uid.toString();
String name = user.displayName;
DateTime now = DateTime.now();
String dateTime = DateFormat("dd-MM-yyyy h:mma").format(now);

Future addMessage(receiverEmail,senderName,senderPhotoURL,message) async{
  await FirebaseFirestore.instance.collection('Messages').doc(email).collection(receiverEmail).add({
    'Name': senderName,
    'Email': email,
    'PhotoURL': senderPhotoURL,
    'Time': dateTime,
    'Message': message,
    'Type': "text",
  });

  return await FirebaseFirestore.instance.collection('Messages').doc(receiverEmail).collection(email).add({
    'Name': senderName,
    'Email': email,
    'PhotoURL': senderPhotoURL,
    'Time': dateTime,
    'Message': message,
    'Type': "text",
  });
}