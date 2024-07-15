import 'dart:async';
import 'dart:io' show Platform;
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

final class NotificationManager {
  NotificationManager._();

  static final instance = NotificationManager._();

  // used to pass messages from event handler to the UI
  final _messageStreamController = BehaviorSubject<RemoteMessage>();

  Future<void> initialize() async {
    if (Platform.isAndroid) {
      // You may set the permission requests to "provisional" which allows the user to choose what type
      // of notifications they would like to receive once the user receives a notification.
      final notificationSettings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      if (kDebugMode) {
        print('Permission granted: ${notificationSettings.authorizationStatus}');
      }
      if (notificationSettings.authorizationStatus == AuthorizationStatus.authorized) {
        await getFCMToken();
      }
    }
    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) {
      // TODO: If necessary send token to application server.
      if (kDebugMode) {
        print('Refreshed token: $fcmToken');
      }
      // Note: This callback is fired at each app startup and whenever a new
      // token is generated.
    }).onError((err) {
      print("Error notification token: $err");
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Handling a foreground message: ${message.messageId}');
        print('Message data: ${message.data}');
        print('Message notification: ${message.notification?.title}');
        print('Message notification: ${message.notification?.body}');
      }
      _messageStreamController.sink.add(message);
    });
  }

  Future<String?> getFCMToken() async {
    String? fcmToken;
    if (kIsWeb) {
      fcmToken = await FirebaseMessaging.instance.getToken(vapidKey: "BEKwz9A8LbjHj-aJbLPxXfFyXFjLtL8L0vKVTuEosPRO47JXORDA12V8hf54Glo-fJIgkoLH2VHVXXZiEba6eqE");
      if (kDebugMode) {
        print('Registration Token=$fcmToken');
      }
    } else if (Platform.isAndroid) {
      fcmToken = await FirebaseMessaging.instance.getToken();
      if (kDebugMode) {
        print('Registration Token=$fcmToken');
      }
    }

    return fcmToken;
  }

  void _handleMessage(RemoteMessage message) {
    log('Handling a background message ${message.messageId}');
  }
}