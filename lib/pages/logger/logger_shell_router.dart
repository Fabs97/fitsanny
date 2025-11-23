import 'package:fitsanny/bloc/log/log_cubit.dart';
import 'package:fitsanny/bloc/training/training_cubit.dart';
import 'package:fitsanny/model/training.dart';
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
                  TrainingSearchAnchor(trainings: trainingState.trainings),
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

class TrainingSearchAnchor extends StatefulWidget {
  final List<Training> trainings;

  const TrainingSearchAnchor({super.key, required this.trainings});

  @override
  State<TrainingSearchAnchor> createState() => _TrainingSearchAnchorState();
}

class _TrainingSearchAnchorState extends State<TrainingSearchAnchor> {
  final SearchController _controller = SearchController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_controller.text.isEmpty) {
      context.read<LoggerCubit>().clearTraining();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: _controller,
      viewHintText: AppLocalizations.of(context)!.chooseTrainingHint,
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          hintText: AppLocalizations.of(context)!.chooseTrainingHint,
          padding: WidgetStatePropertyAll(
            const EdgeInsets.symmetric(horizontal: 8.0),
          ),
          elevation: WidgetStatePropertyAll(0.0),
          onTap: () => controller.openView(),
          onChanged: (query) {
            controller.openView();
          },
          trailing: [const Icon(Icons.search)],
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        final String input = controller.value.text;
        return List<ListTile>.from(
          widget.trainings
              .where(
                (e) => e.title.toLowerCase().contains(input.toLowerCase()),
              ) // Added case-insensitive search
              .map(
                (e) => ListTile(
                  title: Text(e.title),
                  onTap: () {
                    context.read<LoggerCubit>().chooseTraining(e);
                    context.go('/log/new');
                    context.read<LoggerCubit>().chooseTraining(e);
                    controller.closeView(e.title);
                  },
                ),
              ),
        );
      },
    );
  }
}
