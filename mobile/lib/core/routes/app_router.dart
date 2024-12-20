import 'package:flutter/material.dart';
import 'package:monscolis/features/auth/presentation/pages/login_page.dart';
import 'package:monscolis/features/home/presentation/pages/home_page.dart';
import 'package:monscolis/features/profile/presentation/pages/profile_page.dart';
import 'package:monscolis/features/appointments/presentation/pages/appointments_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case '/appointments':
        return MaterialPageRoute(builder: (_) => const AppointmentsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
