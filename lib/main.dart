import 'package:the_boring_app/routing/app_router.dart';
import 'package:the_boring_app/state/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_config/constants.dart';
import 'app_config/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(ProviderScope(child: MyApp()));
  });
}

class MyApp extends ConsumerWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final userTheme = watch(themeNotifier.state);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: kAppTitle,
      initialRoute: AppRoutes.home,
      theme: userTheme ? AppTheme.darkTheme : AppTheme.lightTheme,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
