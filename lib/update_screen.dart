import 'package:flutter/material.dart';

import 'models/users_model.dart';

class UpdateItemScreen extends StatefulWidget {
  const UpdateItemScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<UpdateItemScreen> createState() => _UpdateItemScreenState();
}

class _UpdateItemScreenState extends State<UpdateItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Text('hi'),
      ),

      // body: StreamBuilder<List<User>>(
      //   stream: readUsers(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasError) {
      //       return const Center(child: Text('Something Went Wrong '));
      //     } else if (snapshot.hasData) {
      //       final users = snapshot.data;
      //       return ListView(
      //         children: users!.map(buildUser).toList(),
      //       );
      //     } else {
      //       return const Center(
      //         child: CircularProgressIndicator(
      //           strokeWidth: 2,
      //         ),
      //       );
      //     }
      //   },
      // ),
    );
  }
}

Widget buildUser(User user) => ListTile(
      leading: CircleAvatar(
        child: Text('${user.age}'),
      ),
      title: Text(user.name),
      subtitle: Text(user.birthday),
      trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
    );
