import 'package:fitsanny/router.dart';
import 'package:fitsanny/theme.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Fit Sanny',
      theme: appTheme,
      routerConfig: router,
    );
  }
}
