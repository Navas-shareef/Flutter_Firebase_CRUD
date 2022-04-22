import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud/MainScreen.dart';
import 'package:firebase_crud/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                  validator: (value) => value != null && value.isEmpty
                      ? 'Pls enter password'
                      : null,
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
                  validator: (value) =>
                      value != null && value.isEmpty ? 'Pls enter Email' : null,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Password',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) => value != null && value.isEmpty
                      ? 'Pls enter confirm password'
                      : null,
                  controller: confirmPasswordController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Confirm Password',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          final form = formKey.currentState!;
                          if (form.validate()) {
                            if (passwordController.text ==
                                confirmPasswordController.text) {
                              signUpUser(context);
                            } else {
                              displaySnackbar(
                                  context, 'password does not match');
                            }
                          } else {
                            print('enter details');
                          }
                        },
                        child: const Text('SignUp')),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: const Text('LOGIN'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signUpUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    String mes = 'error occurred';

    try {
      if (emailController.text.isNotEmpty ||
          passwordController.text.isNotEmpty) {
        UserCredential userdata = await _auth.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        print(userdata.user!.uid);
        prefs.setString('currentuserid', userdata.user!.uid);
        mes = 'success';
      } else {
        mes = 'pls enter email and password';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        mes = err.code;
      } else {
        mes = err.code;
      }
    } catch (err) {
      mes = err.toString();
    }

    if (mes != 'success') {
      displaySnackbar(context, mes);
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
    }
  }
}
