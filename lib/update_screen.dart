import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'models/users_model.dart';

class UpdateItemScreen extends StatefulWidget {
  const UpdateItemScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<UpdateItemScreen> createState() => _UpdateItemScreenState();
}

final controllerName = TextEditingController();
final controllerAge = TextEditingController();
final controllerDate = TextEditingController();

class _UpdateItemScreenState extends State<UpdateItemScreen> {
  @override
  void initState() {
    controllerName.text = widget.user.name;
    controllerAge.text = widget.user.age.toString();
    controllerDate.text = widget.user.birthday;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update User'),
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
                  updateItem(widget.user.id, controllerName.text,
                          int.parse(controllerAge.text), controllerDate.text)
                      .then((value) => Navigator.pop(context));
                },
                child: const Text('Create'))
          ],
        ),
      ),
    );
  }
}

Future<void> updateItem(String userid, String name, int age, String dob) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc(userid);
  await docUser.update({'name': name, 'age': age, 'birthday': dob});
}
