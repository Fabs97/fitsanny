import 'package:fitsanny/pages/home/home.dart';
import 'package:fitsanny/pages/training/training_home.dart';
import 'package:fitsanny/shell_route_builder.dart';
import 'package:go_router/go_router.dart';

final _router = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: shellRouteBuilder,
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
