import 'package:flutter/material.dart';
import 'package:my_app/core/routes/app_router.dart';
import 'package:my_app/core/theme/app_theme.dart';
import 'package:my_app/providers/timer_provider.dart';
import 'package:my_app/providers/work_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkProvider()),
        ChangeNotifierProvider(create: (_) => TimerProvider()),
      ],
      child: const WorkTrackApp(),
    ),
  );
}

class WorkTrackApp extends StatelessWidget {
  const WorkTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'WorkTrack',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
