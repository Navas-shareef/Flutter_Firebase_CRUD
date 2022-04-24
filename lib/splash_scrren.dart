import 'package:firebase_crud/MainScreen.dart';
import 'package:firebase_crud/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _changeScreen();
    super.initState();
  }

  Future<void> checkScreen() async {
    const storage = FlutterSecureStorage();
    // Read value
    final value = await storage.read(key: 'Token');

    print(value);
    if (value.toString() != 'null') {
      print(value);
      setState(() {
        chooseScreen = const MainScreen();
      });
    } else {
      setState(() {
        chooseScreen = SignUpScreen();
      });
    }
  }

  Widget chooseScreen = SignUpScreen();
  void _changeScreen() async {
    await checkScreen();
    await Future.delayed(const Duration(milliseconds: 4000), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => chooseScreen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.sports_soccer,
              color: Colors.blueAccent,
              size: 60,
            ),
            Text(
              'Dream 11',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}
