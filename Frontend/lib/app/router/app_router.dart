import 'package:flutter/material.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/common/screens/home_screen.dart'; // Assuming MainScreen is here
import '../app.dart';

class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String collection = '/collection';
  static const String search = '/search';
  static const String community = '/community';
  static const String lightstickRecognition = '/lightstick';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
      case '/':
        return _buildPageRoute(const LoginScreen(), settings);
      case register:
        return _buildPageRoute(const RegisterScreen(), settings);
      case home:
        return _buildPageRoute(const MainScreen(initialIndex: 0), settings);
      case collection:
        return _buildPageRoute(const MainScreen(initialIndex: 1), settings);
      case search:
      case lightstickRecognition:
        return _buildPageRoute(const MainScreen(initialIndex: 2), settings);
      case community:
        return _buildPageRoute(const MainScreen(initialIndex: 3), settings);
      case profile:
        return _buildPageRoute(const MainScreen(initialIndex: 4), settings);
      default:
        return _buildPageRoute(const LoginScreen(), settings);
    }
  }

  static PageRouteBuilder _buildPageRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}