import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:telephon_application/pages/homepage.dart';
import 'package:telephon_application/pages/new_contact.dart';
import 'package:telephon_application/pages/messages.dart';
import 'package:telephon_application/pages/settingspage.dart';
import 'package:telephon_application/services/authentication.dart';
import 'package:telephon_application/services/firestore_databases.dart';
import 'package:telephon_application/services/notification_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'firebase_options.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage remoteMessage) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //SHOW NOTIFICATION
  await NotificationServices.showNotification(remoteMessage: remoteMessage);
  await callsCollection.doc(remoteMessage.data['id']).update(
    {
      'connected': true,
    },
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationServices.initializeNotification();
  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications(
          channelKey: "high_importance_channel");
    }
  });
  
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(
    (RemoteMessage remoteMessage) async {
      await NotificationServices.showNotification(remoteMessage: remoteMessage);
      await callsCollection.doc(remoteMessage.data['id']).update(
        {
          'connected': true,
        },
      );
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MyApp.navigatorKey,
      title: 'Telephony Application',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue.shade300)),
      debugShowCheckedModeBanner: false,
      home: AuthenticationPage(),
      routes: {
        '/secondpage' : (context) => MessagesPage(),
        '/homepage' : (context) => HomePage(),
        '/settingspage' : (context) => SettingsPage(),
        '/add' : (context) => NewContact(),
      },
    );
  }
}