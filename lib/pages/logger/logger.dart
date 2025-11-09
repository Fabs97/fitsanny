import 'package:fitsanny/bloc/training/training_bloc.dart';
import 'package:fitsanny/model/training.dart';
import 'package:fitsanny/pages/logger/logger_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Logger extends StatefulWidget {
  const Logger({super.key});

  @override
  State<Logger> createState() => _LoggerState();
}

class _LoggerState extends State<Logger> {
  Training? training;

  @override
  void initState() {
    context.read<TrainingBloc>().add(LoadTrainingsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrainingBloc, TrainingState>(
      builder: (context, state) {
        if (state is TrainingsLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is! TrainingsLoaded) {
          return Center(
            child: Text('Logger::build - Wrong State ${state.runtimeType}'),
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  padding: WidgetStatePropertyAll(
                    const EdgeInsets.symmetric(horizontal: 8.0),
                  ),
                  onTap: () => controller.openView(),
                  onChanged: (query) => controller.openView(),
                  trailing: [const Icon(Icons.search)],
                );
              },
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                    final String input = controller.value.text;
                    return List<ListTile>.from(
                      state.trainings
                          .where((e) => e.title.contains(input))
                          .map(
                            (e) => ListTile(
                              title: Text(e.title),
                              onTap: () {
                                setState(() {
                                  training = e;
                                  controller.closeView(e.title);
                                });
                              },
                            ),
                          ),
                    );
                  },
            ),
            ...(training == null
                ? []
                : [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: LoggerDetails(training: training!),
                      ),
                    ),
                  ]),
          ],
        );
      },
    );
  }
}
