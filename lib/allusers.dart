import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'models/users_model.dart';

class AllUsers extends StatelessWidget {
  const AllUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        backgroundColor: Colors.blueAccent,
      ),
      // body: FutureBuilder<User?>(
      //     future: readUser(),
      //     builder: (context, snapshot) {
      //       if (snapshot.hasData) {
      //         final user = snapshot.data;

      //         return user == null
      //             ? Center(
      //                 child: Text('No User'),
      //               )
      //             : buildUser(user);
      //       } else {
      //         return Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       }
      //     }),

      body: StreamBuilder<List<User>>(
        stream: readUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something Went Wrong '));
          } else if (snapshot.hasData) {
            final users = snapshot.data;
            return ListView(
              children: users!.map(buildUser).toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }
        },
      ),
    );
  }
}

Widget buildUser(User user) => ListTile(
      leading: CircleAvatar(
        child: Text('${user.age}'),
      ),
      title: Text(user.name),
      subtitle: Text(user.birthday),
    );

// read users
Stream<List<User>> readUsers() {
  return FirebaseFirestore.instance.collection('users').snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
}

// get single item
Future<User?> readUser() async {
  final docUser = FirebaseFirestore.instance
      .collection('users')
      .doc('9nbHQAHrYxuFI2wfFCqT');
  final snapshot = await docUser.get();
  if (snapshot.exists) {
    return User.fromJson(snapshot.data()!);
  }
}
