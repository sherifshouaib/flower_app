import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ImgUser extends StatefulWidget {
  const ImgUser({super.key});

  @override
  State<ImgUser> createState() => _ImgUserState();
}

class _ImgUserState extends State<ImgUser> {
  CollectionReference users = FirebaseFirestore.instance.collection('userSSS');

  final credential = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('userSSS');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(credential!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

//${data['title']}

          return CircleAvatar(
            backgroundColor: Color.fromARGB(255, 225, 225, 225),
            radius: 71,
            //backgroundImage: AssetImage('assets/images/avatar.png'),
            backgroundImage: NetworkImage(data['imgLink']),
          );
        }

        return Text("loading");
      },
    );
  }
}
