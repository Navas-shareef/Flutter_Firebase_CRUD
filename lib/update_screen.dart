import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'models/users_model.dart';
import 'snackbar.dart';

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

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update User'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              TextFormField(
                validator: (value) =>
                    value != null && value.isEmpty ? 'Enter name' : null,
                controller: controllerName,
                decoration: const InputDecoration(
                    labelText: 'Name',
                    contentPadding: const EdgeInsets.only(bottom: 0)),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                validator: (value) =>
                    value != null && value.isEmpty ? 'Enter age' : null,
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
              TextFormField(
                validator: (value) => value != null && value.isEmpty
                    ? 'Enter date of birth'
                    : null,
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
                    final form = formKey.currentState!;
                    if (form.validate()) {
                      widget.user.age = int.parse(controllerAge.text);
                      widget.user.name = controllerName.text;
                      widget.user.birthday = controllerDate.text;
                      updateItem(widget.user)
                          .then((value) => Navigator.pop(context));
                      final snackbar =
                          displaySnackbar(context, 'Successfully Updated');
                    } else {
                      final snackbar =
                          displaySnackbar(context, 'Pls fill details');
                    }
                  },
                  child: const Text('Update'))
            ],
          ),
        ),
      ),
    );
  }
}

// function to update item
Future<void> updateItem(User user) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc(user.id);
  await docUser.update(user.toJson());
}
