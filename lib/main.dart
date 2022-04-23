import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crud/models/users_model.dart';
import 'package:firebase_crud/splash_scrren.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'snackbar.dart';

// receiving notification
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', 'high_importance_notification',
    description: 'This is notification description',
    importance: Importance.high,
    playSound: true);

// flutter local notification plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// background handling messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up:${message.messageId}');
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  // Set a message handler function which is called when the app is in the background or terminated.
// This provided handler must be a top-level function and cannot be anonymous otherwise an [ArgumentError] will be thrown.
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Requires running on the appropriate platform that matches the specified type for a result to be returned. For example, when the specified type argument is of type [AndroidFlutterLocalNotificationsPlugin], this will only return a result of that type when running on Android.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  //Sets the presentation options for Apple notifications when received in the foreground.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    // firebase notification for foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    channelDescription: channel.description,
                    color: Colors.greenAccent,
                    playSound: true,
                    icon: '@mipmap/ic_launcher')));
      }
    });
    // firebase notification if app is closed or background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenApp event was published');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title.toString()),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body.toString())],
                  ),
                ),
              );
            });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

final formKey = GlobalKey<FormState>();

class _HomePageState extends State<HomePage> {
  final controllerName = TextEditingController();
  final controllerAge = TextEditingController();
  final controllerDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Your Favorite Player'),
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
                    value != null && value.isEmpty ? 'Enter Jersey No' : null,
                controller: controllerAge,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'No',
                  contentPadding: EdgeInsets.only(bottom: 0),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                validator: (value) =>
                    value != null && value.isEmpty ? 'Enter Position' : null,
                controller: controllerDate,
                decoration: const InputDecoration(
                    labelText: 'position',
                    contentPadding: const EdgeInsets.only(bottom: 0)),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: () {
                    final form = formKey.currentState!;
                    if (form.validate()) {
                      final user = User(
                          name: controllerName.text,
                          age: int.parse(controllerAge.text),
                          birthday: controllerDate.text);
                      CreateUser(user: user);
                      Navigator.pop(context);
                      final snackbar =
                          displaySnackbar(context, 'Created New Player');
                    } else {
                      final snackbar = displaySnackbar(
                          context, 'Form is not Valid,pls fill details');
                    }
                  },
                  child: const Text('Create'))
            ],
          ),
        ),
      ),
    );
  }
}

// create user
Future CreateUser({required User user}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Reference to Document
  final docUser = FirebaseFirestore.instance.collection('users').doc();

  user.id = docUser.id;
  final UID = prefs.getString('currentuserid');
  user.userId = UID.toString();
  print(user.userId);
// Create document and write data to Firebase
  await docUser.set(user.toJson());
}
