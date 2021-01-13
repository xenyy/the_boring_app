import 'package:the_boring_app/app/home/home.dart';
import 'package:the_boring_app/app/saved/saved.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const home = HomeScreen.routeName;
  static const saved = SavedScreen.routeName;

}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute<dynamic>(
          builder: (_) => HomeScreen(),
        );

    //log in process
      case AppRoutes.saved:
        return MaterialPageRoute<dynamic>(
          builder: (_) => SavedScreen(),
        );

      default:
      // TODO: Throw
        return null;
    }
  }
}
