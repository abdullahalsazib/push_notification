import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/app/app.dart';
import 'package:my_app/core/notifications/notification_services.dart';
import 'package:my_app/repositories/user_repository.dart';
import 'package:my_app/services/user_api_services.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // NotificationService.instance.showNotification(message);
  // print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 3. Initialize separate app infrastructure layers
  await NotificationService.instance.initialize();

  // 4. Update device UI hardware overlay behaviors
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top],
  );

  // services add
  final apiServices = UserApiServices();
  final repository = UserRepository(apiServices);
  runApp(MyApp(repository: repository));
}
