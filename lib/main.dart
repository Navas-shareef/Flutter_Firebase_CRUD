import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crud/models/users_model.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controllerName = TextEditingController();
  final controllerAge = TextEditingController();
  final controllerDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextField(
              controller: controllerName,
              decoration: const InputDecoration(
                  labelText: 'Name',
                  contentPadding: const EdgeInsets.only(bottom: 0)),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: controllerAge,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Age',
                contentPadding: EdgeInsets.only(bottom: 0),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: controllerDate,
              decoration: const InputDecoration(
                  labelText: 'DOB',
                  contentPadding: const EdgeInsets.only(bottom: 0)),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () {
                  final user = User(
                      name: controllerName.text,
                      age: int.parse(controllerAge.text),
                      birthday: controllerDate.text);
                  CreateUser(user: user);
                },
                child: const Text('Create'))
          ],
        ),
      ),
    );
  }
}

Future CreateUser({required User user}) async {
  // Reference to Document
  final docUser = FirebaseFirestore.instance.collection('users').doc();

  user.id = docUser.id;

// Create document and write data to Firebase
  await docUser.set(user.toJson());
}
