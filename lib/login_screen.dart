import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud/MainScreen.dart';
import 'package:firebase_crud/main.dart';
import 'package:firebase_crud/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Dream 11',
                  style: TextStyle(
                      fontSize: 27,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 20),
                TextFormField(
                  validator: (value) =>
                      value != null && value.isEmpty ? 'Pls enter Email' : null,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter Email here...',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) => value != null && value.isEmpty
                      ? 'Pls enter password'
                      : null,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Password',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      final form = formKey.currentState!;
                      if (form.validate()) {
                        loginUser(context);
                      } else {
                        displaySnackbar(context, 'Pls enter Email & Password');
                      }
                    },
                    child: const Text('LOGIN'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    String mes = '';

    try {
      if (emailController.text.isNotEmpty ||
          passwordController.text.isNotEmpty) {
        UserCredential userdata = await _auth.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        prefs.setString('currentuserid', userdata.user!.uid);
        // Create storage
        const storage = FlutterSecureStorage();
        // Write value

        print(userdata.credential?.token.toString());
        await storage.write(key: 'Token', value: userdata.user!.uid);
        mes = 'Successfully login process completed';
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
        flutterLocalNotificationsPlugin.show(
            0,
            'Login Confirmation',
            'Successfully opened',
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    channelDescription: channel.description,
                    importance: Importance.high,
                    playSound: true,
                    color: Colors.greenAccent,
                    icon: '@mipmap/ic_launcher')));
      } else {
        mes = 'enter details';
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      mes = e.code.toString();
    } catch (error) {
      mes = error.toString();
    }
    displaySnackbar(context, mes);
  }
}
