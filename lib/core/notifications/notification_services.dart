import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_app/app/app.dart';
import 'package:my_app/view/screen/messages_screen.dart';
import 'package:my_app/view/screen/users_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String channelId = 'my_channel_v2';
  static const String channelName = 'Test Notifications';
  static const String channelDescription = 'Test notification channel';
  static const String notificationSound = 'sound1';
  static const String notificationIcon = 'notification_icon';

  final NotificationDetails details = const NotificationDetails(
    android: AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      playSound: true,
      // sound: RawResourceAndroidNotificationSound(notificationSound),
      // icon: notificationIcon,
    ),
    iOS: DarwinNotificationDetails(presentSound: true),
    linux: LinuxNotificationDetails(),
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const LinuxInitializationSettings linuxSettings =
        LinuxInitializationSettings(defaultActionName: 'Open Notification');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      linux: linuxSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final String? payload = response.payload;
        if (payload != null) {
          Map<String, dynamic> data = jsonDecode(payload);
          handleRoute(data);
        }
      },
    );

    setupInteractMessage();
  }

  Future<void> setupInteractMessage() async {
    // 1. App Terminated State
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    if (initialMessage != null) {
      handleMessages(initialMessage);
    }

    // 2. App Background State
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleMessages(message);
    });
  }

  void requestNotificationsPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) print("user granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) print("user provisional granted permission");
    } else {
      if (kDebugMode) print("user denied permission");
    }
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print("Foreground Message: ${message.data.toString()}");
      }
      showNotification(message);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    _flutterLocalNotificationsPlugin.show(
      id: DateTime.now().millisecond,
      title: message.notification?.title.toString(),
      body: message.notification?.body.toString(),
      notificationDetails: details,
      payload: jsonEncode(message.data),
    );
  }

  Future<String> getDevicetoken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() {
    messaging.onTokenRefresh.listen((event) => event.toString());
  }

  void handleMessages(RemoteMessage message) {
    handleRoute(message.data);
  }

  void handleRoute(Map<String, dynamic> data) {
    String? type = data['type'];
    String? id = data["id"];

    if (type == 'msg') {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) => MessagesScreen(id: id!)),
      );
    } else if (type == 'details_page') {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) => const UsersScreen()),
      );
    }
  }

  // Local notification functions
  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _flutterLocalNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload ?? jsonEncode({'type': 'details_page'}),
    );
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id: id);
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const int delayInSeconds = 5;

    if (Platform.isLinux) {
      Timer(const Duration(seconds: delayInSeconds), () async {
        await showInstantNotification(
          id: id,
          title: title,
          body: body,
          payload: payload ?? jsonEncode({'type': 'details_page'}),
        );
      });
      return;
    }

    final tz.TZDateTime scheduledDate = tz.TZDateTime.now(
      tz.getLocation('Asia/Dhaka'),
    ).add(const Duration(seconds: delayInSeconds));

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: payload ?? jsonEncode({'type': 'details_page'}),
      scheduledDate: scheduledDate,
      notificationDetails: details,
    );
  }
}
