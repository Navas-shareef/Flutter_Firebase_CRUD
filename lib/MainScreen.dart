import 'package:firebase_crud/allusers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                },
                child: const Text('Create User')),
            ElevatedButton(
                onPressed: () async {
                  final userKey = await getUserId();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllUsers(
                                userKey: userKey.toString(),
                              )));
                },
                child: const Text('View All Users')),
          ],
        ),
      ),
    );
  }
}

Future<String> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final userID = prefs.getString('currentuserid');

  return userID.toString();
}
