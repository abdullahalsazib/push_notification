import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_app/core/notifications/notification_services.dart';
import 'package:my_app/reuseable/connectivity_service.dart';
import 'package:my_app/view/details_page.dart';
import 'package:my_app/view/screen/users_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationService notificationService = NotificationService.instance;

  late StreamSubscription<bool> _connectionSubscription;

  bool isOffline = false;

  @override
  void initState() {
    super.initState();
    notificationService.requestNotificationsPermission();
    notificationService.firebaseInit();
    notificationService.isTokenRefresh();
    notificationService.getDevicetoken().then(((value) {
      print("Device Token");
      print(value);
    }));

    _connectionSubscription = ConnectivityService().connectionstream.listen(((
      isConnected,
    ) {
      if (!mounted) return;

      setState(() {
        isOffline = !isConnected;
      });
    }));
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }

  Future<void> _showNotification() async {
    await NotificationService.instance.showInstantNotification(
      id: 3,
      title: 'Instant Notification Title',
      body: 'Instant Notification body',
      payload: "details_page",
    );
  }

  Future<void> _scheduleReminder() async {
    await NotificationService.instance.scheduleReminder(
      id: 2,
      title: "Schedule Reminder",
      body: "This is Test notify of ScheduleReminder",
    );
  }

  Future<void> _cancleAllNotification() async {
    await NotificationService.instance.cancelAllNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              "Hello, World Abdullah",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: FilledButton(
              onPressed: _showNotification,
              child: const Text("Instant Notify"),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: FilledButton(
              onPressed: _scheduleReminder,
              child: const Text("Schedule Notify"),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: FilledButton(
              style: ButtonStyle(
                mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailsPage()),
                );
              },
              child: const Text("Details ->"),
            ),
          ),
          Center(
            child: FilledButton(
              style: ButtonStyle(
                mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UsersScreen()),
                );
              },
              child: const Text("Users ->"),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _cancleAllNotification,
            child: Text(
              "Cancle All Notification",
              style: TextStyle(
                fontSize: 19,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
