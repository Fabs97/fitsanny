import 'package:fitsanny/bottom_bar.dart';
import 'package:fitsanny/pages/home/home.dart';
import 'package:fitsanny/pages/training/training_home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _router = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text('Fit Sanny'),
          ),
          body: SafeArea(
            child: Padding(padding: const EdgeInsets.all(16.0), child: child),
          ),
          bottomNavigationBar: AppBottomBar(),
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(title: 'Fit Sanny'),
        ),
        GoRoute(
          path: '/training',
          builder: (context, state) => const TrainingHome(),
        ),
      ],
    ),
  ],
);

get router => _router;
