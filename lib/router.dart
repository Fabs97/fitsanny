import 'package:fitsanny/components/action_button.dart';
import 'package:fitsanny/components/expandable_fab.dart';
import 'package:fitsanny/pages/home/home.dart';
import 'package:fitsanny/pages/training/training_home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text('Fit Sanny'),
          ),
          body: SafeArea(
            child: Padding(padding: const EdgeInsets.all(8.0), child: child),
          ),
          floatingActionButton: ExpandableFab(
            distance: 112,
            children: [
              ActionButton(
                onPressed: () => context.go('/training'),
                icon: Icons.fitness_center,
              ),
            ],
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/',
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
