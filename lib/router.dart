import 'package:fitsanny/pages/goals/goals_page.dart';
import 'package:fitsanny/pages/home/home.dart';
import 'package:fitsanny/pages/logger/logger_details.dart';
import 'package:fitsanny/pages/logger/logger_home.dart';
import 'package:fitsanny/pages/logger/logger_shell_router.dart';
import 'package:fitsanny/model/log.dart';
import 'package:fitsanny/model/training.dart';
import 'package:fitsanny/pages/training/training_form.dart';
import 'package:fitsanny/pages/training/training_home.dart';
import 'package:fitsanny/pages/training/update_training_page.dart';
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
            GoRoute(
              path: '/update',
              builder: (context, state) {
                final training = state.extra as Training;
                return UpdateTrainingPage(training: training);
              },
            ),
          ],
        ),
        ShellRoute(
          builder: loggerShellRouterBuilder,
          routes: [
            GoRoute(
              path: '/log',
              builder: (context, state) => const LoggerHome(),
              routes: [
                GoRoute(
                  path: '/new',
                  builder: (context, state) => const LoggerDetails(),
                ),
                GoRoute(
                  path: '/edit',
                  builder: (context, state) {
                    final log = state.extra as Log;
                    return LoggerDetails(logToEdit: log);
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(path: '/goals', builder: (context, state) => const GoalsPage()),
      ],
    ),
  ],
);

get router => _router;
