import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/home_page.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String homePage = '/home-page';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => LoginScreen(),
      register: (context) => RegisterScreen(),
      forgotPassword: (context) => ForgotPasswordScreen(),
      homePage: (context) => HomePage(),
    };
  }
}
