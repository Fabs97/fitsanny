import 'package:fitsanny/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget shellRouteBuilder(
  BuildContext context,
  GoRouterState state,
  Widget child,
) => Scaffold(
  appBar: AppBar(
    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    title: Text('Fit Sanny'),
  ),
  body: SafeArea(
    child: Padding(padding: const EdgeInsets.all(16.0), child: child),
  ),
  bottomNavigationBar: AppBottomBar(),
);
