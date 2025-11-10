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
  late Log? log;

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
      log?.sets ?? [],
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
                // Constrain the scrollable area so it can actually scroll
                // instead of causing a column overflow. Using Expanded
                // gives the SingleChildScrollView a bounded height.
                Expanded(
                  child: BlocBuilder<LogBloc, LogState>(
                    builder: (context, state) {
                      if (state is LogsLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (state is! LogsLoaded) {
                        if (state is LogError) print(state.message);
                        return Center(
                          child: Text(
                            'LoggerDetails::build - Wrong event type : ${state.runtimeType}\n${state is LogError ? state.message : ''}',
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
                                          // Guard against a missing entry for an
                                          // exercise id. If no sets are present
                                          // default to an empty list so the UI
                                          // doesn't crash.
                                          ...((setsGroupedByExerciseId[exercise
                                                      .id]) ??
                                                  [])
                                              .asMap()
                                              .map(
                                                (idx, set) => MapEntry(
                                                  idx,
                                                  LoggerSetRow(
                                                    idx: idx,
                                                    exerciseId: exercise.id!,
                                                    reps: set.reps,
                                                    kgs: set.kgs,
                                                  ),
                                                ),
                                              )
                                              .values,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  int index = (log?.sets ?? [])
                                                      .indexWhere(
                                                        (s) =>
                                                            s.exerciseId ==
                                                            exercise.id!,
                                                      );
                                                  if (index >= 0) {
                                                    setState(() {
                                                      (log?.sets ?? [])
                                                          .removeAt(index);

                                                      log = log;
                                                    });
                                                  }
                                                },
                                                child: Text('Remove a set'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    log = log?.copyWith(
                                                      sets: [
                                                        ...(log?.sets ?? []),
                                                        Set.empty(
                                                          exerciseId:
                                                              exercise.id!,
                                                        ),
                                                      ],
                                                    );
                                                  });
                                                },
                                                child: Text(
                                                  'Add one more set!',
                                                ),
                                              ),
                                            ],
                                          ),
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
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton.filled(
                      icon: Icon(Icons.save, size: 32),
                      onPressed: () {
                        final temp = <String, Map<String, dynamic>>{};

                        for (final entry
                            in _formKey.currentState!.fields.entries) {
                          final match = RegExp(
                            r'^(kgs|reps)_(\d+)_(\d+)$',
                          ).firstMatch(entry.key);
                          if (match == null) continue;

                          final fieldType = match.group(1)!; // 'kgs' or 'reps'
                          final exerciseId = match.group(2)!;
                          final setIndex = match.group(3)!;

                          final key = '${exerciseId}_$setIndex';

                          temp.putIfAbsent(
                            key,
                            () => {
                              'exerciseId': int.parse(exerciseId),
                              'kgs': null,
                              'reps': null,
                            },
                          );

                          temp[key]![fieldType] = entry.value.value;
                        }

                        // Convert to Set objects
                        final sets = temp.values.map((m) {
                          return Set(
                            exerciseId: m['exerciseId'] as int,
                            kgs: (m['kgs'] ?? 0),
                            reps: (m['reps'] ?? 0),
                          );
                        }).toList();

                        if (log != null) {
                          context.read<LogBloc>().add(
                            AddLogsEvent([log!.copyWith(sets: sets)]),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
