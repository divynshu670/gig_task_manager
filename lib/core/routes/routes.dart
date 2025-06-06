import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/forgotpassword_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/tasks/presentation/pages/home_page.dart';
import '../../features/tasks/presentation/pages/add_edit_task_page.dart';
import '../pages/splash_page.dart';

class Routes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String addTask = '/add-task';
  static const String editTask = '/edit-task';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case signup:
        return MaterialPageRoute(builder: (_) => const SignUpPage());

      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());

      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case addTask:
        return MaterialPageRoute(builder: (_) => const AddEditTaskPage());

      case editTask:
        final taskArg = settings.arguments as Map<String, dynamic>?;

        if (taskArg != null && taskArg['task'] != null) {
          final existingTask = taskArg['task'] as dynamic;
          return MaterialPageRoute(
            builder: (_) => AddEditTaskPage(existingTask: existingTask),
          );
        } else {
          return MaterialPageRoute(builder: (_) => const AddEditTaskPage());
        }

      default:
        return null;
    }
  }
}
