import 'package:collection/collection.dart';
import 'package:fitsanny/bloc/log/log_bloc.dart';
import 'package:fitsanny/model/log.dart';
import 'package:fitsanny/model/set.dart';
import 'package:fitsanny/pages/logger/logger_bloc.dart';
import 'package:fitsanny/pages/logger/logger_set_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class LoggerDetails extends StatefulWidget {
  const LoggerDetails({super.key});

  @override
  State<LoggerDetails> createState() => _LoggerDetailsState();
}

class _LoggerDetailsState extends State<LoggerDetails> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late Log log;

  @override
  void initState() {
    super.initState();
    LogState currentLogState = BlocProvider.of<LogBloc>(context).state;
    LoggerState currentLoggerState = BlocProvider.of<LoggerBloc>(context).state;

    if (currentLogState is LogsLoaded) {
      final logs = currentLogState.logs;

      log = Log(
        trainingId: currentLoggerState.training!.id!,
        sets: logs.isEmpty
            // No logs available yet
            ? currentLoggerState.training!.exercises
                  .map((e) => Set(exerciseId: e.id!, reps: 1, kgs: 5.0))
                  .toList()
            : logs.first.sets,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, List<Set>> setsGroupedByExerciseId = groupBy<Set, int>(
      log.sets,
      (Set set) => set.exerciseId,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: BlocBuilder<LoggerBloc, LoggerState>(
        builder: (context, loggerState) {
          return FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<LogBloc, LogState>(
                  builder: (context, state) {
                    if (state is LogsLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is! LogsLoaded) {
                      return Center(
                        child: Text(
                          'LoggerDetails::build - Wrong event type : ${state.runtimeType}',
                        ),
                      );
                    }
                    if (loggerState is ChosenTraining) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          spacing: 8.0,
                          children: [
                            ...loggerState.training!.exercises.asMap().map((
                              idx,
                              exercise,
                            ) {
                              return MapEntry(
                                idx,
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      spacing: 16.0,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(exercise.exerciseName!),
                                        ...setsGroupedByExerciseId[exercise.id]!
                                            .asMap()
                                            .map(
                                              (idx, set) => MapEntry(
                                                idx,
                                                LoggerSetRow(
                                                  idx: idx,
                                                  reps: set.reps,
                                                  kgs: set.kgs,
                                                ),
                                              ),
                                            )
                                            .values,
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).values,
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          'LoggerDetails::build - LoggerState is wrong: ${loggerState.runtimeType}',
                        ),
                      );
                    }
                  },
                ),

                ElevatedButton(
                  onPressed: () {
                    // context.read<LogBloc>().add(
                    //   AddLogsEvent(
                    //     widget.training.exercises
                    //         .map(
                    //           (e) => Log(
                    //             trainingId: widget.training.id!,
                    //             exerciseId: e.id!,
                    //             kgs: e.kgs,
                    //             reps: e.reps,
                    //           ),
                    //         )
                    //         .toList(),
                    //   ),
                    // );
                  },
                  child: Text('Save performance'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
