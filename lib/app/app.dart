
import 'package:flutter/material.dart';
import 'package:my_app/myTest/notification.dart';
import 'package:my_app/presentation/resources/theme_manager.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();



class MyApp extends StatefulWidget {
  int appState = 0;
  MyApp._internal(); // private named constructure

  static final MyApp instance = MyApp._internal();
  factory MyApp() => instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: getApplicationTheme(),
      home: NotificationScreen(),
    );
  }
}
