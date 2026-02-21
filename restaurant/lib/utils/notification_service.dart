import 'dart:convert';
import 'dart:developer' as developer;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'fire_store_utils.dart';

Future<void> firebaseMessageBackgroundHandle(RemoteMessage message) async {}

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initInfo() async {
    try {
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      var request = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (request.authorizationStatus == AuthorizationStatus.authorized || request.authorizationStatus == AuthorizationStatus.provisional) {
        const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
        var iosInitializationSettings = const DarwinInitializationSettings();
        final InitializationSettings initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: iosInitializationSettings,
        );

        await flutterLocalNotificationsPlugin.initialize(
          initializationSettings,
          onDidReceiveNotificationResponse: (payload) {},
        );

        const AndroidNotificationChannel orderChannel = AndroidNotificationChannel(
          'orders_channel',
          'Orders',
          description: 'Channel for new order notifications',
          importance: Importance.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('order_sound'),
        );

        const AndroidNotificationChannel defaultChannel = AndroidNotificationChannel(
          'default_channel',
          'General',
          description: 'General notifications',
          importance: Importance.high,
          playSound: true,
        );

        final androidPlugin = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

        await androidPlugin?.createNotificationChannel(orderChannel);
        await androidPlugin?.createNotificationChannel(defaultChannel);

        // Background handler
        FirebaseMessaging.onBackgroundMessage(firebaseMessageBackgroundHandle);

        setupInteractedMessage();
      }
    } catch (e, stack) {
      if (kDebugMode) {
        developer.log('Error initializing notification service: $e', error: e, stackTrace: stack);
      }
    }
  }

  Future<void> setupInteractedMessage() async {
    try {
      RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        FirebaseMessaging.onBackgroundMessage((message) => firebaseMessageBackgroundHandle(message));
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        try {
          if (message.notification != null) {
            display(message);
          }
        } catch (e, stack) {
          if (kDebugMode) {
            developer.log('Error handling message: $e', error: e, stackTrace: stack);
          }
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
        try {
          if (message.notification != null) {
            if (message.data['type'] == "chat") {
              await FireStoreUtils.getOwnerProfile(message.data['senderId'] == FireStoreUtils.getCurrentUid() ? message.data['receiverId'] : message.data['senderId']).then((value) {});
            } else if (message.data['type'] == "order") {}
          }
        } catch (e, stack) {
          if (kDebugMode) {
            developer.log('Error handling message opened app: $e', error: e, stackTrace: stack);
          }
        }
      });
    } catch (e, stack) {
      if (kDebugMode) {
        developer.log('Error setting up interacted message: $e', error: e, stackTrace: stack);
      }
    }
  }

  static Future<String> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return token!;
  }

  void display(RemoteMessage message) async {
    try {
      bool isBooking = message.data['isNewOrder'] == 'true';
      AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        isBooking ? 'orders_channel' : 'default_channel',
        isBooking ? 'Orders' : 'General',
        channelDescription: 'Order Notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: isBooking ? const RawResourceAndroidNotificationSound('order_sound') : null,
      );

      DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentSound: true,
        sound: isBooking ? 'order_sound.wav' : null,
      );

      NotificationDetails details = NotificationDetails(android: androidDetails, iOS: iosDetails);

      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        details,
        payload: jsonEncode(message.data),
      );
    } on Exception {
      if (kDebugMode) {}
    }
  }
}
