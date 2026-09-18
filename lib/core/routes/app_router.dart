import 'package:go_router/go_router.dart';
import 'package:my_app/features/dashboard/view/main_screen.dart';
import 'package:my_app/features/work/view/add_work_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/add-work',
        builder: (context, state) => const AddWorkScreen(),
      ),
    ],
  );
}
