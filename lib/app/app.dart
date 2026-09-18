import 'package:flutter/material.dart';
import 'package:my_app/view/notification.dart';
import 'package:my_app/presentation/resources/theme_manager.dart';
import 'package:my_app/repositories/user_repository.dart';
import 'package:my_app/viewmodels/user_view_model.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  final UserRepository _repository;
  const MyApp({super.key, required this._repository});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserViewModel(widget._repository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: getApplicationTheme(),
        home: NotificationScreen(),
      ),
    );
  }
}
