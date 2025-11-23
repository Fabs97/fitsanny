import 'package:collection/collection.dart';
import 'package:fitsanny/bloc/log/log_cubit.dart';
import 'package:fitsanny/l10n/app_localizations.dart';
import 'package:fitsanny/model/log.dart';
import 'package:fitsanny/model/set.dart';
import 'package:fitsanny/model/training.dart';
import 'package:fitsanny/pages/logger/logger_cubit.dart';
import 'package:fitsanny/pages/logger/logger_set_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class LoggerDetails extends StatefulWidget {
  final Log? logToEdit;
  const LoggerDetails({super.key, this.logToEdit});

  @override
  State<LoggerDetails> createState() => _LoggerDetailsState();
}

class _LoggerDetailsState extends State<LoggerDetails> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  Log? log;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    LoggerState currentLoggerState = BlocProvider.of<LoggerCubit>(
      context,
    ).state;

    if (widget.logToEdit != null) {
      log = widget.logToEdit;
      context.read<LoggerCubit>().loadTraining(widget.logToEdit!.trainingId);
    } else {
      // New Log
      if (currentLoggerState.training != null) {
        _initializeNewLog(currentLoggerState.training!);
      }
    }
  }

  Future<void> _initializeNewLog(Training training) async {
    setState(() {
      isLoading = true;
    });

    final lastLog = await context.read<LogCubit>().getLatestLog(training.id!);
    final lastLogSets = lastLog?.sets ?? <Set>[];
    final trainingExercises = training.exercises;

    final newSets = trainingExercises.map((exercise) {
      // Try to find a matching set in the last log
      final matchingSet = lastLogSets.firstWhereOrNull(
        (s) => s.exerciseId == exercise.id,
      );

      if (matchingSet != null) {
        // Use values from the last log
        return Set(
          exerciseId: exercise.id!,
          reps: matchingSet.reps,
          kgs: matchingSet.kgs,
        );
      } else {
        // Use default values from the training
        return Set(
          exerciseId: exercise.id!,
          reps: exercise.reps,
          kgs: exercise.kgs,
        );
      }
    }).toList();

    if (mounted) {
      setState(() {
        log = Log(trainingId: training.id!, sets: newSets);
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || log == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final Map<int, List<Set>> setsGroupedByExerciseId = groupBy<Set, int>(
      log!.sets,
      (Set set) => set.exerciseId,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: BlocBuilder<LoggerCubit, LoggerState>(
        builder: (context, loggerState) {
          return FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FormBuilderDateTimePicker(
                  name: 'date',
                  initialValue: log?.createdAt ?? DateTime.now(),
                  inputType: InputType.date,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.dateLabel,
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                if (loggerState is ChosenTraining &&
                    loggerState.training != null &&
                    loggerState.training!.id == log!.trainingId)
                  Expanded(
                    child: ListView(
                      children: [
                        ...setsGroupedByExerciseId.entries.map((entry) {
                          final exerciseId = entry.key;
                          final sets = entry.value;
                          final exercise = loggerState.training!.exercises
                              .firstWhere((e) => e.id == exerciseId);

                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    exercise.exerciseName ?? 'Unknown',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  ...sets.asMap().entries.map((setEntry) {
                                    final setIndex = setEntry.key;
                                    final set = setEntry.value;
                                    return LoggerSetRow(
                                      idx: setIndex,
                                      exerciseId: exerciseId,
                                      reps: set.reps,
                                      kgs: set.kgs,
                                    );
                                  }),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          int index = (log?.sets ?? [])
                                              .lastIndexWhere(
                                                (s) =>
                                                    s.exerciseId == exerciseId,
                                              );
                                          if (index >= 0) {
                                            setState(() {
                                              log?.sets.removeAt(index);
                                            });
                                          }
                                        },
                                        child: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.removeSet,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            log = log?.copyWith(
                                              sets: [
                                                ...(log?.sets ?? []),
                                                Set.empty(
                                                  exerciseId: exerciseId,
                                                ),
                                              ],
                                            );
                                          });
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!.addSet,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  )
                else
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
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
                        _formKey.currentState?.save();
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
                          final date =
                              _formKey.currentState?.fields['date']?.value;
                          final updatedLog = log!.copyWith(
                            sets: sets,
                            createdAt: date,
                          );

                          if (widget.logToEdit != null) {
                            context.read<LogCubit>().updateLog(
                              updatedLog,
                              onComplete: (success, {data}) {
                                if (success) {
                                  Navigator.pop(context);
                                }
                              },
                            );
                          } else {
                            context.read<LogCubit>().addLogs(
                              [updatedLog],
                              onComplete: (success, {data}) {
                                if (success) {
                                  Navigator.pop(context);
                                }
                              },
                            );
                          }
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
