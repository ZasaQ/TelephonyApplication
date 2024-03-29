import 'dart:convert';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:telephon_application/main.dart';
import 'package:telephon_application/models/call_model.dart';
import 'package:telephon_application/models/user_model.dart';
import 'package:telephon_application/pages/call.dart';
import 'package:telephon_application/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationServices {
  static ReceivedAction? initialAction;

  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'high_importance_channel',
          channelName: 'video call channel',
          channelDescription: 'channel for video calls',
          importance: NotificationImportance.Max,
          defaultPrivacy: NotificationPrivacy.Public,
          defaultColor: Colors.transparent,
          locked: true,
          enableVibration: true,
          defaultRingtoneType: DefaultRingtoneType.Ringtone,
        ),
      ],
    );

    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    if (receivedAction.buttonKeyPressed == "ACCEPT") {
      Map userMap = receivedAction.payload!;
      UserModel user = UserModel(
          uid: userMap['uid'],
          name: userMap['name'],
          email: userMap['email']);
      CallModel call = CallModel(
        id: userMap['id'],
        channel: userMap['channel'],
        caller: userMap['caller'],
        called: userMap['called'],
        active: jsonDecode(userMap['active']),
        accepted: true,
        rejected: jsonDecode(userMap['rejected']),
        connected: true,
        activationDate: userMap['activationDate']
      );
      Navigator.push(
        MyApp.navigatorKey.currentState!.context, 
        MaterialPageRoute(
          builder: (context) => CallPage(user: user, callHandler: call,))
      );
    }
    if (receivedAction.buttonKeyPressed == "REJECT") {
      callsCollection.doc(receivedAction.payload!['id']).update(
        {
          'rejected': true,
        },
      );
    }
  }

  static Future<void> showNotification(
      {required RemoteMessage remoteMessage}) async {
    Random random = Random();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: random.nextInt(1000000),
        channelKey: 'high_importance_channel',
        title: remoteMessage.data['name'],
        body: "Incoming Video Call",
        autoDismissible: false,
        category: NotificationCategory.Call,
        notificationLayout: NotificationLayout.Default,
        locked: true,
        wakeUpScreen: true,
        backgroundColor: Colors.transparent,
        payload: {
          'uid': remoteMessage.data['uid'],
          'name': remoteMessage.data['name'],
          'email': remoteMessage.data['email'],
          'id': remoteMessage.data['id'],
          'channel': remoteMessage.data['channel'],
          'caller': remoteMessage.data['caller'],
          'called': remoteMessage.data['called'],
          'active': remoteMessage.data['active'],
          'accepted': remoteMessage.data['accepted'],
          'rejected': remoteMessage.data['rejected'],
          'connected': remoteMessage.data['connected'],
          'activationDate': remoteMessage.data['activationDate']
        },
      ),
      actionButtons: [
        NotificationActionButton(
          key: "ACCEPT",
          label: "Accept",
          color: Colors.green,
          autoDismissible: true,
        ),
        NotificationActionButton(
          key: "REJECT",
          label: "Reject",
          color: Colors.red,
          autoDismissible: true,
        ),
      ],
    );
  }
}