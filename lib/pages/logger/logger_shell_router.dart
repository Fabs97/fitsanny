import 'package:fitsanny/bloc/log/log_cubit.dart';
import 'package:fitsanny/bloc/training/training_cubit.dart';
import 'package:fitsanny/pages/logger/logger_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fitsanny/l10n/app_localizations.dart';

Widget loggerShellRouterBuilder(
  BuildContext context,
  GoRouterState router,
  Widget child,
) {
  context.read<TrainingCubit>().loadTrainings();
  return BlocBuilder<TrainingCubit, TrainingState>(
    builder: (context, trainingState) {
      if (trainingState is TrainingsLoading) {
        return Center(child: CircularProgressIndicator());
      } else if (trainingState is! TrainingsLoaded) {
        return Center(
          child: Text(
            AppLocalizations.of(context)!.errorPrefix(
              'Logger::build - Wrong State ${trainingState.runtimeType}',
            ),
          ),
        );
      }
      return BlocBuilder<LogCubit, LogState>(
        buildWhen: (previous, current) => current is LogsLoaded,
        builder: (context, state) {
          return BlocBuilder<LoggerCubit, LoggerState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SearchAnchor(
                    viewHintText: AppLocalizations.of(
                      context,
                    )!.chooseTrainingHint,
                    builder:
                        (BuildContext context, SearchController controller) {
                          return SearchBar(
                            controller: controller,
                            hintText: AppLocalizations.of(
                              context,
                            )!.chooseTrainingHint,
                            padding: WidgetStatePropertyAll(
                              const EdgeInsets.symmetric(horizontal: 8.0),
                            ),
                            elevation: WidgetStatePropertyAll(0.0),
                            onTap: () => controller.openView(),
                            onChanged: (query) => controller.openView(),
                            trailing: [const Icon(Icons.search)],
                          );
                        },
                    suggestionsBuilder:
                        (BuildContext context, SearchController controller) {
                          final String input = controller.value.text;
                          return List<ListTile>.from(
                            trainingState.trainings
                                .where((e) => e.title.contains(input))
                                .map(
                                  (e) => ListTile(
                                    title: Text(e.title),
                                    onTap: () {
                                      // Load logs for the chosen training, and
                                      // navigate to the logger details when done.
                                      context.read<LogCubit>().loadLogs(
                                        e.id!,
                                        onComplete: (success, {data}) =>
                                            // Use absolute path to be explicit.
                                            context.go('/log/new'),
                                      );

                                      // Update logger state (no navigation here).
                                      context
                                          .read<LoggerCubit>()
                                          .chooseTraining(e);

                                      controller.closeView(e.title);
                                    },
                                  ),
                                ),
                          );
                        },
                  ),
                  Expanded(child: child),
                ],
              );
            },
          );
        },
      );
    },
  );
}
