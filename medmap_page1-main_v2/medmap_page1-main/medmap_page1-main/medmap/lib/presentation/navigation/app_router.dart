import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/auth_options_screen.dart';
import '../screens/register_screen.dart';
import '../screens/login_screen.dart';
import '../../main.dart'; // ModernInputScreen ve DoctorListScreen burada

class AppRouter {
  static const String splashRoute = '/';
  static const String authOptionsRoute = '/auth_options';
  static const String loginFormRoute = '/login_form_screen';
  static const String signupFormRoute = '/signup_form_screen';
  static const String modernInputRoute = '/modern_input';
  static const String doctorListRoute = '/doctor_list';
  static const String planSelectionRoute = '/plan_selection';
  static const String paymentRoute = '/payment';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case authOptionsRoute:
        return MaterialPageRoute(builder: (_) => const AuthOptionsScreen());
      case loginFormRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signupFormRoute:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case modernInputRoute:
        return MaterialPageRoute(builder: (_) => const ModernInputScreen());
      case doctorListRoute:
        return MaterialPageRoute(builder: (_) => const DoctorListScreen());
      case planSelectionRoute:
        return MaterialPageRoute(builder: (_) => const PlanSelectionScreen());
      case paymentRoute:
        return MaterialPageRoute(builder: (_) => const PaymentScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}
