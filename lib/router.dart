import 'package:fitsanny/pages/home/home.dart';
import 'package:fitsanny/pages/training/training_form.dart';
import 'package:fitsanny/pages/training/training_home.dart';
import 'package:fitsanny/shell_route_builder.dart';
import 'package:go_router/go_router.dart';

final _router = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: shellRouteBuilder,
      redirect: (context, state) {
        if (state.fullPath == '/') {
          return '/home';
        }
        return state.fullPath;
      },
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomePage()),
        GoRoute(
          path: '/training',
          builder: (context, state) => const TrainingHome(),
          routes: [
            GoRoute(
              path: '/new',
              builder: (context, state) => const TrainingForm(),
            ),
          ],
        ),
      ],
    ),
  ],
);

get router => _router;
